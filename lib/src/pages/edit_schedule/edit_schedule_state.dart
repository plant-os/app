part of 'edit_schedule_bloc.dart';

class EditScheduleState {
  final Schedule schedule;
  final String error;
  final bool isSuccess;
  final bool isValid;
  final bool isLoading;
  EditScheduleState(
      {@required this.schedule,
      @required this.error,
      @required this.isSuccess,
      @required this.isLoading,
      @required this.isValid});

  factory EditScheduleState.initial(
      {Schedule schedule,
      String error,
      bool isSucess,
      bool isValid,
      bool isLoading}) {
    return EditScheduleState(
        schedule: schedule ?? null,
        error: error ?? "",
        isSuccess: isSucess ?? false,
        isLoading: isLoading ?? false,
        isValid: isValid ?? true);
  }

  EditScheduleState update(
      {bool isValid,
      bool isLoading,
      bool isSuccess,
      String error,
      Schedule schedule}) {
    return EditScheduleState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  String toString() {
    return "EditScheduleState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, schedule: $schedule}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic other) {
    return other.isValid == isValid &&
        other.isSuccess == isSuccess &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.schedule == schedule;
  }
}
