part of 'task_bloc.dart';

class TaskState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isFetched;
  final String error;
  final Task? initial;
  final bool showEc;

  TaskState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.isFetched,
    required this.error,
    required this.initial,
    required this.showEc,
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
      showEc: false,
    );
  }

  TaskState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isFetched,
    String? error,
    Task? initial,
    bool? showEc,
  }) {
    return TaskState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFetched: isFetched ?? this.isFetched,
      error: error ?? this.error,
      initial: initial ?? this.initial,
      showEc: showEc ?? this.showEc,
    );
  }

  @override
  String toString() =>
      "TaskState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, isFetched: $isFetched, error: $error, initial: $initial, showEc: $showEc}";

  @override
  bool operator ==(dynamic o) =>
      o is TaskState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.isFetched == isFetched &&
      o.error == error &&
      o.initial == initial &&
      o.showEc == showEc;

  @override
  int get hashCode => hashValues(
      isValid, isSuccess, isLoading, isFetched, error, initial, showEc);
}
