part of 'crops_bloc.dart';

class CropStateLoading implements CropsState {
  @override
  bool operator ==(dynamic other) {
    if (!(other is CropStateLoading)) {
      return false;
    }
    return other is CropStateLoading;
  }
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
  bool operator ==(dynamic other) {
    if (!(other is CropsStateDone)) {
      return false;
    }

    return other.ongoingCrops == ongoingCrops &&
        other.pastCrops == pastCrops &&
        other.currentUser == currentUser;
  }
}

class CropsState {}
