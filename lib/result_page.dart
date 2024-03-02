import 'package:eye_monitor_system/color_blind_test.dart';
import 'package:eye_monitor_system/home_page.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int correctAnswersCount;

  const ResultPage({Key? key, required this.correctAnswersCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Test completed! Correct Answers: $correctAnswersCount',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ColorBlindTest()), // Replace with your fourth screen.
                  (route) => route.isFirst,
                  // Only allow the first screen to remain in the stack.
                );
              },
              child: Text('Restart Test'),
            ),
          ],
        ),
      ),
    );
  }
}
