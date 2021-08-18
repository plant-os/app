part of 'programs_bloc.dart';

abstract class ProgramsEvent {}

class ProgramsInitialFetchEvent extends ProgramsEvent {}

class ProgramsLoaded extends ProgramsEvent {
  final List<Program> programs;

  ProgramsLoaded(this.programs);
}

class DeleteProgramEvent extends ProgramsEvent {
  final String programId;

  DeleteProgramEvent(this.programId);
}

class EditProgramEvent extends ProgramsEvent {
  final String programId;

  EditProgramEvent(this.programId);
}

class NewProgramEvent extends ProgramsEvent {}
