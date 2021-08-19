part of 'schedule_details_bloc.dart';

class ScheduleDetailsState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final List<Task> tasks;

  ScheduleDetailsState(
      {required this.isValid,
      required this.isLoading,
      required this.isSuccess,
      required this.error,
      required this.tasks});

  factory ScheduleDetailsState.initial({bool? isValid}) {
    return ScheduleDetailsState(
        isValid: isValid ?? false,
        isLoading: false,
        isSuccess: false,
        error: '',
        tasks: []);
  }

  ScheduleDetailsState update(
      {bool? isValid,
      bool? isLoading,
      bool? isSuccess,
      String? error,
      List<Task>? tasks}) {
    return ScheduleDetailsState(
        isValid: isValid ?? this.isValid,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        error: error ?? this.error,
        tasks: tasks ?? this.tasks);
  }

  @override
  String toString() {
    return "ScheduleDetailsState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, tasks: $tasks}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic o) =>
      o is ScheduleDetailsState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error &&
      listEquals(o.tasks, tasks);
}
