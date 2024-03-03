import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({Key? key}) : super(key: key);

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  bool test1Checked = false;
  bool test2Checked = false;
  bool test3Checked = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _saveReminders() {
    if (selectedDate != null && selectedTime != null) {
      DateTime reminderDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      FirebaseFirestore.instance.collection('Reminder').add({
        'test1': test1Checked,
        'test2': test2Checked,
        'test3': test3Checked,
        'reminderDateTime': Timestamp.fromDate(reminderDateTime),
        'uid': FirebaseAuth.instance.currentUser!.uid,
      }).then((_) {
        // Clear selections after saving
        setState(() {
          test1Checked = false;
          test2Checked = false;
          test3Checked = false;
          selectedDate = null;
          selectedTime = null;
        });
      }).catchError((error) {
        print("Failed to add reminder: $error");
        // Handle error here
      });
    } else {
      // Handle case where date or time is not selected
      print("Please select both date and time");
      // You can show a snackbar or any other UI feedback here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Reminder"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckboxListTile(
              title: Text("Colour Blind Test"),
              value: test1Checked,
              onChanged: (value) {
                setState(() {
                  test1Checked = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            CheckboxListTile(
              title: Text("Long Short Sightedness Test"),
              value: test2Checked,
              onChanged: (value) {
                setState(() {
                  test2Checked = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            CheckboxListTile(
              title: Text("Eye Training"),
              value: test3Checked,
              onChanged: (value) {
                setState(() {
                  test3Checked = value!;
                });
              },
            ),
            TextButton.icon(
              onPressed: () {
                _selectDate(context);
              },
              icon: Icon(Icons.calendar_today),
              label: Text(selectedDate == null
                  ? 'Select Date'
                  : 'Date: ${selectedDate!.toString().substring(0, 10)}'),
            ),
            SizedBox(height: 16.0),
            TextButton.icon(
              onPressed: () {
                _selectTime(context);
              },
              icon: Icon(Icons.access_time),
              label: Text(selectedTime == null
                  ? 'Select Time'
                  : 'Time: ${selectedTime!.format(context)}'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveReminders,
              child: Text('Save Reminders'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
