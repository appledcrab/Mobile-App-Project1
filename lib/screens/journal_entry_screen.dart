import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  _JournalEntryScreenState createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  String _formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  String _formattedTime = DateFormat('h:mm a').format(DateTime.now());

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
            Text(
              _formattedDate,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _formattedTime,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 100, // Lines displayed
                itemBuilder: (context, index) {
                  return TextField(
                    decoration: InputDecoration(
                      hintText: index == 0 ? 'Start typing...' : '',
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown, width: 0.5),
                      ),
                    ),
                    maxLines: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // will add functions when clicked
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: JournalEntryScreen()));
