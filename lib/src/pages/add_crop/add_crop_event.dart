part of 'add_crop_bloc.dart';

abstract class AddCropEvent {}

class CropFieldChangedEvent extends AddCropEvent {
  final Crop crop;
  CropFieldChangedEvent({this.crop});
}

class ClickSubmitAddCropEvent extends AddCropEvent {}
