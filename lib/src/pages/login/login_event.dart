part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginTextFieldChangedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginTextFieldChangedEvent({
    @required this.email,
    @required this.password
  });
}

class LoginPressedEvent extends LoginEvent {}