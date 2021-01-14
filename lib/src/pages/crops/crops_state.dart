part of 'crops_bloc.dart';

class CropStateLoading implements CropsState {
  @override
  bool operator ==(dynamic o) => o is CropStateLoading;
}

class CropsStateError implements CropsState {
  final String error;
  CropsStateError(this.error);
}

class CropsStateDone implements CropsState {
  final List<Crop> ongoingCrops;
  final List<Crop> pastCrops;
  final UserModel currentUser;
  CropsStateDone(this.ongoingCrops, this.pastCrops, this.currentUser);

  @override
  String toString() {
    return "CropsState{ongoingCrops: $ongoingCrops, pastCrops: $pastCrops, user: $currentUser}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is CropsStateDone &&
      o.ongoingCrops == ongoingCrops &&
      o.pastCrops == pastCrops &&
      o.currentUser == currentUser;
}

class CropsState {}
