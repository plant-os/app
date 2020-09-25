import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/crops/crops.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/pages/auth/auth_bloc.dart';
import 'package:plantos/src/pages/login/login.dart';

class App extends StatelessWidget {
  final AuthService authService;

  App(this.authService);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AuthBloc()..add(AuthStartedEvent()),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
          Widget homeWidget;
          if (state is AuthUnauthenticatedState)
            homeWidget = BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(authService), child: LoginPage());
          else if (state is AuthAuthenticatedState)
            homeWidget = Crops();
          else
            homeWidget = Scaffold();
          return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus.unfocus(),
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      fontFamily: 'Lato-Regular',
                      scaffoldBackgroundColor: whiteColor),
                  home: homeWidget));
        }));
  }
}
