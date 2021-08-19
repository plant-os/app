part of 'programs_bloc.dart';

abstract class ProgramsEvent {}

class ProgramsInitialFetchEvent extends ProgramsEvent {}

class ProgramsLoaded extends ProgramsEvent {
  final List<Program> programs;

  ProgramsLoaded(this.programs);
}

class ProgramsDeleteEvent extends ProgramsEvent {
  final String programId;

  ProgramsDeleteEvent(this.programId);
}
