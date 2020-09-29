part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent {}

class ResetPasswordTextFieldChangedEvent extends ResetPasswordEvent {
  final String email;

  ResetPasswordTextFieldChangedEvent({@required this.email});
}

class ResetPasswordPressedEvent extends ResetPasswordEvent {}