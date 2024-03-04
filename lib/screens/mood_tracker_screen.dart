import 'package:flutter/material.dart';
import 'package:mad_project1/emoji_icon_class.dart';
import '../entry_class.dart';
import 'package:intl/intl.dart';
import '../emoji_icon_class.dart';

class MoodTrackerScreen extends StatelessWidget {
  List<JournalEntry> entrys = [
    //currently using a list of journal entries for demonstration purposes, will be replaced with Entries from the input.
    //only using current time for these for demonstration purposes
    JournalEntry(
      date: DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      time: DateFormat('h:mm a').format(DateTime.now()),
      body: "Yippie!",
      mood: EmojiIcon(label: "Very Happy"),
    ),
    JournalEntry(
      date: DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      time: DateFormat('h:mm a').format(DateTime.now()),
      body: "oooh oh no ok ",
      mood: EmojiIcon(label: "Sad"),
    ),
    JournalEntry(
      date: DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      time: DateFormat('h:mm a').format(DateTime.now()),
      body: "AHHHHH",
      mood: EmojiIcon(label: "Very Sad"),
    ),
  ];
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
              itemCount: entrys.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(entrys[index].date + " " + entrys[index].time),
                  subtitle: Text(entrys[index].body),
                  trailing: Icon(entrys[index].mood.icon),
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
