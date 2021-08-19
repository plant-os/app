part of 'schedule_details_bloc.dart';

abstract class ScheduleDetailsEvent {}

class ScheduleDetailsLoadedEvent extends ScheduleDetailsEvent {}

class ScheduleDetailsTextFieldChangedEvent extends ScheduleDetailsEvent {
  final String name;
  final String startDay;

  ScheduleDetailsTextFieldChangedEvent(
      {required this.name, required this.startDay});
}

class ScheduleDetailsPressedEvent extends ScheduleDetailsEvent {}

class ScheduleDetailsAddTaskEvent extends ScheduleDetailsEvent {
  final Task task;

  ScheduleDetailsAddTaskEvent(this.task);
}

class ScheduleDetailsEditTaskEvent extends ScheduleDetailsEvent {
  final Task task;
  final int index;

  ScheduleDetailsEditTaskEvent(this.task, this.index);
}

class ScheduleDetailsDeleteTaskEvent extends ScheduleDetailsEvent {
  final int index;

  ScheduleDetailsDeleteTaskEvent(this.index);
}
