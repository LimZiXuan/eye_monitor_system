import 'package:flutter/material.dart';

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
      body: Text("LongShortSightedness"),
    );
  }
}
