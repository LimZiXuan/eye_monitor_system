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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => TableEventsExample()),
                  // );
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          // actions: [
          //   IconButton(
          //     icon: const FaIcon(FontAwesomeIcons.book),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => FieldGuide()),
          //       );
          //     },
          //   )
          // ],
        ),
        const SizedBox(height: 8),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(100.0),
        //   child: Image.asset(
        //     'assets/img/Bird1.jpg',
        //     fit: BoxFit.contain,
        //     // height: 600.0,
        //     //width: 400.0,
        //   ),
        // ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //add buttons here
                TextButton.icon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ImageClassification()),
                    // );
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Image ID'),
                ),
                // TextButton.icon(
                //   onPressed: () {
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //       builder: (context) =>
                //     //           CharacteristicIdentification()),
                //     // );
                //   },
                //   //icon: const FaIcon(FontAwesomeIcons.featherPointed),
                //   label: const Text("Characteristics ID"),
                // ),
              ]),
        )
      ])),
    );
  }
}
