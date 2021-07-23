part of 'edit_schedule_bloc.dart';

abstract class EditScheduleEvent {}

class EditScheduleFieldChangedEvent extends EditScheduleEvent {
  final Schedule schedule;
  EditScheduleFieldChangedEvent({required this.schedule});
}

class EditTimeEvent extends EditScheduleEvent {
  final TimeOfDay time;
  EditTimeEvent(this.time);
}

class SetActionEvent extends EditScheduleEvent {
  final bool isFertigation;
  SetActionEvent(this.isFertigation);
}

class ToggleRepeatEvent extends EditScheduleEvent {
  final String day;
  ToggleRepeatEvent(this.day);
}

class ClickSubmitEditScheduleEvent extends EditScheduleEvent {}
