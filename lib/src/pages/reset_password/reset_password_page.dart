import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/reset_password/reset_password.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  Loading? _loading;
  late ResetPasswordBloc _resetPasswordBloc;

  void _onTextFieldChanged() {
    _resetPasswordBloc
        .add(ResetPasswordTextFieldChangedEvent(email: _emailController.text));
  }

  void _resetPasswordPressed() {
    _resetPasswordBloc.add(ResetPasswordPressedEvent());
  }

  void _blocListener(context, state) {
    if (state.isLoading) {
      _loading = Loading(context);
    } else if (state.isSuccess) {
      _emailController.text = '';
      _onTextFieldChanged();
      _loading?.close();
      SnackbarWithColor(
        color: greenColor,
        context: context,
        text: 'An email has been sent. Please click the link when you get it.',
      );
    } else if (state.error.isNotEmpty) {
      _loading?.close();
      SnackbarWithColor(context: context, text: state.error, color: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    _resetPasswordBloc = BlocProvider.of<ResetPasswordBloc>(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget buildContent(BuildContext context, ResetPasswordState state) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child:
                Image.asset("assets/logo/withtext.png", width: 144, height: 34),
          ),
          SizedBox(height: 43),
          Text(
            "Forgot password?",
            textAlign: TextAlign.center,
            style: titleStyle,
          ),
          SizedBox(height: 20),
          Text("Please enter your email here to reset your account",
              textAlign: TextAlign.center, style: textStyle),
          SizedBox(height: 20),
          TextField(
            controller: _emailController,
            onChanged: (val) => _onTextFieldChanged(),
            textAlign: TextAlign.start,
            decoration: textFieldDecoration,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
          SizedBox(height: 20),
          TextButton(
            style: state.isValid
                ? TextButton.styleFrom(backgroundColor: Color(0xFF1FAD84))
                : TextButton.styleFrom(backgroundColor: Color(0xFFC4C4C4)),
            onPressed: state.isValid ? _resetPasswordPressed : null,
            child: Center(
              child: Text("Send", style: btnLabelStyle),
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: blackColor),
        ),
        body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listener: _blocListener,
          child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
            builder: (_, state) => SafeArea(
              child: Padding(
                padding: standardPagePadding,
                child: buildContent(context, state),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
