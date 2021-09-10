part of 'programs_bloc.dart';

class ProgramsState {
  final bool isFetched;
  final bool isLoading;
  final String error;
  final List<Program> programs;

  ProgramsState({
    required this.isFetched,
    required this.isLoading,
    required this.error,
    required this.programs,
  });

  factory ProgramsState.initial() {
    return ProgramsState(
      isFetched: false,
      isLoading: true,
      error: '',
      programs: [],
    );
  }

  ProgramsState update({
    bool? isFetched,
    bool? isLoading,
    String? error,
    List<Program>? programs,
  }) {
    return ProgramsState(
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      programs: programs ?? this.programs,
    );
  }

  @override
  String toString() =>
      "ProgramsState{isFetched: $isFetched, isLoading: $isLoading, error: $error, programs: $programs}";

  @override
  bool operator ==(dynamic o) =>
      o is ProgramsState &&
      o.isFetched == isFetched &&
      o.isLoading == isLoading &&
      o.error == error &&
      listEquals(o.programs, programs);

  @override
  int get hashCode =>
      hashValues(isFetched, isLoading, error, hashList(programs));
}
