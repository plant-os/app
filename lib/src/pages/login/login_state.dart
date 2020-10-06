part of 'login_bloc.dart';

class LoginState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final String email;
  final String password;

  LoginState({
    @required this.isValid,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.error,
    @required this.email,
    @required this.password,
  });

  factory LoginState.initial({String email, String password, bool isValid}) {
    return LoginState(
        isValid: isValid ?? false,
        isLoading: false,
        isSuccess: false,
        error: '',
        email: email ?? '',
        password: password ?? '');
  }

  LoginState update(
      {bool isValid,
      bool isLoading,
      bool isSuccess,
      String error,
      String email,
      String password}) {
    return LoginState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return "LoginState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error}, email: $email, password: $password";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic other) {
    return other.isValid == isValid &&
        other.isSuccess == isSuccess &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.email == email &&
        other.password == password;
  }
}
