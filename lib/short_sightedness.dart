import 'package:flutter/material.dart';

class ShortSightedness extends StatefulWidget {
  const ShortSightedness({Key? key}) : super(key: key);

  @override
  _ShortSightednessState createState() => _ShortSightednessState();
}

class _ShortSightednessState extends State<ShortSightedness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Short Sightedness"),
          centerTitle: true,
        ),
        body: Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/img/Snellen_chart.svg.webp', // Replace with your asset image path
            ),
            fit: BoxFit.cover,
          ),
        )));
  }
}
