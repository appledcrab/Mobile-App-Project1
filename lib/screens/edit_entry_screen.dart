import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../entry_class.dart';
import '../emoji_icon_class.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_lib;

class EditEntryScreen extends StatefulWidget {
  final JournalEntry entry;

  EditEntryScreen({required this.entry});

  @override
  _EditEntryScreenState createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late String _formattedDate;
  late String _formattedTime;
  late TextEditingController _textEditingController;
  late String _selectedMood;
  late EmojiIcon _moodIcon;
  final dbHelper = DatabaseHelper();
  File? _imageFile; // Nullable Uint8List for storing image data

  @override
  void initState() {
    super.initState();
    _formattedDate = widget.entry.date;
    _formattedTime = widget.entry.time;
    _textEditingController = TextEditingController(text: widget.entry.body);
    _selectedMood = widget.entry.moodLabel;
    _moodIcon = EmojiIcon(label: _selectedMood);
    if (widget.entry.imageData?.isNotEmpty ?? false) {
      _imageFile = File(widget.entry.imageData!);
    }
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
        title: Text('Edit Entry'),
        backgroundColor: Colors.green[300],
      ),
      backgroundColor: Color.fromARGB(255, 254, 231, 192),
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
                      _moodIcon.icon,
                      size: 50,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Container(
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
                ),
              ),
              // Display image widget
              SizedBox(height: 30),
              _buildImageWidget(),
              Center(
                child: ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Pick Image'),
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
                      JournalEntry updatedEntry = JournalEntry(
                        id: widget.entry.id,
                        date: _formattedDate,
                        time: _formattedTime,
                        body: enteredText,
                        moodLabel: _selectedMood,
                        imageData: _imageFile?.path, // Assign image data
                      );
                      await dbHelper.updateEntry(updatedEntry);
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
        onPressed: () async {
          await dbHelper.deleteEntry(widget.entry.id!);
          Navigator.pop(context);
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
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
          _moodIcon = emoji;
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

  Widget _buildImageWidget() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path_lib.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
      });
    }
  }
}
