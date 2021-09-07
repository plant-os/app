part of 'device_bloc.dart';

class DeviceState {
  final bool isLoading;
  final String error;

  DeviceState({
    required this.isLoading,
    required this.error,
  });

  factory DeviceState.initial() {
    return DeviceState(
      isLoading: false,
      error: '',
    );
  }
}
