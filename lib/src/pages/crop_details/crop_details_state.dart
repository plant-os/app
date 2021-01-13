part of 'crop_details_bloc.dart';

class CropDetailsState {}

class ActionsLoading implements CropDetailsState {
  @override
  bool operator ==(dynamic other) {
    if (!(other is ActionsLoading)) {
      return false;
    }
    return other is ActionsLoading;
  }
}

class CropDetailsStateError implements CropDetailsState {
  final String error;
  CropDetailsStateError(this.error);
}

class CropDetailsStateDone implements CropDetailsState {
  final List<ActionRepeat> actionRepeats;
  final Crop crop;

  CropDetailsStateDone(this.actionRepeats, this.crop);

  @override
  String toString() {
    return "CropDetailsState{actionRepeats: $actionRepeats}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic other) {
    if (!(other is CropDetailsStateDone)) {
      return false;
    }

    return other.actionRepeats == actionRepeats && other.crop == crop;
  }
}
