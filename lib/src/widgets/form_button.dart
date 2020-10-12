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
            height: 51,
            width: double.infinity,
            child: RaisedButton(
              color: blueColor,
              disabledColor: greyColor,
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
