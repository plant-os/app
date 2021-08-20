import 'package:flutter/material.dart';
import 'package:plantos/src/themes/colors.dart';

class SnackbarWithColor {
  final BuildContext context;
  final String text;
  final Color? color;

  SnackbarWithColor({
    required this.context,
    required this.text,
    this.color,
  }) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: color ?? blueColor,
      content: Text(
        text,
        style: TextStyle(fontSize: 16, color: whiteColor),
      ),
    ));
  }
}
