import 'package:flutter/material.dart';
import 'screens/unused_home_screen.dart';
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
      debugShowCheckedModeBanner: false, //to not show the banner
      title: 'Journal App',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/mood': (context) =>
            MoodTrackerScreen(), //main part, might change it to defaultly go there
        '/photo': (context) => PhotoUploadScreen(),
      },
    );
  }
}
