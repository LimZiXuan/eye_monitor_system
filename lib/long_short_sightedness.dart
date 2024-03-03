import 'package:flutter/material.dart';

import 'long-sightedness.dart';
import 'short_sightedness.dart';

class LongShortSightedness extends StatefulWidget {
  const LongShortSightedness({Key? key}) : super(key: key);

  @override
  _LongShortSightednessState createState() => _LongShortSightednessState();
}

class _LongShortSightednessState extends State<LongShortSightedness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Long Short Sightedness"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ShortSightedness();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Short-sighted",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Also known as myopia, short-sightedness is a condition where distant objects appear blurry.",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LongSightedness();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Long-sighted",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Also known as hyperopia, long-sightedness is a condition where nearby objects appear blurry.",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
