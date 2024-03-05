import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  const Result({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference user = FirebaseFirestore.instance.collection('User');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: user.doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(), // Loading indicator
            );
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: <DataColumn>[
              DataColumn(
                label: Text('Test'),
              ),
              DataColumn(
                label: Text('Diagnostic Result'),
              ),
            ], rows: [
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Ishihara Test')),
                  if (data['correctAnswersCount'] == 4)
                    DataCell(Text("You Are Not Color Blind"))
                  else
                    DataCell(Text("You Are Color Blind"))
                ],
              ),
            ]
                // rows: data.map((item) {
                //   return DataRow(
                //     cells: <DataCell>[
                //       if (data['correctAnswersCount'] == 4)
                //         DataCell(Text("You Are Not Color Blind"))
                //       else
                //         DataCell(Text("You Are Color Blind"))
                //     ],
                //   );
                // }).toList(),
                ),
          );
        },
      ),
    );
  }
}
