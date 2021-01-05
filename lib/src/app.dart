import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/crops/crops.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';
import 'package:plantos/src/themes/colors.dart';
import 'package:plantos/src/pages/auth/auth_bloc.dart';
import 'package:plantos/src/pages/login/login.dart';

class App extends StatelessWidget {
  final AuthService authService = AuthService();
  final CropsService cropsService = CropsService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AuthBloc()..add(AuthStartedEvent()),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
          Widget homeWidget;
          if (state is AuthUnauthenticatedState) {
            homeWidget = BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(authService), child: LoginPage());
          } else if (state is AuthAuthenticatedState) {
            homeWidget = BlocProvider<CropsBloc>(
                create: (_) =>
                    CropsBloc(authService, cropsService, userService),
                child: CropsPage());
          } else if (state is AuthUninitializedState) {
            homeWidget = Scaffold();
          } else {
            throw new Exception("invalid auth state");
          }

          return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus.unfocus(),
              child: MaterialApp(
                  theme: ThemeData(
                      fontFamily: 'Lato-Regular',
                      appBarTheme:
                          AppBarTheme().copyWith(brightness: Brightness.light),
                      scaffoldBackgroundColor: whiteColor),
                  home: homeWidget));
        }));
  }
}
