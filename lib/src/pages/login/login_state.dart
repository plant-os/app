part of 'login_bloc.dart';

class LoginState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final String email;
  final String password;

  LoginState({
    @required required this.isValid,
    @required required this.isLoading,
    @required required this.isSuccess,
    @required required this.error,
    @required required this.email,
    @required required this.password,
  });

  factory LoginState.initial({String? email, String? password, bool? isValid}) {
    return LoginState(
        isValid: isValid ?? false,
        isLoading: false,
        isSuccess: false,
        error: '',
        email: email ?? '',
        password: password ?? '');
  }

  LoginState update(
      {bool? isValid,
      bool? isLoading,
      bool? isSuccess,
      String? error,
      String? email,
      String? password}) {
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
  bool operator ==(dynamic o) =>
      o is LoginState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error &&
      o.email == email &&
      o.password == password;
}
