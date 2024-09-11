import 'package:flutter/material.dart';

class StoryPointingCard extends StatelessWidget {
  final int pointValue;
  final bool isSelected;
  final VoidCallback onTap;

  const StoryPointingCard({
    required this.pointValue,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            pointValue.toString(),
            style: TextStyle(
              fontSize: 24.0,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
