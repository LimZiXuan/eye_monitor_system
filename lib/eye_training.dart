import 'package:flutter/material.dart';

class EyeTraining extends StatefulWidget {
  const EyeTraining({Key? key}) : super(key: key);

  @override
  _EyeTrainingState createState() => _EyeTrainingState();
}

class _EyeTrainingState extends State<EyeTraining> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eye Training"),
        centerTitle: true,
      ),
      body: Text("EyeTraining"),
    );
  }
}
