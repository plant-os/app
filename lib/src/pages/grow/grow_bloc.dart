import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/device_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'grow_state.dart';
part 'grow_event.dart';

class GrowBloc extends Bloc<GrowEvent, GrowState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();
  DeviceService deviceService = DeviceService();

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
    } else if (event is GrowPlotChangedEvent) {
      yield* _mapGrowPlotChangedEventToState(event);
    } else if (event is GrowDeletePressedEvent) {
      yield* _mapGrowDeletePressedEventToState();
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
        var devices = await deviceService.list(companyId).first;

        // Default this document to be owned by the creating users company.
        if (grow.companyId == null) {
          grow = grow.copyWith(companyId: companyId);
        }

        yield state.update(
          isLoading: false,
          isFetched: true,
          programs: programs,
          devices: devices,
          grow: grow,
        );
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
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
        grow.startDate != null &&
        grow.plot != null;
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
      grow: grow,
    );
  }

  Stream<GrowState> _mapGrowPlotChangedEventToState(
      GrowPlotChangedEvent event) async* {
    grow = grow.copyWith(plot: event.plot);
    yield state.update(
      isValid: isValid(),
      grow: grow,
    );
  }

  Stream<GrowState> _mapGrowDeletePressedEventToState() async* {
    if (grow.id == null) {
      return;
    }

    yield state.update(
      isLoading: true,
    );
    try {
      await programsService.deleteGrow(grow.id!);
      yield state.update(
        isSuccess: true,
        isLoading: false,
      );
    } catch (e, s) {
      print(e);
      FirebaseCrashlytics.instance.recordError(e, s);
      yield state.update(
        isLoading: false,
        isSuccess: false,
        error: "Failed to delete grow: $e",
      );
    }
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
        isSuccess: true,
        isLoading: false,
      );
    } catch (e, s) {
      print(e);
      FirebaseCrashlytics.instance.recordError(e, s);
      yield state.update(
        isLoading: false,
        isSuccess: false,
        error: "Failed to save grow: $e",
      );
    }
  }
}
