import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'programs_state.dart';
part 'programs_event.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  StreamSubscription<List<Program>>? sub;

  ProgramsBloc() : super(ProgramsState.initial());

  void dispose() {
    sub?.cancel();
  }

  @override
  Stream<ProgramsState> mapEventToState(ProgramsEvent event) async* {
    if (event is ProgramsInitialFetchEvent) {
      yield* _mapProgramsInitialFetchEventToState();
    } else if (event is ProgramsLoaded) {
      yield* _mapProgramsLoadedToState(event);
    } else if (event is ProgramsDeleteEvent) {
      programsService.delete(event.programId);
    }
  }

  Stream<ProgramsState> _mapProgramsInitialFetchEventToState() async* {
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
          error: "Failed to find user",
        );
      } else {
        // Whenever the list of programs changes we pipe the new list into a
        // ProgramsLoaded event.
        sub = programsService.list(currentUser.company!.id).listen((programs) {
          add(ProgramsLoaded(programs));
        });
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield state.update(
        isLoading: false,
        error: "Failed to list programs: $e",
      );
    }
  }

  Stream<ProgramsState> _mapProgramsLoadedToState(ProgramsLoaded event) async* {
    yield state.update(
      isFetched: true,
      isLoading: false,
      programs: event.programs,
    );
  }
}
