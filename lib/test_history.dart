import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SortOption { All, Year, Month, Day }

class TestHistory extends StatefulWidget {
  const TestHistory({Key? key}) : super(key: key);

  @override
  State<TestHistory> createState() => _TestHistoryState();
}

class _TestHistoryState extends State<TestHistory> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  SortOption _sortOption = SortOption.All;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .collection('TestHistory')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            // Filter documents based on selected sort option
            List<DocumentSnapshot> filteredDocuments = documents;
            if (_sortOption == SortOption.Year) {
              filteredDocuments = documents.where((doc) {
                DateTime dateTime = (doc['timestamp'] as Timestamp).toDate();
                return dateTime.year == DateTime.now().year;
              }).toList();
            } else if (_sortOption == SortOption.Month) {
              filteredDocuments = documents.where((doc) {
                DateTime dateTime = (doc['timestamp'] as Timestamp).toDate();
                return dateTime.month == DateTime.now().month;
              }).toList();
            } else if (_sortOption == SortOption.Day) {
              filteredDocuments = documents.where((doc) {
                DateTime dateTime = (doc['timestamp'] as Timestamp).toDate();
                return dateTime.day == DateTime.now().day;
              }).toList();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton<SortOption>(
                    value: _sortOption,
                    onChanged: (SortOption? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _sortOption = newValue;
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: SortOption.All,
                        child: Text('All'),
                      ),
                      DropdownMenuItem(
                        value: SortOption.Year,
                        child: Text('By Year'),
                      ),
                      DropdownMenuItem(
                        value: SortOption.Month,
                        child: Text('By Month'),
                      ),
                      DropdownMenuItem(
                        value: SortOption.Day,
                        child: Text('By Day'),
                      ),
                    ],
                  ),
                  _buildTestResults('Color Blind Test', filteredDocuments),
                  _buildTestResults('Eye Training', filteredDocuments),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTestResults(String testType, List<DocumentSnapshot> documents) {
    final filteredDocuments =
        documents.where((doc) => doc['testType'] == testType).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            testType,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        DataTable(
          border: TableBorder.all(),
          columnSpacing: 12,
          columns: [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Details')),
          ],
          rows: filteredDocuments.map((doc) {
            // Convert Firestore timestamp to DateTime
            DateTime dateTime = (doc['timestamp'] as Timestamp).toDate();
            // Format Date and Time
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            String formattedTime = DateFormat('HH:mm').format(dateTime);
            return DataRow(cells: [
              DataCell(Text(formattedDate)),
              DataCell(Text(formattedTime)),
              DataCell(
                Text(testType == 'Color Blind Test'
                    ? doc['correctAnswersCount'].toString()
                    : doc['pass'] != null
                        ? doc['pass']
                            ? 'Passed'
                            : 'Failed'
                        : ''),
              ),
            ]);
          }).toList(),
        ),
      ],
    );
  }
}
