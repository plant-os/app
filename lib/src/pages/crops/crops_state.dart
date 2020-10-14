part of 'crops_bloc.dart';

class CropStateLoading implements CropsState {}

class CropsStateError implements CropsState {
  final String error;
  CropsStateError(this.error);
}

class CropsStateDone implements CropsState {
  final List<Crop> ongoingCrops;
  final List<Crop> pastCrops;
  final UserModel currentUser;
  CropsStateDone(this.ongoingCrops, this.pastCrops, this.currentUser);
}

// class AddCropsState implements CropsState {}

class CropDetailsState implements CropsState {}

class CropsState {}
