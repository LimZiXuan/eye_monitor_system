import 'package:eye_monitor_system/add_reminder.dart';
import 'package:eye_monitor_system/home_page.dart';
import 'package:eye_monitor_system/reminder.dart';
import 'package:eye_monitor_system/test_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new

class Home extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  final int selectedIndex; // Add selectedIndex as a parameter

  const Home({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isOnline = true;
  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.selectedIndex; // Set _selectedIndex from the parameter
  }

  void _onItemTapped(int index) {
    // checkInternetConnection().then((result) {
    //   setState(() {
    //     isOnline = result;
    //   });

    //   if (!isOnline && (index == 1 || index == 2 || index == 3 || index == 4)) {
    //     _showNoInternetSnackBar();
    //     return;
    //   }

    setState(() {
      _selectedIndex = index;
    });
    // });
  }

  void _showNoInternetSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('This feature is not available without internet connection.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  static int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Consumer<ApplicationState>(
      builder: (context, appState, _) => const HomePage(),
    ),
    Consumer<ApplicationState>(
      builder: (context, appState, _) => HomePage(),
    ),
    Consumer<ApplicationState>(
      builder: (context, appState, _) => const AddReminder(),
    ),
    Consumer<ApplicationState>(
      builder: (context, appState, _) => const Reminder(),
    ),
    Consumer<ApplicationState>(
      builder: (context, appState, _) => TestHistory(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primary,
        //backgroundColor: Color.fromARGB(255, 226, 208, 154),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
