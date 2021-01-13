part of 'edit_crop_bloc.dart';

abstract class EditCropEvent {}

class EditCropFieldChangedEvent extends EditCropEvent {
  final Crop crop;
  EditCropFieldChangedEvent({this.crop});
}

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
