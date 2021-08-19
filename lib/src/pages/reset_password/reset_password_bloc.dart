import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:plantos/src/services/auth_service.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  AuthService _authService = AuthService();
  String email = "";

  ResetPasswordBloc() : super(ResetPasswordState.initial());

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if (event is ResetPasswordTextFieldChangedEvent)
      yield* _mapTextFieldChangedToState(event);
    else if (event is ResetPasswordPressedEvent)
      yield* _mapResetPasswordPressedToState();
  }

  Stream<ResetPasswordState> _mapTextFieldChangedToState(
      ResetPasswordTextFieldChangedEvent event) async* {
    email = event.email;
    yield state.update(isValid: EmailValidator.validate(email));
  }

  Stream<ResetPasswordState> _mapResetPasswordPressedToState() async* {
    yield state.update(isLoading: true);
    try {
      await _authService.resetPassword(email);
      yield state.update(isLoading: false, isSuccess: true);
    } on FirebaseAuthException catch (e) {
      print(e);
      yield state.update(isLoading: false, error: e.message);
    } finally {
      yield ResetPasswordState.initial(isValid: EmailValidator.validate(email));
    }
  }
}
