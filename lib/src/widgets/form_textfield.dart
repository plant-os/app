import 'package:flutter/material.dart';
import 'package:plantos/src/themes/colors.dart';

class FormTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function() onChanged;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool obscureText;

  FormTextField(
      {@required this.hintText,
      @required this.controller,
      @required this.onChanged,
      this.keyboardType,
      this.readOnly,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: TextField(
            style: TextStyle(fontSize: 16, color: blackColor),
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                hintText: hintText,
                hintStyle: TextStyle(color: greyColor),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greyColor, width: 1.5)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: blueColor, width: 2))),
            controller: controller,
            onChanged: (_) => onChanged(),
            keyboardType: keyboardType ?? TextInputType.text,
            readOnly: readOnly ?? false,
            obscureText: obscureText ?? false));
  }
}
