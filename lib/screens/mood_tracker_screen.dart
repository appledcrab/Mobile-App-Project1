import 'package:flutter/material.dart';
import 'package:mad_project1/emoji_icon_class.dart';
import '../entry_class.dart';
import 'package:intl/intl.dart';
import '../emoji_icon_class.dart';

import '../database_helper.dart';
import 'journal_entry_screen.dart';
import 'edit_entry_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  List<JournalEntry> entries = [];
  DatabaseHelper dbHelper = DatabaseHelper();
  late SharedPreferences _prefs;
  late String _userName;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    final fetchedEntries = await dbHelper.getEntries();
    setState(() {
      entries = fetchedEntries.reversed
          .toList(); // reversing the list to be in order of most recent first
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _userName = _prefs.getString('userName') ?? '';
    if (_userName.isEmpty) {
      _showNameDialog();
    }
  }

  Future<void> _showNameDialog() async {
    String? newName = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter your name'),
        content: TextField(
          onChanged: (value) {
            setState(() {
              _userName = value;
            });
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _userName);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
    if (newName != null) {
      _prefs.setString('userName', newName);
    }
  }

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
              'Good morning $_userName!', //see if we can change the greeting based on time of day
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
              itemCount: entries.length,
              itemBuilder: (context, index) {
                EmojiIcon moodIcon = EmojiIcon(label: entries[index].moodLabel);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditEntryScreen(entry: entries[index]),
                      ),
                    ).then((_) => _fetchEntries());
                  },
                  child: ListTile(
                    title:
                        Text(entries[index].date + " " + entries[index].time),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entries[index].body.length > 50
                              ? '${entries[index].body.substring(0, 50)}...' // Limiting characters to 50
                              : entries[index].body,
                          style: TextStyle(fontSize: 16),
                        ),
                        if (entries[index].imageData != null)
                          Image.memory(
                            entries[index].imageData!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                    trailing: Icon(moodIcon.icon),
                  ),
                );
              },
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      JournalEntryScreen(selectedMood: "Neutral"),
                ),
              ).then((_) => _fetchEntries());
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalEntryScreen(selectedMood: label),
              ),
            ).then((_) => _fetchEntries());
          },
        ),
        Text(label),
      ],
    );
  }
}
