part of 'login_bloc.dart';

class LoginState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;

  LoginState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.error,
  });

  factory LoginState.initial({
    bool? isValid,
  }) {
    return LoginState(
      isValid: isValid ?? false,
      isLoading: false,
      isSuccess: false,
      error: '',
    );
  }

  LoginState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return LoginState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      "LoginState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error}";

  @override
  bool operator ==(dynamic o) =>
      o is LoginState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error;

  @override
  int get hashCode => hashValues(isValid, isSuccess, isLoading, error);
}
