import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  PrimaryButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      onPressed: onPressed,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  SecondaryButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFFEBF8F4),
        textStyle: TextStyle(
          fontSize: 14,
          fontFamily: "Work Sans",
          fontWeight: FontWeight.w400,
        ),
        primary: Color(0xFF1FAD84),
        minimumSize: Size(88, 36),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
      ),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
