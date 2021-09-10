import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'grows_event.dart';
part 'grows_state.dart';

class GrowsBloc extends Bloc<GrowsEvent, GrowsState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  GrowsBloc() : super(GrowsState.initial());

  void dispose() {}

  @override
  Stream<GrowsState> mapEventToState(GrowsEvent event) async* {
    if (event is GrowsInitialFetchEvent) {
      yield* _mapGrowsInitialFetchEventToState();
    } else if (event is GrowsLoadedEvent) {
      yield* _mapGrowsLoadedEventToState(event);
    } else {
      throw "unhandled event: $event";
    }
  }

  Stream<GrowsState> _mapGrowsInitialFetchEventToState() async* {
    yield state.update(
      isLoading: true,
    );

    try {
      var firebaseUser = await authService.getCurrentUser();

      // To get the Programs belonging to the company we need the current user's
      // company id.
      var currentUser = await userService.getUserByEmail(firebaseUser!.email!);
      if (currentUser == null) {
        yield state.update(
          isLoading: false,
          error: "Failed to look up user",
        );
      } else {
        // Whenever the collection changes we pipe the new list into a
        // GrowsLoadedEvent event to update the state.
        programsService
            .listGrows(currentUser.company!.id)
            .listen((grows) => add(GrowsLoadedEvent(grows)));
      }
    } catch (e) {
      yield state.update(
        isLoading: false,
        error: "Failed to list programs: $e",
      );
    }
  }

  Stream<GrowsState> _mapGrowsLoadedEventToState(
      GrowsLoadedEvent event) async* {
    yield state.update(
      isLoading: false,
      grows: event.grows,
    );
  }
}
