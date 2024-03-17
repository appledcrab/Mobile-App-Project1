class JournalEntry {
  final int? id;
  final String date;
  final String time;
  //these arent final because they should be able to be changed
  String body;
  String moodLabel; // Store the mood label instead of EmojiIcon
  String? imageData; // Nullable Uint8List for storing image data

  JournalEntry({
    this.id,
    required this.date,
    required this.time,
    required this.body,
    required this.moodLabel,
    this.imageData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'body': body,
      'moodLabel': moodLabel,
      'imageData': imageData,
    };
  }
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      body: map['body'],
      moodLabel: map['moodLabel'],
      imageData: map['imageData'], // This is the image path
    );
  }
}
