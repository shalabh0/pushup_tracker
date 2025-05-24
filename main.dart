import 'package:flutter/material.dart';
import 'package:pushup_tracker/screens/WelcomeScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';


 main() async {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushup Tracker',
      home: Welcomescreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
