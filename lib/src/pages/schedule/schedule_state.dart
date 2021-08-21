part of 'schedule_bloc.dart';

class ScheduleState {
  final bool isValid;
  final bool isLoading;

  // True if the schedule has been updated successfully. This triggers the dialog to close.
  final bool isSuccess;
  final String error;
  final bool isFetched;
  final Schedule? initial;
  final List<Task> tasks;

  ScheduleState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.error,
    required this.isFetched,
    required this.initial,
    required this.tasks,
  });

  factory ScheduleState.initial({
    bool? isValid,
    Schedule? initial,
  }) {
    return ScheduleState(
      isValid: isValid ?? false,
      isLoading: false,
      isSuccess: false,
      error: '',
      isFetched: false,
      initial: initial,
      tasks: [],
    );
  }

  ScheduleState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool? isFetched,
    Schedule? initial,
    List<Task>? tasks,
  }) {
    return ScheduleState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      isFetched: isFetched ?? this.isFetched,
      initial: initial ?? this.initial,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  String toString() =>
      "ScheduleState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, isFetched: $isFetched, initial: $initial, tasks: $tasks}";

  @override
  bool operator ==(dynamic o) =>
      o is ScheduleState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error &&
      o.isFetched == isFetched &&
      o.initial == initial &&
      listEquals(o.tasks, tasks);

  @override
  int get hashCode => hashValues(isValid, isSuccess, isLoading, error,
      isFetched, initial, hashList(tasks));
}
