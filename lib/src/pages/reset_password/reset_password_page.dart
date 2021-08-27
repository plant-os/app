import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/reset_password/reset_password.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/widgets/form_textfield.dart';

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        backgroundColor: blueColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: blackColor),
          backgroundColor: whiteColor,
          title: Text("Reset Password", style: TextStyle(color: blackColor)),
        ),
        body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listener: _blocListener,
          child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
            builder: (_, state) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Column(
                        children: [
                          ImageIcon(
                            AssetImage("assets/logo.png"),
                            color: whiteColor,
                            size: 100,
                          ),
                          Text(
                            "PlantOS",
                            style: TextStyle(fontSize: 30, color: whiteColor),
                          ),
                        ],
                      ),
                    ),
                    FormTextField(
                      hintText: 'Email',
                      controller: _emailController,
                      onChanged: _onTextFieldChanged,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SecondaryButton(
                      text: 'Reset Password',
                      onPressed: state.isValid ? _resetPasswordPressed : null,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
