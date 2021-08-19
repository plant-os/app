part of 'program_details_bloc.dart';

abstract class ProgramDetailsState {}

class ProgramDetailsStateLoading implements ProgramDetailsState {
  @override
  bool operator ==(dynamic o) => o is ProgramDetailsStateLoading;
}

class ProgramDetailsStateError implements ProgramDetailsState {
  final String error;

  ProgramDetailsStateError(this.error);
}

class ProgramDetailsStateDone implements ProgramDetailsState {
  final Program program;
  final List<Schedule> schedules;

  ProgramDetailsStateDone(this.program, this.schedules);

  @override
  String toString() {
    return "ProgramDetailsStateDone{program: $program, schedules: $schedules}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is ProgramDetailsStateDone && listEquals(o.schedules, schedules);
}
