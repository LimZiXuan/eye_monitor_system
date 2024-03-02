import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        AppBar(
          title: Text("Home"),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Good Day, Would you like to give your eyes your check?",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Test 1",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Test 2",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Test 3",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[]),
        )
      ])),
    );
  }
}
