import 'package:flutter/material.dart';

class CircularCloseButton extends StatelessWidget {
  const CircularCloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 25,
        height: 25,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          icon: Image.asset(
            "assets/icon/close.png",
          ),
        ));
  }
}
