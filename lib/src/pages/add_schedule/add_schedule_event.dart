part of 'add_schedule_bloc.dart';

abstract class AddScheduleEvent {}

class ScheduleFieldChangedEvent extends AddScheduleEvent {
  final Schedule schedule;
  ScheduleFieldChangedEvent({this.schedule});
}

class EditTimeEvent extends AddScheduleEvent {
  final TimeOfDay time;
  EditTimeEvent(this.time);
}

class ClickSubmitAddScheduleEvent extends AddScheduleEvent {}
