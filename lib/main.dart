import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/journal_entry_screen.dart';
import 'screens/mood_tracker_screen.dart';
import 'screens/photo_upload.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/journal': (context) => JournalEntryScreen(),
        '/mood': (context) => MoodTrackerScreen(),
        '/photo': (context) => PhotoUploadScreen(),
      },
    );
  }
}
