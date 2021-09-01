import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'dashed_border.dart';

class NewButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;

  const NewButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Color(0xFFEBF8F4),
          border: DashPathBorder.all(
            borderSide: BorderSide(color: Color(0xFF1FAD84)),
            dashArray: CircularIntervalList<double>(<double>[5.0, 2.5]),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/icon/plus.png", width: 19, height: 19),
                SizedBox(width: 9),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF1FAD84),
                    fontFamily: "Work Sans",
                    fontWeight: FontWeight.w600,
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewButtonBig extends StatelessWidget {
  final Widget child;
  final Function() onPressed;

  const NewButtonBig({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEBF8F4),
        border: DashPathBorder.all(
          borderSide: BorderSide(color: Color(0xFF1FAD84)),
          dashArray: CircularIntervalList<double>(<double>[5.0, 2.5]),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset("assets/icon/plus.png", width: 33, height: 33),
            Text(
              "New Schedule",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF1FAD84),
                fontFamily: "Work Sans",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
