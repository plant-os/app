import 'package:flutter/material.dart';
import 'package:plantos/src/themes/colors.dart';

class Loading {
  BuildContext? loadingCtx;

  Loading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        loadingCtx = context;
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(blueColor),
          ),
        );
      },
    );
  }

  void close() {
    if (loadingCtx != null) {
      FocusScope.of(loadingCtx!).requestFocus(FocusNode());
      Navigator.pop(loadingCtx!);
    } else {
      print("loadingCtx is null");
    }
  }
}
