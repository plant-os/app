part of 'grow_bloc.dart';

abstract class GrowEvent {}

class GrowStartedEvent extends GrowEvent {}

class GrowTextFieldChangedEvent extends GrowEvent {
  final String name;

  GrowTextFieldChangedEvent({
    required this.name,
  });
}

class GrowProgramChangedEvent extends GrowEvent {
  final Program program;

  GrowProgramChangedEvent({
    required this.program,
  });
}

class GrowDeviceChangedEvent extends GrowEvent {
  final Device device;

  GrowDeviceChangedEvent({
    required this.device,
  });
}

class GrowStartDateChangedEvent extends GrowEvent {
  final LocalDate startDate;

  GrowStartDateChangedEvent({
    required this.startDate,
  });
}

class GrowPlotChangedEvent extends GrowEvent {
  final int plot;

  GrowPlotChangedEvent({
    required this.plot,
  });
}

class GrowPressedEvent extends GrowEvent {}

class GrowDeletePressedEvent extends GrowEvent {}
