import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/drawer/appdrawer_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';
import 'package:plantos/src/pages/auth/auth_bloc.dart';
import 'package:plantos/src/pages/login/login.dart';
import 'pages/programs/programs_bloc.dart';
import 'pages/programs/programs_page.dart';
import 'services/programs_service.dart';

class App extends StatelessWidget {
  final AuthService authService = AuthService();
  final CropsService cropsService = CropsService();
  final UserService userService = UserService();
  final ProgramsService programsService = ProgramsService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AuthBloc()..add(AuthStartedEvent()),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
          Widget homeWidget;
          if (state is AuthUnauthenticatedState) {
            homeWidget = BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(), child: LoginPage());
          } else if (state is AuthAuthenticatedState) {
            homeWidget = BlocProvider<AppDrawerBloc>(
              create: (_) => AppDrawerBloc(),
              child: BlocProvider<ProgramsBloc>(
                  create: (_) => ProgramsBloc(), child: ProgramsPage()),
            );
          } else if (state is AuthUninitializedState) {
            homeWidget = Scaffold();
          } else {
            throw new Exception("invalid auth state");
          }

          var theme = ThemeData(
            fontFamily: "Work Sans",
            appBarTheme: AppBarTheme().copyWith(brightness: Brightness.light),
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
          );

          return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  home: homeWidget));
        }));
  }
}
