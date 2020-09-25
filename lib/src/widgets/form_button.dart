import 'package:flutter/material.dart';
import 'package:plantos/src/themes/colors.dart';

class FormButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  FormButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 14),
        child: SizedBox(
            height: 44,
            child: RaisedButton(
              color: blueColor,
              disabledColor: lightGreyColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child:
                  Text(text, style: TextStyle(fontSize: 16, color: whiteColor)),
              onPressed: onPressed,
            )));
  }
}
