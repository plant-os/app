import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'grow_state.dart';
part 'grow_event.dart';

class GrowBloc extends Bloc<GrowEvent, GrowState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  Grow grow;

  GrowBloc(this.grow) : super(GrowState.initial(grow: grow));

  void dispose() {}

  @override
  Stream<GrowState> mapEventToState(GrowEvent event) async* {
    print("handling event $event");
    if (event is GrowStartedEvent) {
      yield* _mapGrowStartedEventEventToState();
    } else if (event is GrowTextFieldChangedEvent) {
      yield* _mapGrowTextFieldChangedEventToState(event);
    } else if (event is GrowProgramChangedEvent) {
      yield* _mapGrowProgramChangedEventToState(event);
    } else if (event is GrowDeviceChangedEvent) {
      yield* _mapGrowDeviceChangedEventToState(event);
    } else if (event is GrowStartDateChangedEvent) {
      yield* _mapGrowStartDateChangedEventToState(event);
    } else if (event is GrowPressedEvent) {
      yield* _mapGrowPressedEventToState();
    }
  }

  Stream<GrowState> _mapGrowStartedEventEventToState() async* {
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
        var companyId = currentUser.company!.id;
        var programs = await programsService.list(companyId).first;
        var devices = await programsService.listDevices(companyId).first;

        yield state.update(
          isLoading: false,
          isFetched: true,
          programs: programs,
          devices: devices,
        );
      }
    } catch (e) {
      yield state.update(
        isLoading: false,
        error: "Failed to list programs: $e",
      );
    }
  }

  bool isValid() {
    return grow.name != "" &&
        grow.programId != null &&
        grow.deviceId != null &&
        grow.startDate != null;
  }

  Stream<GrowState> _mapGrowTextFieldChangedEventToState(
      GrowTextFieldChangedEvent event) async* {
    grow.name = event.name;

    // Set isFetched to false here as we want to ensure the text fields aren't
    // reset to the initial values.
    yield state.update(
      isValid: isValid(),
      isFetched: false,
    );
  }

  Stream<GrowState> _mapGrowProgramChangedEventToState(
      GrowProgramChangedEvent event) async* {
    grow = grow.copyWith(programId: event.program.id);
    yield state.update(
      isValid: isValid(),
      grow: grow,
    );
  }

  Stream<GrowState> _mapGrowDeviceChangedEventToState(
      GrowDeviceChangedEvent event) async* {
    grow = grow.copyWith(deviceId: event.device.id);
    yield state.update(
      isValid: isValid(),
      grow: grow,
    );
  }

  Stream<GrowState> _mapGrowStartDateChangedEventToState(
      GrowStartDateChangedEvent event) async* {
    grow = grow.copyWith(startDate: event.startDate);
    yield state.update(
      isValid: isValid(),
      isFetched: false,
      grow: grow,
    );
  }

  Stream<GrowState> _mapGrowPressedEventToState() async* {
    yield state.update(
      isLoading: true,
    );
    try {
      if (grow.id == null) {
        print("saving new grow: $grow");
        var docref = await programsService.addGrow(grow);
        grow = grow.copyWith(id: docref.id);
      } else {
        print("updating grow: $grow");
        await programsService.updateGrow(grow.id!, grow);
      }
      yield state.update(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      print(e);
      yield state.update(
        isLoading: false,
        isSuccess: false,
        error: "Failed to save grow: $e",
      );
    }
  }
}
