part of 'edit_schedule_bloc.dart';

abstract class EditScheduleEvent {}

class EditScheduleFieldChangedEvent extends EditScheduleEvent {
  final Schedule schedule;
  EditScheduleFieldChangedEvent({this.schedule});
}

class ClickSubmitEditScheduleEvent extends EditScheduleEvent {}
