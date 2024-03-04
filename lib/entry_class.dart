import 'emoji_icon_class.dart';

class JournalEntry {
  final String date;
  final String time;
  final String body;
  final EmojiIcon mood;

  JournalEntry({
    required this.date,
    required this.time,
    this.body = "Default Body Text",
    required this.mood,
  });
}
