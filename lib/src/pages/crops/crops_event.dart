part of 'crops_bloc.dart';

abstract class CropsEvent {}

class LoadOngoingCrops extends CropsEvent {}

class LoadPastCrops extends CropsEvent {}

class AddCrop extends CropsEvent {}

class UpdateCrop extends CropsEvent {}

class DeleteCrop extends CropsEvent {}

class OngoingCropsUpdated extends CropsEvent {
  final List<Crop> crops;

  OngoingCropsUpdated(this.crops);
}

class PastCropsUpdated extends CropsEvent {}
