import 'package:flutter/material.dart';
import 'auth_gate.dart';

final navigatorKey = GlobalKey<NavigatorState>();
bool isAdminApp = false;

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // const App({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: AuthGate(),
    );
  }
}
