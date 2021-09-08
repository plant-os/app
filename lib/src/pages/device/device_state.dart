part of 'device_bloc.dart';

class DeviceState {
  final bool isLoading;
  final String error;
  final Device? device;

  DeviceState({
    required this.isLoading,
    required this.error,
    required this.device,
  });

  factory DeviceState.initial() {
    return DeviceState(
      isLoading: false,
      error: '',
      device: null,
    );
  }

  DeviceState update({
    bool? isLoading,
    String? error,
    Device? device,
  }) {
    return DeviceState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      device: device ?? this.device,
    );
  }

  @override
  String toString() =>
      "DeviceState{isLoading: $isLoading, error: $error, device: $device}";
}
