part of 'crop_details_bloc.dart';

abstract class CropDetailsEvent {}

class ClickChangeActionStatusEvent extends CropDetailsEvent {
  final ActionRepeat action;
  ClickChangeActionStatusEvent({this.action});
}

class ActionsLoaded extends CropDetailsEvent {
  final List<ActionRepeat> actionRepeats;
  ActionsLoaded(this.actionRepeats);
}

class SetCropEvent extends CropDetailsEvent {
  final Crop crop;

  SetCropEvent(this.crop);
}
