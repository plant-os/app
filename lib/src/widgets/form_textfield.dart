import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function() onChanged;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool obscureText;
  final bool autocorrect;

  FormTextField(
      {@required this.hintText,
      @required this.controller,
      @required this.onChanged,
      this.keyboardType,
      this.readOnly,
      this.obscureText,
      this.autocorrect = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51.0,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: TextField(
                controller: controller,
                cursorColor: Colors.black,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration.collapsed(
                  focusColor: Colors.transparent,
                  fillColor: Colors.transparent,
                  filled: true,
                  hoverColor: Colors.black,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: hintText,
                ),
                keyboardType: keyboardType ?? TextInputType.text,
                readOnly: readOnly ?? false,
                obscureText: obscureText ?? false,
                autocorrect: autocorrect,
                onChanged: (_) => onChanged(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
