import 'dart:async';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    if (event is AppDrawerStartedEvent) {
      yield* _mapAppDrawerStartedToState();
    } else if (event is AppDrawerPressLogoutEvent) {
      authService.logout();
    }
  }

  Stream<AppDrawerState> _mapAppDrawerStartedToState() async* {
    yield state.update(
      isLoading: true,
    );
    try {
      var firebaseUser = await authService.getCurrentUser();
      var currentUser = await userService.getUserByEmail(firebaseUser!.email!);

      if (currentUser == null) {
        // Display the error alert box.
        yield state.update(
          error: "User not found",
        );
        yield state.update(
          isLoading: false,
        );
      } else {
        yield state.update(
          isLoading: false,
          isFetched: true,
          user: currentUser,
        );
      }
    } catch (e) {
      print(e);
      yield state.update(
        isLoading: false,
        isFetched: false,
        error: "Failed to fetch user data: $e",
      );
    }
  }
}
