part of 'programs_bloc.dart';

class ProgramsState {}

class ProgramsStateLoading implements ProgramsState {
  @override
  bool operator ==(dynamic o) => o is ProgramsStateLoading;
}

class ProgramsStateError implements ProgramsState {
  final String error;
  ProgramsStateError(this.error);
}

class ProgramsStateDone implements ProgramsState {
  final List<Program> programs;
  ProgramsStateDone(this.programs);

  @override
  String toString() {
    return "ProgramsState{programs: $programs}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is ProgramsStateDone && listEquals(o.programs, programs);
}
