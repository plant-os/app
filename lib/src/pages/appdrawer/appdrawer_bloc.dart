import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/user.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'appdrawer_event.dart';
part 'appdrawer_state.dart';

class AppDrawerBloc extends Bloc<AppDrawerEvent, AppDrawerState> {
  AuthService authService = AuthService();
  UserService userService = UserService();

  AppDrawerBloc() : super(LoadingAppDrawerState()) {
    initialise();
  }

  @override
  Stream<AppDrawerState> mapEventToState(AppDrawerEvent event) async* {
    if (event is AppDrawerPressLogout) {
      authService.logout();
    } else if (event is AppDrawerUserLoaded) {
      yield* _mapUserToState(event);
    }
  }

  void initialise() async {
    var firebaseUser = await authService.getCurrentUser();

    var currentUser =
        await userService.getCurrentUserDetails(firebaseUser!.email!);
    add(AppDrawerUserLoaded(currentUser));
  }

  Stream<AppDrawerState> _mapUserToState(AppDrawerUserLoaded event) async* {
    yield DefaultAppDrawerState(event.user);
  }

  void dispose() {}
}
