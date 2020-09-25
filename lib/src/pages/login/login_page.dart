import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocListener<LoginBloc, LoginState>(
        listener: _blocListener,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (_, state) => SafeArea(
            child: ListView(
              padding: EdgeInsets.all(30),
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: blackColor))),
                FormTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    onChanged: _onTextFieldChanged,
                    keyboardType: TextInputType.emailAddress),
                FormTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    onChanged: _onTextFieldChanged,
                    obscureText: true),
                FormButton(
                    text: 'Login',
                    onPressed: state.isValid ? _signInPressed : null)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
