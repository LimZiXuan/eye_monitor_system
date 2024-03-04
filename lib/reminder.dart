import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  late String currentUserUid;

  @override
  void initState() {
    super.initState();
    // Fetch the current user's UID
    getCurrentUserUid();
  }

  void getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserUid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminder"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Reminder').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No reminders found.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              bool test1 = data['test1'];
              bool test2 = data['test2'];
              bool test3 = data['test3'];
              if (data['uid'] != currentUserUid) {
                return SizedBox(); // Skip rendering if not matching with current user
              }
              bool test1Completed = data['test1Completed'];
              bool test2Completed = data['test2Completed'];
              bool test3Completed = data['test3Completed'];
              DateTime dateTime =
                  (data['reminderDateTime'] as Timestamp).toDate();
              return Card(
                  child: Column(
                children: [
                  ListTile(
                    title: Text(
                        'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}'),
                  ),
                  test1
                      ? ListTile(
                          title: Text('Colour Blind Test'),
                          trailing: Checkbox(
                            value: test1Completed,
                            onChanged: (bool? value) {
                              setState(() {
                                test1Completed = value!;
                                FirebaseFirestore.instance
                                    .collection('Reminder')
                                    .doc(document.id)
                                    .update({'test1Completed': value});
                              });
                            },
                          ),
                        )
                      : SizedBox(),
                  test2
                      ? ListTile(
                          title: Text('Long Short Sightedness Test'),
                          trailing: Checkbox(
                            value: test2Completed,
                            onChanged: (bool? value) {
                              setState(() {
                                test2Completed = value!;
                                FirebaseFirestore.instance
                                    .collection('Reminder')
                                    .doc(document.id)
                                    .update({'test2Completed': value});
                                // Update Firestore data here
                              });
                            },
                          ),
                        )
                      : SizedBox(),
                  test3
                      ? ListTile(
                          title: Text('Eye Training'),
                          trailing: Checkbox(
                            value: test3Completed,
                            onChanged: (bool? value) {
                              setState(() {
                                test3Completed = value!;
                                FirebaseFirestore.instance
                                    .collection('Reminder')
                                    .doc(document.id)
                                    .update({'test3Completed': value});
                                // Update Firestore data here
                              });
                            },
                          ),
                        )
                      : SizedBox(),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Reminder')
                          .doc(document.id)
                          .delete();
                    },
                    child: Text('Delete'),
                  ),
                ],
              ));
            }).toList(),
          );
        },
      ),
    );
  }
}
