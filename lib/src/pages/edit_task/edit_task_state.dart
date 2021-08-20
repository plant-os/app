part of 'edit_task_bloc.dart';

class EditTaskState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isFetched;
  final String error;
  final Task? initial;

  EditTaskState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.isFetched,
    required this.error,
    required this.initial,
  });

  factory EditTaskState.initial({
    Task? initial,
  }) {
    return EditTaskState(
      isValid: true,
      isLoading: false,
      isSuccess: false,
      isFetched: false,
      error: '',
      initial: initial,
    );
  }

  EditTaskState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isFetched,
    String? error,
    Task? initial,
  }) {
    return EditTaskState(
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
      "EditTaskState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, isFetched: $isFetched, error: $error, initial: $initial}";

  @override
  bool operator ==(dynamic o) =>
      o is EditTaskState &&
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
