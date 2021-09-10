import 'package:flutter/material.dart';

class CardElement extends StatelessWidget {
  final Widget child;
  final Function() onEditPressed;
  final Function() onDeletePressed;

  const CardElement({
    Key? key,
    required this.child,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 17),
      child: Container(
        padding: EdgeInsets.only(left: 28, right: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        height: 77,
        child: Row(
          children: [
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontFamily: "Work Sans",
                  color: Color(0xFF28183D),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                child: child,
              ),
            ),
            GestureDetector(
              onTap: onEditPressed,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                    Image.asset("assets/icon/edit.png", width: 23, height: 23),
              ),
            ),
            GestureDetector(
              onTap: onDeletePressed,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                    Image.asset("assets/icon/bin.png", width: 23, height: 23),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
