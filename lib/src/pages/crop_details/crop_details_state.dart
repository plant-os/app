part of 'crop_details_bloc.dart';

class CropDetailsState {}

/// LoadingState is used to indicate to the user that the page is loading from
/// the database.
class LoadingState implements CropDetailsState {
  @override
  bool operator ==(dynamic o) => o is LoadingState;
}

/// LoadedState is the state that contains the information that the user
/// intends to see.
class LoadedState implements CropDetailsState {
  final Crop crop;
  final List<ActionRepeat> actionRepeats;

  LoadedState(this.crop, this.actionRepeats);

  @override
  String toString() =>
      "LoadedState{crop: $crop, actionRepeats: $actionRepeats}";

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is LoadedState && o.crop == crop && o.actionRepeats == actionRepeats;
}
