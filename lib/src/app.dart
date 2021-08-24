import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/pages/appdrawer/appdrawer_bloc.dart';
import 'package:plantos/src/pages/auth/auth_bloc.dart';
import 'package:plantos/src/pages/grows/grows_bloc.dart';
import 'package:plantos/src/pages/grows/grows_page.dart';
import 'package:plantos/src/pages/login/login.dart';
import 'pages/programs/programs_bloc.dart';
import 'pages/programs/programs_page.dart';

var theme = ThemeData(
  fontFamily: "Work Sans",
  appBarTheme: AppBarTheme().copyWith(
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFF9F9F9),
    elevation: 0,
  ),
  scaffoldBackgroundColor: const Color(0xFFF9F9F9),
);

class App extends StatelessWidget {
  Widget authenticatedApp(BuildContext context) {
    return BlocProvider<AppDrawerBloc>(
      create: (_) => AppDrawerBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: '/programs',
        onGenerateRoute: (settings) {
          if (settings.name == '/programs') {
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => BlocProvider<ProgramsBloc>(
                create: (_) => ProgramsBloc(),
                child: ProgramsPage(),
              ),
            );
          } else {
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => BlocProvider<GrowsBloc>(
                create: (_) => GrowsBloc(),
                child: GrowsPage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget unauthenticatedApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(),
        child: LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc()..add(AuthStartedEvent()),
      child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
        print(state);

        Widget widget;
        if (state is AuthUnauthenticatedState) {
          widget = unauthenticatedApp(context);
        } else if (state is AuthAuthenticatedState) {
          widget = authenticatedApp(context);
        } else if (state is AuthUninitializedState) {
          widget = Container();
        } else {
          throw new Exception("invalid auth state");
        }

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: widget,
        );
      }),
    );
  }
}
