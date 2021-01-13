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
