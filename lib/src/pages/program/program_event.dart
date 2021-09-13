part of 'program_bloc.dart';

abstract class ProgramEvent {}

class ProgramLoadEvent extends ProgramEvent {}

// SchedulesLoaded is triggered whenever the schedules change.
class ProgramSchedulesLoadedEvent extends ProgramEvent {
  final List<Schedule> schedules;

  ProgramSchedulesLoadedEvent(this.schedules);
}

class ProgramDeleteScheduleEvent extends ProgramEvent {
  final String scheduleId;

  ProgramDeleteScheduleEvent(this.scheduleId);
}
