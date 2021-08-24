import 'dart:async';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/user.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'appdrawer_event.dart';
part 'appdrawer_state.dart';

class AppDrawerBloc extends Bloc<AppDrawerEvent, AppDrawerState> {
  AuthService authService = AuthService();
  UserService userService = UserService();

  AppDrawerBloc() : super(AppDrawerState.initial());

  void dispose() {}

  @override
  Stream<AppDrawerState> mapEventToState(AppDrawerEvent event) async* {
    if (event is AppDrawerStarted) {
      yield* _mapAppDrawerStartedToState();
    } else if (event is AppDrawerPressLogout) {
      authService.logout();
    }
  }

  Stream<AppDrawerState> _mapAppDrawerStartedToState() async* {
    yield state.update(
      isLoading: true,
    );
    var firebaseUser = await authService.getCurrentUser();
    var currentUser =
        await userService.getCurrentUserDetails(firebaseUser!.email!);
    yield state.update(
      isLoading: false,
      user: currentUser,
    );
  }
}
