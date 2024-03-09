import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/journal'),
              child: Text('Journal Entry'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/mood'),
              child: Text('Mood Tracker'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/photo'),
              child: Text('Photo Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
