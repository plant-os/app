part of 'device_bloc.dart';

abstract class DeviceEvent {}

class DeviceStartedEvent extends DeviceEvent {}

class DeviceChangedEvent extends DeviceEvent {
  final Device device;

  DeviceChangedEvent(this.device);
}

class DevicePressedCommandEvent extends DeviceEvent {
  final String command;

  DevicePressedCommandEvent(this.command);
}
