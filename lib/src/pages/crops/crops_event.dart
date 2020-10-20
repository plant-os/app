part of 'crops_bloc.dart';

abstract class CropsEvent {}

class ClickAddCrop extends CropsEvent {}

class ClickUpdateCrop extends CropsEvent {
  final Crop crop;
  ClickUpdateCrop(this.crop);
}

class ClickDeleteCrop extends CropsEvent {
  final Crop crop;
  ClickDeleteCrop(this.crop);
}

class CropsLoaded extends CropsEvent {
  final UserModel currentUser;
  final List<Crop> crops;
  CropsLoaded(this.crops, this.currentUser);
}

class ClickOnCrop extends CropsEvent {
  final Crop crop;
  ClickOnCrop(this.crop);
}
