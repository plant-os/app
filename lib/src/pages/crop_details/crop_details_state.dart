part of 'crop_details_bloc.dart';

class CropDetailsState {}

class ActionsLoading implements CropDetailsState {}

class CropDetailsStateError implements CropDetailsState {
  final String error;
  CropDetailsStateError(this.error);
}

class CropDetailsStateDone implements CropDetailsState {
  final List<ActionRepeat> actionRepeats;
  CropDetailsStateDone(this.actionRepeats);
}
