import 'dart:async';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/device_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'device_state.dart';
part 'device_event.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  DeviceService deviceService = DeviceService();

  final String deviceId;
  final String iotDeviceId;
  StreamSubscription<Device>? sub;

  DeviceBloc(this.deviceId, this.iotDeviceId) : super(DeviceState.initial());

  void dispose() {
    sub?.cancel();
  }

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {
    print("handling event $event");
    if (event is DeviceStartedEvent) {
      yield* _mapDeviceStartedEventToState();
    } else if (event is DeviceChangedEvent) {
      yield* _mapDeviceChangedEventToState(event);
    } else if (event is DevicePressedCommandEvent) {
      yield* _mapDevicePressedCommandEventToState(event);
    } else {
      throw "unhandled event: $event";
    }
  }

  Stream<DeviceState> _mapDeviceStartedEventToState() async* {
    yield state.update(
      isLoading: true,
    );

    var firebaseUser = await authService.getCurrentUser();
    var currentUser = await userService.getUserByEmail(firebaseUser!.email!);
    var isAdmin = currentUser?.role?.admin ?? false;

    yield state.update(
      showDebug: isAdmin,
    );

    try {
      deviceService.get(deviceId).listen((device) {
        add(DeviceChangedEvent(device));
      });
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield state.update(
        isLoading: false,
        error: "Failed to fetch device: $e",
      );
    }
  }

  Stream<DeviceState> _mapDeviceChangedEventToState(
      DeviceChangedEvent event) async* {
    yield state.update(
      isLoading: false,
      device: event.device,
    );
  }

  Stream<DeviceState> _mapDevicePressedCommandEventToState(
      DevicePressedCommandEvent event) async* {
    yield state.update(
      isLoading: true,
    );
    try {
      var user = await authService.getCurrentUser();
      if (user == null) {
        yield state.update(
          isLoading: false,
          error: "failed to generate token",
        );
        return;
      }

      var token = await user.getIdToken();
      var headers = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(
          'https://us-central1-plantos-development-225209.cloudfunctions.net/sendCommand');
      var response = await http.post(url, headers: headers, body: {
        'Command': event.command,
        'DeviceId': iotDeviceId,
        'RegistryId': 'fertigation',
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        var err = "status was ${response.statusCode}: ${response.body}";
        if (decodedResponse['details'] != null) {
          err = decodedResponse['details'] as String;
        }

        yield state.update(
          isLoading: false,
          error: "Failed to send command: $err",
        );
        yield state.update(
          isLoading: false,
          error: "",
        );
      } else {
        // OK.
        yield state.update(
          isLoading: false,
        );
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield state.update(
        isLoading: false,
        error: "Failed to send command: $e",
      );
    }
  }
}
