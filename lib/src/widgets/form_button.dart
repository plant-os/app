import 'package:flutter/material.dart';
import 'package:plantos/src/themes/colors.dart';

class FormButton extends StatelessWidget {
  final String text;
  final Color? enabledColor;
  final Color? disbledColor;
  final Function()? onPressed;

  FormButton(
      {@required required this.text,
      @required this.onPressed,
      this.disbledColor,
      this.enabledColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 14),
        child: SizedBox(
            height: 51,
            child: RaisedButton(
              color: this.enabledColor != null ? enabledColor : blueColor,
              disabledColor:
                  this.disbledColor != null ? disbledColor : greyColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Text(text,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blackColor)),
              onPressed: onPressed,
            )));
  }
}
