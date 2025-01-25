import 'package:flutter/material.dart';

class TodoMaterialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;

  const TodoMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = const Color(0XFF318FFF),
    this.textColor = const Color(0XFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          overlayColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor, // Text color
          ),
        ),
      ),
    );
  }
}
