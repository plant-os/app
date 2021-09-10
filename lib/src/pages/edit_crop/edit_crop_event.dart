part of 'edit_crop_bloc.dart';

abstract class EditCropEvent {}

class ClickSubmitEditCropEvent extends EditCropEvent {}

class ChangeCropStateEvent extends EditCropEvent {
  final String updatedCropState;
  ChangeCropStateEvent(this.updatedCropState);
}

class SetStartDateEvent extends EditCropEvent {
  final DateTime startDate;
  SetStartDateEvent(this.startDate);
}

class ChangeNameEvent extends EditCropEvent {
  final String name;
  ChangeNameEvent(this.name);
}

class ChangeEcEvent extends EditCropEvent {
  final String ec;
  ChangeEcEvent(this.ec);
}

class AddScheduleEvent extends EditCropEvent {
  final Schedule schedule;
  AddScheduleEvent(this.schedule);
}

class ChangeScheduleEvent extends EditCropEvent {
  final int index;
  final Schedule schedule;
  ChangeScheduleEvent(this.index, this.schedule);
}

class RemoveScheduleEvent extends EditCropEvent {
  final int index;
  RemoveScheduleEvent(this.index);
}

class DevicesLoadedEvent extends EditCropEvent {
  final List<Device> devices;
  DevicesLoadedEvent(this.devices);
}

class ChangeDeviceIdEvent extends EditCropEvent {
  final String deviceId;
  ChangeDeviceIdEvent(this.deviceId);
}