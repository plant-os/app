part of 'devices_bloc.dart';

class DevicesState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final List<Device> devices;
  final DateTime now;

  DevicesState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.error,
    required this.devices,
    required this.now,
  });

  factory DevicesState.initial({
    bool? isValid,
  }) {
    return DevicesState(
      isValid: isValid ?? false,
      isLoading: false,
      isSuccess: false,
      error: '',
      devices: [],
      now: DateTime.now(),
    );
  }

  DevicesState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<Device>? devices,
    DateTime? now,
  }) {
    return DevicesState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      devices: devices ?? this.devices,
      now: now ?? this.now,
    );
  }

  @override
  String toString() =>
      "DevicesState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, devices: $devices, now: $now}";

  @override
  bool operator ==(dynamic o) =>
      o is DevicesState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error &&
      listEquals(o.devices, devices) &&
      o.now == now;

  @override
  int get hashCode =>
      hashValues(isValid, isSuccess, isLoading, error, hashList(devices), now);
}
