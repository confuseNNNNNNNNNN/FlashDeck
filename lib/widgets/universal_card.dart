import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class UniversalCardView extends StatelessWidget {
  final String deckName;
  final String content;
  final Map<String, dynamic> metadata;

  const UniversalCardView({
    required this.deckName, 
    required this.content, 
    required this.metadata
  });

  @override
  Widget build(BuildContext context) {
    // 1. Engineering / Math: Use LaTeX
    if (deckName == "Engineering" || deckName == "Math") {
      return Center(
        child: Math.tex(
          content,
          textStyle: TextStyle(fontSize: 28),
        ),
      );
    }

    // 2. Polish / Language: Use Color Coding
    Color textColor = Colors.black;
    if (metadata['gender'] == 'M') textColor = Colors.blue.shade800;
    if (metadata['gender'] == 'F') textColor = Colors.pink.shade800;

    return Center(
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26, 
          fontWeight: FontWeight.bold,
          color: textColor
        ),
      ),
    );
  }
}