import 'package:flutter/material.dart';

class LongSightedness extends StatefulWidget {
  const LongSightedness({Key? key}) : super(key: key);

  @override
  _LongSightednessState createState() => _LongSightednessState();
}

class _LongSightednessState extends State<LongSightedness> {
  List<String> letters = [
    "E",
    "F",
    "P",
    "T",
    "O",
    "Z",
    "L",
    "D",
    "C",
    "H"
  ]; // Example letters for the eye chart
  int currentLetterIndex = 0;
  double fontSize = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Long Sightedness Test"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What letter do you see?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              letters[currentLetterIndex],
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (currentLetterIndex < letters.length - 1) {
                    currentLetterIndex++;
                    fontSize -= 5.0; // Decrease font size for the next letter
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Test Completed'),
                        content: Text(
                            'You have completed the long-sightedness test.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
              child: Text('Next Letter'),
            ),
          ],
        ),
      ),
    );
  }
}
