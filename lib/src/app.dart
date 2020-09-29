import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/crops/crops.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/pages/auth/auth_bloc.dart';
import 'package:plantos/src/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';

class App extends StatelessWidget {
  final AuthService authService = AuthService();
  final CropsService cropsService = CropsService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocProvider(
              create: (_) => AuthBloc()..add(AuthStartedEvent()),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (_, state) {
                  Widget homeWidget;
                  if (state is AuthUnauthenticatedState)
                    homeWidget = BlocProvider<LoginBloc>(
                        create: (_) => LoginBloc(authService),
                        child: LoginPage(authService));
                  else if (state is AuthAuthenticatedState)
                    homeWidget = CropsPage();
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
                },
              ),
            );
          }
        });
  }
}
