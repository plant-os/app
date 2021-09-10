import 'package:flutter/material.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/widgets/close_button.dart';

import 'form_button.dart';

class DialogForm extends StatelessWidget {
  final Function()? onPressedSave;
  final Widget header;
  final Widget child;
  final bool isValid;

  const DialogForm({
    Key? key,
    required this.onPressedSave,
    required this.header,
    required this.child,
    this.isValid = true,
  }) : super(key: key);

  void _cancelPressed(BuildContext context) {
    // Return null to the caller to signal no changes.
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 42, 20, 42),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(children: [
            Padding(
              padding: EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  header,
                  CircularCloseButton(),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: child,
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 14, right: 14, top: 7),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Cancel',
                      onPressed: () => _cancelPressed(context),
                    ),
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Save',
                      onPressed: isValid ? onPressedSave : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
          ]),
        ),
      ),
    );
  }
}
