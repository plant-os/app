part of 'add_schedule_bloc.dart';

class AddScheduleState {
  final Schedule? schedule;
  final String error;
  final bool isSuccess;
  final bool isValid;
  final bool isLoading;
  AddScheduleState(
      {@required this.schedule,
      @required required this.error,
      @required required this.isSuccess,
      @required required this.isLoading,
      @required required this.isValid});

  factory AddScheduleState.initial(
      {Schedule? schedule,
      String? error,
      bool? isSucess,
      bool? isValid,
      bool? isLoading}) {
    return AddScheduleState(
        schedule: schedule ?? null,
        error: error ?? "",
        isSuccess: isSucess ?? false,
        isLoading: isLoading ?? false,
        isValid: isValid ?? false);
  }

  AddScheduleState update(
      {bool? isValid,
      bool? isLoading,
      bool? isSuccess,
      String? error,
      Schedule? schedule}) {
    return AddScheduleState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  String toString() {
    return "AddScheduleState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, schedule: $schedule}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic o) =>
      o is AddScheduleState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error &&
      o.schedule == schedule;
}
