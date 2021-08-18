part of 'program_details_bloc.dart';

class ProgramDetailsState {}

class ProgramDetailsStateLoading implements ProgramDetailsState {
  @override
  bool operator ==(dynamic o) => o is ProgramDetailsStateLoading;
}

class ProgramDetailsStateError implements ProgramDetailsState {
  final String error;
  ProgramDetailsStateError(this.error);
}

class ProgramDetailsStateDone implements ProgramDetailsState {
  final List<Program> programs;
  ProgramDetailsStateDone(this.programs);

  @override
  String toString() {
    return "ProgramDetailsState{programs: $programs}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is ProgramDetailsStateDone && listEquals(o.programs, programs);
}
