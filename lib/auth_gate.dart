import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home.dart';

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);

  Future<void> signInAnonymously(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print(userCredential);
      // Sign-in was successful, navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home(selectedIndex: 0)),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  // Future<bool> checkIsAdmin() async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   final DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user!.uid)
  //       .get();
  //   return userDoc.get('isAdmin');
  // }

  // bool isAdmin = false;
  // Future<void> checkAdmin() async {
  //   isAdmin = await checkIsAdmin();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            // If the user is already signed-in, use it as initial data
            initialData: FirebaseAuth.instance.currentUser,
            builder: (context, snapshot) {
              // User is not signed in
              if (!snapshot.hasData) {
                return SignInScreen(
                  showAuthActionSwitch: false,
                  // providerConfigs: const [
                  //   EmailProviderConfiguration(),
                  // ],
                  headerBuilder: (context, constraints, shrinkOffset) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          'assets/img/Bird11.png',
                        ),
                      ),
                    );
                  },
                  subtitleBuilder: (context, action) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child:
                            // action == AuthAction.signIn
                            //     ?
                            Row(
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 12,
                                // Change the color to match your app's theme
                              ),
                            ),
                            InkWell(
                              // onTap: () {
                              //   Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => Register(),
                              //     ),
                              //   );
                              // },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    // Color.fromRGBO(112, 93, 169, 1),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )
                        // : const Text(
                        //     'Welcome to Avian Nexus, please sign up!')
                        );
                  },
                  footerBuilder: (context, action) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              signInAnonymously(context);
                            },
                            child: Text("Sign In Anonymously"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'By signing in, you agree to our terms and conditions.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ]);
                  },
                  sideBuilder: (context, shrinkOffset) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          'assets/img/Bird3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Home(selectedIndex: 0);
              }
            }));
  }
}
