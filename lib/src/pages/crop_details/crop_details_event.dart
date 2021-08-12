part of 'crop_details_bloc.dart';

abstract class CropDetailsEvent {}

/// CropSnapshotEvent is an event that is fired when the crop changes on the
/// database.
class CropSnapshotEvent extends CropDetailsEvent {
  final Crop crop;
  CropSnapshotEvent(this.crop);
  @override
  String toString() => "CropSnapshotEvent{crop: $crop}";
}

/// SkipsSnapshotEvent is an event that is fired when the list of skips for the
/// current crop changes on the database.
class SkipsSnapshotEvent extends CropDetailsEvent {
  final List<ActionRepeat> skips;
  SkipsSnapshotEvent(this.skips);
  @override
  String toString() => "SkipsSnapshotEvent{skips: $skips}";
}

class ClickChangeActionStatusEvent extends CropDetailsEvent {
  final ActionRepeat action;
  ClickChangeActionStatusEvent({required this.action});
  @override
  String toString() => "ClickChangeActionStatusEvent{action: $action}";
}
