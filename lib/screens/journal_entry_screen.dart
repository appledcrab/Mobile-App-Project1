// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  _JournalEntryScreenState createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  String _formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  String _formattedTime = DateFormat('h:mm a').format(DateTime.now());

  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Entry'),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _formattedDate,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formattedTime,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '😊', // --- CHANGE to the other moods we have... not sure how yet
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 340,
              child: Container(
                width: double.infinity,
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Start typing...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  maxLength: 500,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 200, //button sizing
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    String enteredText = _textEditingController.text;
                    print(
                        //going to use this when making the entry class and the entries.
                        'Entered text: $enteredText\n on $_formattedDate at $_formattedTime\n with the emotion 😊 ');
                    //(isnt done with other mood widget yet)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // will add functions when clicked
          //maybe changing emoji here
          //adding a photo onto this entry
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: JournalEntryScreen()));
