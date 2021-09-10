part of 'grows_bloc.dart';

class GrowsState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final List<Grow> grows;

  GrowsState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.error,
    required this.grows,
  });

  factory GrowsState.initial({
    bool? isValid,
  }) {
    return GrowsState(
      isValid: isValid ?? false,
      isLoading: false,
      isSuccess: false,
      error: '',
      grows: [],
    );
  }

  GrowsState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<Grow>? grows,
  }) {
    return GrowsState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      grows: grows ?? this.grows,
    );
  }

  @override
  String toString() =>
      "GrowsState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, grows: $grows}";

  @override
  bool operator ==(dynamic o) =>
      o is GrowsState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error &&
      listEquals(o.grows, grows);

  @override
  int get hashCode =>
      hashValues(isValid, isSuccess, isLoading, error, hashList(grows));
}
