part of 'program_details_bloc.dart';

abstract class ProgramDetailsEvent {}

class LoadProgramDetailsEvent extends ProgramDetailsEvent {}

class ProgramDetailsLoaded extends ProgramDetailsEvent {
  final List<Program> programs;

  ProgramDetailsLoaded(this.programs);
}

class DeleteScheduleEvent extends ProgramDetailsEvent {
  final String id;

  DeleteScheduleEvent(this.id);
}

class EditScheduleEvent extends ProgramDetailsEvent {
  final String id;

  EditScheduleEvent(this.id);
}
