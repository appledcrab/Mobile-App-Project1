import 'package:flutter/material.dart';
import 'screens/mood_tracker_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //to not show the banner
      title: 'Journal App',
      home: MoodTrackerScreen(),
    );
  }
}
