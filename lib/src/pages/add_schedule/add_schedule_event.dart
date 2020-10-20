part of 'add_schedule_bloc.dart';

abstract class AddScheduleEvent {}

class ScheduleFieldChangedEvent extends AddScheduleEvent {
  final Schedule schedule;
  ScheduleFieldChangedEvent({this.schedule});
}

class ClickSubmitAddScheduleEvent extends AddScheduleEvent {}
