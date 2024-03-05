import 'package:eye_monitor_system/app.dart';
import 'package:eye_monitor_system/eye_training.dart';
import 'package:eye_monitor_system/long_short_sightedness.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_gate.dart';
import 'color_blind_test.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        AppBar(
          title: Text("Home"),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
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
                                MaterialPageRoute(
                                    builder: (context) => AuthGate()),
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
                // onPressed: () {

                // },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Good Day, Would you like to give your eyes a check?",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ColorBlindTest()));
                      },
                      child: _buildTestItem(
                        imagePath: 'assets/img/download.png',
                        text: 'Colour Blind Test',
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LongShortSightedness()));
                      },
                      child: _buildTestItem(
                        imagePath: 'assets/img/sight.png',
                        text: 'Long Short Sightedness',
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EyeTraining()));
                    },
                    child: _buildTestItem(
                      imagePath: 'assets/img/eye_training.png',
                      text: 'Eye Training',
                    ),
                  )
                ],
              ),
            )),
      ])),
    );
  }

  Widget _buildTestItem({required String imagePath, required String text}) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
