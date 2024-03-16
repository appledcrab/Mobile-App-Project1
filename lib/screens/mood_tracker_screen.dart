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

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'MoodMate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[300],
      ),
      backgroundColor: Color.fromARGB(255, 254, 231, 192),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${getGreeting()} ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: _userName + '!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 52, 134, 55),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 157, 196, 142).withOpacity(.4),
              borderRadius: BorderRadius.circular(10),
            ),
            // Set the background color here
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MoodIcon(Icons.sentiment_very_dissatisfied, 'Very Sad',
                    Color.fromARGB(255, 36, 93, 38)),
                MoodIcon(Icons.sentiment_dissatisfied, 'Sad',
                    Color.fromARGB(255, 36, 93, 38)),
                MoodIcon(Icons.sentiment_neutral, 'Neutral',
                    Color.fromARGB(255, 36, 93, 38)),
                MoodIcon(Icons.sentiment_satisfied, 'Happy',
                    Color.fromARGB(255, 36, 93, 38)),
                MoodIcon(Icons.sentiment_very_satisfied, 'Very Happy',
                    Color.fromARGB(255, 36, 93, 38)),
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 30,
            width: double.infinity,
            child: Container(
                color: Colors.green[300],
                child: Center(
                  child: Text(
                    'Your Journal Entries',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )),
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
                              ? '${entries[index].body.substring(0, 50)}...' // limiting characters that show up to 50
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

  Widget MoodIcon(IconData icon, String label, Color iconColor) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(
            icon,
            color: iconColor, // Set the color here
          ),
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
