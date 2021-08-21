part of 'task_bloc.dart';

class TaskState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isFetched;
  final String error;
  final Task? initial;

  TaskState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.isFetched,
    required this.error,
    required this.initial,
  });

  factory TaskState.initial({
    Task? initial,
  }) {
    return TaskState(
      isValid: true,
      isLoading: false,
      isSuccess: false,
      isFetched: false,
      error: '',
      initial: initial,
    );
  }

  TaskState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isFetched,
    String? error,
    Task? initial,
  }) {
    return TaskState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFetched: isFetched ?? this.isFetched,
      error: error ?? this.error,
      initial: initial ?? this.initial,
    );
  }

  @override
  String toString() =>
      "TaskState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, isFetched: $isFetched, error: $error, initial: $initial}";

  @override
  bool operator ==(dynamic o) =>
      o is TaskState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.isFetched == isFetched &&
      o.error == error &&
      o.initial == initial;

  @override
  int get hashCode =>
      hashValues(isValid, isSuccess, isLoading, isFetched, error, initial);
}
