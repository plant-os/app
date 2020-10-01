import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/reset_password/reset_password.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/utils/snackbar_with_color.dart';
import 'package:plantos/src/widgets/form_textfield.dart';
import 'package:plantos/src/widgets/form_button.dart';
import 'package:plantos/src/utils/loading.dart';
import 'package:plantos/src/pages/login/login_bloc.dart';
import 'package:plantos/src/pages/auth/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Loading _loading;
  LoginBloc _loginBloc;

  void _onTextFieldChanged() {
    _loginBloc.add(LoginTextFieldChangedEvent(
        email: _emailController.text, password: _passwordController.text));
  }

  void _signInPressed() {
    _loginBloc.add(LoginPressedEvent());
  }

  void _blocListener(context, state) {
    if (state.isLoading)
      _loading = Loading(context);
    else if (state.isSuccess) {
      _loading.close();
      BlocProvider.of<AuthBloc>(context).add(AuthLoggedInEvent());
    } else if (state.error.isNotEmpty) {
      _loading.close();
      SnackbarWithColor(context: context, text: state.error, color: Colors.red);
    }
  }

  void _forgotPasswordPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BlocProvider<ResetPasswordBloc>(
                create: (_) => ResetPasswordBloc(_loginBloc.authService),
                child: ResetPasswordPage())));
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: BlocListener<LoginBloc, LoginState>(
        listener: _blocListener,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (_, state) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 0),
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
                      keyboardType: TextInputType.emailAddress),
                  SizedBox.fromSize(size: Size.fromHeight(15.0)),
                  FormTextField(
                      hintText: 'Password',
                      controller: _passwordController,
                      onChanged: _onTextFieldChanged,
                      obscureText: true),
                  FormButton(
                      text: 'Sign in',
                      onPressed: state.isValid ? _signInPressed : null),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _forgotPasswordPressed(),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
