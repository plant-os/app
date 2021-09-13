part of 'devices_bloc.dart';

abstract class DevicesEvent {}

class DevicesInitialFetchEvent extends DevicesEvent {}

class DevicesTimerTickEvent extends DevicesEvent {}

class DevicesLoadedEvent extends DevicesEvent {
  final List<Device> devices;

  DevicesLoadedEvent(this.devices);
}
