part of 'program_bloc.dart';

class ProgramState {
  final bool isFetched;
  final bool isLoading;
  final String error;
  final Program program;
  final List<Schedule> schedules;

  ProgramState({
    required this.isFetched,
    required this.isLoading,
    required this.error,
    required this.program,
    required this.schedules,
  });

  factory ProgramState.initial({
    required Program program,
  }) {
    return ProgramState(
      isFetched: false,
      isLoading: true,
      error: '',
      program: program,
      schedules: [],
    );
  }

  ProgramState update({
    bool? isFetched,
    bool? isLoading,
    String? error,
    Program? program,
    List<Schedule>? schedules,
  }) {
    return ProgramState(
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      program: program ?? this.program,
      schedules: schedules ?? this.schedules,
    );
  }

  @override
  String toString() =>
      "ProgramState{isFetched: $isFetched, isLoading: $isLoading, error: $error, program: $program, schedules: $schedules}";

  @override
  bool operator ==(dynamic o) =>
      o is ProgramState &&
      o.isFetched == isFetched &&
      o.isLoading == isLoading &&
      o.error == error &&
      o.program == program &&
      listEquals(o.schedules, schedules);

  @override
  int get hashCode =>
      hashValues(isFetched, isLoading, error, program, hashList(schedules));
}
