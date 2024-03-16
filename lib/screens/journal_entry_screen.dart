import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database_helper.dart';
import '../entry_class.dart';
import '../emoji_icon_class.dart';

class JournalEntryScreen extends StatefulWidget {
  final String selectedMood;

  JournalEntryScreen({Key? key, required this.selectedMood}) : super(key: key);

  @override
  _JournalEntryScreenState createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final dbHelper = DatabaseHelper();
  String _formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  String _formattedTime = DateFormat('h:mm a').format(DateTime.now());
  TextEditingController _textEditingController = TextEditingController();
  late String _selectedMood;
  late EmojiIcon moodIcon;
  File? _image; // Variable to store the selected image

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.selectedMood;
    moodIcon = EmojiIcon(label: _selectedMood);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Journal Entry'),
        backgroundColor: Colors.green[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  GestureDetector(
                    onTap: () {
                      _showMoodPicker(context);
                    },
                    child: Icon(
                      moodIcon.icon,
                      size: 50,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 200, // Specify a fixed height for the text entry box
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Start typing...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        maxLength: 250,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    if (_image != null)
                      Image.file(_image!), // Display the selected image
                    ElevatedButton(
                      onPressed: _getImage,
                      child: Text('Pick Image'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      String enteredText = _textEditingController.text;
                      JournalEntry entry = JournalEntry(
                        date: _formattedDate,
                        time: _formattedTime,
                        body: enteredText,
                        moodLabel: _selectedMood,
                        imageData:
                            _image != null ? await _image!.readAsBytes() : null,
                      );
                      dbHelper.insertEntry(entry);
                      Navigator.pop(context);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showMoodPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How are you feeling?'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildMoodOption(EmojiIcon(label: "Very Sad"), context),
                _buildMoodOption(EmojiIcon(label: "Sad"), context),
                _buildMoodOption(EmojiIcon(label: "Neutral"), context),
                _buildMoodOption(EmojiIcon(label: "Happy"), context),
                _buildMoodOption(EmojiIcon(label: "Very Happy"), context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodOption(EmojiIcon emoji, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = emoji.label;
          moodIcon = emoji;
        });
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          emoji.icon,
          size: 50,
        ),
      ),
    );
  }

  // Method to pick an image from the device
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery); // Pick image from gallery
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Set the selected image file
      });
    }
  }
}
