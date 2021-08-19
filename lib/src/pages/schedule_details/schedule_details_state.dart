part of 'schedule_details_bloc.dart';

class ScheduleDetailsState {
  final bool isValid;
  final bool isLoading;

  // True if the schedule has been updated successfully. This triggers the dialog to close.
  final bool isSuccess;
  final String error;
  final bool isFetched;
  final Schedule? initial;
  final List<Task> tasks;

  ScheduleDetailsState(
      {required this.isValid,
      required this.isLoading,
      required this.isSuccess,
      required this.error,
      required this.isFetched,
      required this.initial,
      required this.tasks});

  factory ScheduleDetailsState.initial({bool? isValid, Schedule? initial}) {
    return ScheduleDetailsState(
        isValid: isValid ?? false,
        isLoading: false,
        isSuccess: false,
        error: '',
        isFetched: false,
        initial: initial,
        tasks: []);
  }

  ScheduleDetailsState update(
      {bool? isValid,
      bool? isLoading,
      bool? isSuccess,
      String? error,
      bool? isFetched,
      Schedule? initial,
      List<Task>? tasks}) {
    return ScheduleDetailsState(
        isValid: isValid ?? this.isValid,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        error: error ?? this.error,
        isFetched: isFetched ?? this.isFetched,
        initial: initial ?? this.initial,
        tasks: tasks ?? this.tasks);
  }

  @override
  String toString() {
    return "ScheduleDetailsState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, isFetched: $isFetched, initial: $initial, tasks: $tasks}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic o) =>
      o is ScheduleDetailsState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.isLoading == isLoading &&
      o.error == error &&
      o.isFetched == isFetched &&
      o.initial == initial &&
      listEquals(o.tasks, tasks);
}
