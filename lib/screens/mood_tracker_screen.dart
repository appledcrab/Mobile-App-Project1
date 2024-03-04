import 'package:flutter/material.dart';

class MoodTrackerScreen extends StatelessWidget {
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Mood Tracker'),
      backgroundColor: Colors.green[300],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Good morning YourName!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'How are you feeling today?',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MoodIcon(Icons.sentiment_very_dissatisfied, 'Very Sad'),
            MoodIcon(Icons.sentiment_dissatisfied, 'Sad'),
            MoodIcon(Icons.sentiment_neutral, 'Neutral'),
            MoodIcon(Icons.sentiment_satisfied, 'Happy'),
            MoodIcon(Icons.sentiment_very_satisfied, 'Very Happy'),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 1, 
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('March 2, 2024'),
                subtitle: Text('This is just an exampel'),
                trailing: Icon(Icons.sentiment_satisfied),
              );
            },
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            // will add functions when clicked
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ],
    ),
  );
}

Widget MoodIcon(IconData icon, String label) {
  return Column(
    children: <Widget>[
      IconButton(
        icon: Icon(icon),
        iconSize: 36,
        onPressed: () {
          // will add functions when clicked
        },
      ),
      Text(label),
    ],
  );
}
}

void main() => runApp(MaterialApp(home: MoodTrackerScreen()));
