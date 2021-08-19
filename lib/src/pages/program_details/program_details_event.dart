part of 'program_details_bloc.dart';

abstract class ProgramDetailsEvent {}

class LoadProgramDetailsEvent extends ProgramDetailsEvent {}

class SchedulesLoaded extends ProgramDetailsEvent {
  final List<Schedule> schedules;

  SchedulesLoaded(this.schedules);
}

class NewScheduleEvent extends ProgramDetailsEvent {}

class DeleteScheduleEvent extends ProgramDetailsEvent {
  final String id;

  DeleteScheduleEvent(this.id);
}

class EditScheduleEvent extends ProgramDetailsEvent {
  final String id;

  EditScheduleEvent(this.id);
}
