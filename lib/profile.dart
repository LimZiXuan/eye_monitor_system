import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eye_monitor_system/app.dart';
import 'package:eye_monitor_system/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'auth_gate.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isOnline = true;

  TextEditingController _displayNameController = TextEditingController();
  String? _displayName;
  bool _isEditing = false;
  // FocusNode _displayNameFocusNode = FocusNode();
  TextEditingController _phoneController = TextEditingController();
  String? _phone;
  TextEditingController _genderController = TextEditingController();
  String? _gender;
  TextEditingController _emailController = TextEditingController();
  String? _email;
  TextEditingController _dobController = TextEditingController();
  String? _dob;
  final FirebaseAuth auth = FirebaseAuth.instance;
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  var isAdmin = false;
  bool _isMounted = false;
  static const String sampleEmail = "tony@starkindustries.com";
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    _displayName = FirebaseAuth.instance.currentUser?.displayName;
    _displayNameController.text = _displayName ?? '';
    FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .get()
        .then((userData) {
      setState(() {
        _displayName = userData['userName'];
        _displayNameController.text = _displayName ?? '';
        _phone = userData['phoneNumber'];
        _phoneController.text = _phone ?? '';
        _gender = userData['gender'];
        _genderController.text = _gender ?? '';
        _email = user?.email ?? userData['email'];
        _emailController.text = _email ?? '';
        _dob = userData['dob'];
        _dobController.text = _dob ?? '';
      });
    }).catchError((error) {
      print('Error fetching user data: $error');
      // Handle error gracefully
    });
    if (_displayName == null || _displayName!.isEmpty) {
      // User's display name is null, autofocus the TextField
      _isEditing = true;
      // _displayNameFocusNode.requestFocus();
    }
    _isMounted = true; // Set the flag to true when the widget is mounted
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        //final imageFile = File(pickedFile.path);
        final imageFile = File(_croppedFile!.path);
        print(imageFile.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${currentUser?.uid}');

        final userId = currentUser!.uid;
        final userDocRef =
            FirebaseFirestore.instance.collection('User').doc(userId);
        await storageRef.putFile(imageFile);

        final imageUrl = await storageRef.getDownloadURL();

        // Update the user's profile with the new image URL.
        await currentUser?.updatePhotoURL(imageUrl);
        await userDocRef.update({'profileUrl': imageUrl});
        // Refresh the UI to display the updated image.
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image updated successfully')),
        );
      } catch (e) {
        print('Error updating profile image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile image: $e')),
        );
      }
    }
  }

  Future<void> _updateProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      _cropImage();
    }
  }

  void _updateDisplayName(String newDisplayName) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(newDisplayName);
      final userId = currentUser!.uid;
      final userDocRef =
          FirebaseFirestore.instance.collection('User').doc(userId);

      await userDocRef.update({'userName': newDisplayName});
      if (mounted) {
        setState(() {
          _displayName = newDisplayName;
          _isEditing = false; // Disable editing mode after updating.
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Display name updated successfully')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating display name: $e')),
        );
      }
    }
  }

  void _updateProfile() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final userId = currentUser!.uid;
      final userDocRef =
          FirebaseFirestore.instance.collection('User').doc(userId);

      // Update the fields in Firestore
      await userDocRef.update({
        'userName': _displayNameController.text,
        'phoneNumber': _phoneController.text,
        'gender': _gender,
        'dob': _dobController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  void _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    // Show a dialog to ask for the user's password
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String password = ''; // Store the entered password

        return AlertDialog(
          title: Text('Re-authenticate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true, // Hide the password as dots
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Create a credential with the entered password
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: password,
                  );

                  // Re-authenticate the user with the provided credential
                  await user.reauthenticateWithCredential(credential);
                  FirebaseFirestore.instance
                      .collection('User')
                      .doc(user.uid)
                      .delete();
                  // User is now re-authenticated, proceed to delete the account
                  await user.delete();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Your account has been successfully deleted. You will be logged out soon.'),
                    ),
                  );
                  Navigator.of(context).pop();
                  await Future.delayed(Duration(seconds: 2));

                  navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthGate()),
                    (route) => false,
                  );
                  // Close the dialog

                  // You can also navigate to a login or home screen after deleting the account
                } catch (e) {
                  print('Error re-authenticating: $e');
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(
                          'Error re-authenticating: The password is invalid or the user does not have a password.'),
                    ),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final photoURl = auth.currentUser!.photoURL;
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          GestureDetector(
            onTap: () {
              _updateProfileImage();
            },
            child: Center(
                child: CircleAvatar(
              radius: 80,
              backgroundImage:
                  FirebaseAuth.instance.currentUser?.photoURL != null
                      ? NetworkImage(
                          FirebaseAuth.instance.currentUser?.photoURL ?? '',
                        )
                      : null,
              child: FirebaseAuth.instance.currentUser?.photoURL == null
                  ? Icon(Icons.person, size: 50)
                  : null,
            )),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Email: ${FirebaseAuth.instance.currentUser?.email}"),
                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(labelText: 'Display Name'),
                  onChanged: (value) => _displayName = value,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null; // Return null if validation passes
                  },
                ),
                // TextFormField(
                //   controller: _emailController,
                //   decoration: InputDecoration(labelText: 'Email Address'),
                //   keyboardType: TextInputType.emailAddress,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your email address';
                //     }
                //     if (!RegExp(
                //             r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                //         .hasMatch(value)) {
                //       return 'Please enter a valid email address';
                //     }
                //     return null;
                //   },
                // ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  onChanged: (newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  },
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _dobController.text =
                            picked.toString().substring(0, 10);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  _updateProfile();
                },
                child: Text('Save'),
              )),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              showDialog(
                //show a dialog box to confirm sign out
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Sign out the user and navigate to the authentication screen
                        try {
                          await FirebaseAuth.instance.signOut();
                          navigatorKey.currentState?.pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => AuthGate()),
                            (route) => false,
                          );
                        } catch (e) {
                          print('Error signing out: $e');
                          // Handle the error gracefully, e.g., show an error message
                        }
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.logout),
            label: Text('Sign Out'),
          ),
        ])));
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    // _displayNameFocusNode.dispose();
    super.dispose();
    _isMounted = false;
  }
}
