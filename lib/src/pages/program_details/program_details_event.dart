part of 'program_details_bloc.dart';

abstract class ProgramDetailsEvent {}

class ProgramDetailsLoadEvent extends ProgramDetailsEvent {}

// SchedulesLoaded is triggered whenever the schedules change.
class ProgramDetailsSchedulesLoadedEvent extends ProgramDetailsEvent {
  final List<Schedule> schedules;

  ProgramDetailsSchedulesLoadedEvent(this.schedules);
}

class ProgramDetailsDeleteScheduleEvent extends ProgramDetailsEvent {
  final String scheduleId;

  ProgramDetailsDeleteScheduleEvent(this.scheduleId);
}
