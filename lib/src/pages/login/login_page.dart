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
  Loading? _loading;
  late LoginBloc _loginBloc;

  void _onTextFieldChanged() {
    _loginBloc.add(LoginTextFieldChangedEvent(
        email: _emailController.text, password: _passwordController.text));
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

  Widget buildContent(BuildContext context, LoginState state) {
    const titleStyle = TextStyle(
      color: Color(0xff28183d),
      fontSize: 25,
      fontFamily: "Work Sans",
      fontWeight: FontWeight.w600,
    );

    const textStyle = TextStyle(
        color: Color(0xff28183d),
        fontSize: 13,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.normal);

    const textLinkStyle = TextStyle(
        color: Color(0xff6e6e6e),
        fontSize: 14,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    const textLinkHighlightStyle = TextStyle(
        color: Color(0xff1FAD84),
        fontSize: 14,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    const labelStyle = TextStyle(
        color: Color(0xff28183d),
        fontSize: 14,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    const btnLabelStyle = TextStyle(
        color: Color(0xffffffff),
        fontSize: 14,
        fontFamily: "Work Sans",
        fontWeight: FontWeight.w500);

    var textFieldDecoration = InputDecoration(
      isCollapsed: true,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      hintText: '',
      isDense: true,
    );

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("assets/logo/withtext.png"),
          ),
          SizedBox(height: 43),
          Text(
            "Welcome back!",
            textAlign: TextAlign.center,
            style: titleStyle,
          ),
          SizedBox(height: 20),
          Text(
              "Please fill out the information below to connect to your account",
              textAlign: TextAlign.center,
              style: textStyle),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email", style: labelStyle),
              SizedBox(height: 9),
              TextField(
                controller: _emailController,
                onChanged: (val) => _onTextFieldChanged(),
                textAlign: TextAlign.start,
                decoration: textFieldDecoration,
                keyboardType: TextInputType.text,
                autocorrect: false,
              ),
            ],
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Password", style: labelStyle),
              SizedBox(height: 9),
              TextField(
                controller: _passwordController,
                onChanged: (val) => _onTextFieldChanged(),
                obscureText: true,
                textAlign: TextAlign.start,
                decoration: textFieldDecoration,
                keyboardType: TextInputType.text,
                autocorrect: false,
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
              height: 40,
              child: TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Color(0xFF1FAD84)),
                  onPressed: state.isValid
                      ? () {
                          _loginBloc.add(LoginPressedEvent());
                        }
                      : null,
                  child: Center(child: Text("Sign in", style: btnLabelStyle)))),
          SizedBox(height: 20),
          Center(
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _forgotPasswordPressed(),
                child: RichText(
                  text: TextSpan(
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'Forgot your password? ', style: textLinkStyle),
                      TextSpan(text: 'Reset it', style: textLinkHighlightStyle),
                    ],
                  ),
                )),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isLoading)
              _loading = Loading(context);
            else if (state.isSuccess) {
              _loading?.close();
              BlocProvider.of<AuthBloc>(context).add(AuthLoggedInEvent());
            } else if (state.error.isNotEmpty) {
              _loading?.close();
              SnackbarWithColor(
                  context: context, text: state.error, color: Colors.red);
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 82),
                child: buildContent(context, state),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
