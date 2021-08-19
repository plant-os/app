part of 'edit_task_bloc.dart';

class EditTaskState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isFetched;
  final Task? initial;
  final String error;

  EditTaskState(
      {required this.isValid,
      required this.isLoading,
      required this.isSuccess,
      required this.isFetched,
      required this.initial,
      required this.error});

  factory EditTaskState.initial({bool? isValid, Task? initial}) {
    return EditTaskState(
        isValid: isValid ?? false,
        isLoading: false,
        isSuccess: false,
        isFetched: false,
        initial: initial,
        error: '');
  }

  EditTaskState update(
      {bool? isValid,
      bool? isLoading,
      bool? isSuccess,
      bool? isFetched,
      Task? initial,
      String? error}) {
    return EditTaskState(
        isValid: isValid ?? this.isValid,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFetched: isFetched ?? this.isFetched,
        initial: initial ?? this.initial,
        error: error ?? this.error);
  }

  @override
  String toString() {
    return "EditTaskState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, isFetched: $isFetched, initial: $initial, error: $error}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic o) =>
      o is EditTaskState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.isFetched == isFetched &&
      o.initial == initial &&
      o.error == error;
}
