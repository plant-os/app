part of 'task_bloc.dart';

abstract class TaskEvent {}

// Notifies the bloc that the page has been loaded and triggers a reset of the text fields.
class TaskLoadedEvent extends TaskEvent {}

class TaskTextFieldChangedEvent extends TaskEvent {
  final String hours;
  final String minutes;
  final String ec;
  final String duration;

  TaskTextFieldChangedEvent(
      {required this.hours,
      required this.minutes,
      required this.ec,
      required this.duration});
}

class TaskPressedEvent extends TaskEvent {}

class TaskActionChangedEvent extends TaskEvent {
  final String action;

  TaskActionChangedEvent(this.action);
}
