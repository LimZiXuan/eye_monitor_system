import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_gate.dart';
// import 'model.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool emailExists = false;
  bool isRegistering = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  File? file;
  var options = [
    'User',
    'Admin',
  ];
  var _currentItemSelected = "User";
  var userRole = "User";
  var isAdmin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromARGB(255, 233, 214, 184), // Background color
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        //margin: EdgeInsets.all(12),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align content to the left
                            children: [
                              Container(
                                // color:
                                //     const Color.fromARGB(255, 36, 42, 104),
                                constraints: BoxConstraints(maxHeight: 150),
                                // height: MediaQuery.of(context).size.height * 0.2,
                                // width: double.infinity,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.asset(
                                      'assets/img/Bird11.png',
                                    ),
                                  ),
                                ),
                                // child: Center(
                                //   child: Column(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.center,
                                //     children: [
                                //       Text(
                                //         'Welcome to',
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 28,
                                //         ),
                                //       ),
                                //       Text(
                                //         'Avian Nexus',
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 28,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Register",
                                      style: TextStyle(
                                        fontSize: 24,
                                        //color: Colors.black,
                                      ))),
                              Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Already have an account? ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          //color: Colors.black,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AuthGate(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Email is required";
                                    }
                                    if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return ("Please enter a valid email");
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  //obscureText: _isObscure,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                  ),
                                  validator: (value) {
                                    RegExp regex = new RegExp(r'^.{6,}$');
                                    if (value!.isEmpty) {
                                      return "Password is required";
                                    }
                                    if (!regex.hasMatch(value)) {
                                      return ("please enter valid password min. 6 character");
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                  obscureText:
                                      true, // Make the password invisible
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  controller: confirmpassController,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Confirm password is required";
                                    }
                                    if (confirmpassController.text !=
                                        passwordController.text) {
                                      return "Password did not match";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                  obscureText:
                                      true, // Make the password invisible
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Display CircularProgressIndicator when registering and without errors

                                  // if (isRegistering &&
                                  //     !emailExists &&
                                  //     _formkey.currentState!.validate())
                                  //   CircularProgressIndicator()
                                  // else
                                  isRegistering && !emailExists
                                      ? CircularProgressIndicator()
                                      : OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                45),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            foregroundColor:
                                                Theme.of(context).primaryColor,
                                            side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 127, 123, 132),
                                            ),
                                          ),
                                          onPressed: () {
                                            checkEmailExists(
                                                emailController.text);
                                            setState(() {});
                                            // signUp(
                                            //     emailController.text,
                                            //     passwordController.text,
                                            //     userRole);
                                          },
                                          child: Text(
                                            "Register",
                                          ),
                                        ),
                                ],
                              ),
                              Center(
                                child: Visibility(
                                  visible:
                                      emailExists, // Show the message only if emailExists is true
                                  child: Text(
                                    'Account with such email already exists',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(25),
                                child: Text(
                                  'By signing in, you agree to our terms and conditions.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  // create a function to call signup if email does not exist
  void checkEmailExists(String email) async {
    if (_formkey.currentState!.validate()) {
      try {
        final List<String> signInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (signInMethods.isEmpty) {
          // The email address is not registered, you can proceed with registration
          setState(() {
            emailExists = false;
            isRegistering = true;
            print(
                "The email address is not registered, you can proceed with registration");
          });
          signUp(emailController.text, passwordController.text, userRole);
        } else {
          setState(() {
            emailExists = true;
          });
        }
      } catch (signUpError) {
        setState(() {
          emailExists = true; // Set the emailDuplicate flag
        });
      }
    }
  }

  void signUp(String email, String password, String userRole) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, userRole)})
          .catchError((e) {
        print(e);
      }).whenComplete(() {
        setState(() {
          isRegistering = false;
        });
      });
    }
  }

  postDetailsToFirestore(String email, String userRole) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    if (userRole == "Admin") {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    CollectionReference ref = FirebaseFirestore.instance.collection('User');
    ref.doc(user!.uid).set({
      'email': emailController.text,
      // 'userRole': userRole,
      'uid': user.uid,
      // 'isAdmin': isAdmin,
      'createdAt': DateTime.now(),
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthGate()));
  }
}
