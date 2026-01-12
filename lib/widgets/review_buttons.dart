import 'package:flutter/material.dart';

class ReviewButtons extends StatelessWidget {
  final Function(int) onRated;
  final bool allowEasy;

  const ReviewButtons({required this.onRated, required this.allowEasy});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _btn("Forgot", Colors.red, 0, true),
        _btn("Hard", Colors.orange, 3, true),
        _btn("Okay", Colors.blue, 4, allowEasy),
        _btn("Easy", Colors.green, 5, allowEasy),
      ],
    );
  }

  Widget _btn(String label, Color color, int quality, bool enabled) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: enabled ? color : Colors.grey),
      onPressed: enabled ? () => onRated(quality) : null,
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}