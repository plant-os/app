import 'package:flutter/material.dart';

/// A rectangular box that can be used to add a border to text boxes and
/// drop-down buttons.
class FieldBox extends StatelessWidget {
  final Widget? child;

  const FieldBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFDBDBDB),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}
