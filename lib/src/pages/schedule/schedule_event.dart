part of 'schedule_bloc.dart';

abstract class ScheduleEvent {}

class ScheduleLoadedEvent extends ScheduleEvent {}

class ScheduleTextFieldChangedEvent extends ScheduleEvent {
  final String name;
  final String startDay;

  ScheduleTextFieldChangedEvent({required this.name, required this.startDay});
}

class SchedulePressedEvent extends ScheduleEvent {}

class ScheduleAddTaskEvent extends ScheduleEvent {
  final Task task;

  ScheduleAddTaskEvent(this.task);
}

class ScheduleEditTaskEvent extends ScheduleEvent {
  final Task task;
  final int index;

  ScheduleEditTaskEvent(this.task, this.index);
}

class ScheduleDeleteTaskEvent extends ScheduleEvent {
  final int index;

  ScheduleDeleteTaskEvent(this.index);
}
