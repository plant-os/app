import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/device_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  DeviceService deviceService = DeviceService();

  StreamSubscription<List<Device>>? sub;

  Timer? timer;

  DevicesBloc() : super(DevicesState.initial());

  void dispose() {
    timer?.cancel();
    sub?.cancel();
  }

  @override
  Stream<DevicesState> mapEventToState(DevicesEvent event) async* {
    if (event is DevicesInitialFetchEvent) {
      yield* _mapDevicesInitialFetchEventToState();
    } else if (event is DevicesLoadedEvent) {
      yield* _mapDevicesLoadedEventToState(event);
    } else if (event is DevicesTimerTickEvent) {
      yield* _mapDevicesTimerTickEventToState();
    } else {
      throw "unhandled event: $event";
    }
  }

  Stream<DevicesState> _mapDevicesInitialFetchEventToState() async* {
    yield state.update(
      isLoading: true,
    );

    try {
      var firebaseUser = await authService.getCurrentUser();

      // To get the Devices belonging to the company we need the current user's
      // company id.
      var currentUser = await userService.getUserByEmail(firebaseUser!.email!);
      if (currentUser == null) {
        yield state.update(
          isLoading: false,
          error: "Failed to look up user",
        );
      } else {
        // Whenever the collection changes we pipe the new list into a
        // DevicesLoadedEvent event to update the state.
        sub = deviceService
            .list(currentUser.company!.id)
            .listen((grows) => add(DevicesLoadedEvent(grows)));
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield state.update(
        isLoading: false,
        error: "Failed to list devices: $e",
      );
    }

    // Create a periodic timer for updating the online/offline status.
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      add(DevicesTimerTickEvent());
    });
  }

  Stream<DevicesState> _mapDevicesLoadedEventToState(
      DevicesLoadedEvent event) async* {
    yield state.update(
      isLoading: false,
      devices: event.devices,
    );
  }

  Stream<DevicesState> _mapDevicesTimerTickEventToState() async* {
    yield state.update(
      now: DateTime.now(),
    );
  }
}
