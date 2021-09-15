part of 'device_bloc.dart';

class DeviceState {
  final bool isLoading;
  final String error;
  final Device? device;
  final bool showDebug;

  DeviceState({
    required this.isLoading,
    required this.error,
    required this.device,
    required this.showDebug,
  });

  factory DeviceState.initial() {
    return DeviceState(
      isLoading: false,
      error: '',
      device: null,
      showDebug: false,
    );
  }

  DeviceState update({
    bool? isLoading,
    String? error,
    Device? device,
    bool? showDebug,
  }) {
    return DeviceState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      device: device ?? this.device,
      showDebug: showDebug ?? this.showDebug,
    );
  }

  @override
  String toString() =>
      "DeviceState{isLoading: $isLoading, error: $error, device: $device, showDebug: $showDebug}";
}
