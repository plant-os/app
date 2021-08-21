part of 'program_bloc.dart';

abstract class ProgramState {}

class ProgramStateLoading implements ProgramState {
  @override
  bool operator ==(dynamic o) => o is ProgramStateLoading;
}

class ProgramStateError implements ProgramState {
  final String error;

  ProgramStateError(this.error);
}

class ProgramStateDone implements ProgramState {
  final Program program;
  final List<Schedule> schedules;

  ProgramStateDone(this.program, this.schedules);

  @override
  String toString() {
    return "ProgramStateDone{program: $program, schedules: $schedules}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is ProgramStateDone && listEquals(o.schedules, schedules);
}
