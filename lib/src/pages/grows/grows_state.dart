part of 'grows_bloc.dart';

class GrowsState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;

  GrowsState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.error,
  });

  factory GrowsState.initial({
    bool? isValid,
  }) {
    return GrowsState(
      isValid: isValid ?? false,
      isLoading: false,
      isSuccess: false,
      error: '',
    );
  }

  GrowsState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return GrowsState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      "GrowsState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error}";

  @override
  bool operator ==(dynamic o) =>
      o is GrowsState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error;

  @override
  int get hashCode => hashValues(isValid, isSuccess, isLoading, error);
}
