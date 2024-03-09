import 'package:flutter/material.dart';

class EmojiIcon {
  final IconData icon;
  final String label;

  EmojiIcon({required this.label}) : icon = moodAssign(label);

  static IconData moodAssign(String label) {
    switch (label) {
      case "Very Sad":
        return Icons.sentiment_very_dissatisfied;
      case "Sad":
        return Icons.sentiment_dissatisfied;
      case "Neutral":
        return Icons.sentiment_neutral;
      case "Happy":
        return Icons.sentiment_satisfied;
      case "Very Happy":
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
