part of 'edit_task_bloc.dart';

abstract class EditTaskEvent {}

// Notifies the bloc that the page has been loaded and triggers a reset of the text fields.
class EditTaskLoadedEvent extends EditTaskEvent {}

class EditTaskTextFieldChangedEvent extends EditTaskEvent {
  final String hours;
  final String minutes;
  final String ec;
  final String duration;

  EditTaskTextFieldChangedEvent(
      {required this.hours,
      required this.minutes,
      required this.ec,
      required this.duration});
}

class EditTaskPressedEvent extends EditTaskEvent {}

class EditTaskActionChangedEvent extends EditTaskEvent {
  final String action;

  EditTaskActionChangedEvent(this.action);
}
