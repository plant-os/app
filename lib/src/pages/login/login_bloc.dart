import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:plantos/src/services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthService authService = AuthService();

  String email = "";
  String password = "";

  LoginBloc() : super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginTextFieldChangedEvent) {
      yield* _mapTextFieldChangedToState(event);
    } else if (event is LoginPressedEvent) {
      yield* _mapLoginPressedToState();
    }
  }

  Stream<LoginState> _mapTextFieldChangedToState(
      LoginTextFieldChangedEvent event) async* {
    yield state.update(
        isValid: _isFormValidated(event.email, event.password),
        email: event.email,
        password: event.password);
  }

  bool _isFormValidated(email, password) {
    return EmailValidator.validate(email) && password.isNotEmpty;
  }

  Stream<LoginState> _mapLoginPressedToState() async* {
    yield state.update(isLoading: true);
    try {
      await authService.login(email, password);
      yield state.update(isLoading: false, isSuccess: true);
    } on FirebaseAuthException catch (e) {
      print(e);
      yield state.update(isLoading: false, error: e.message);
      yield LoginState.initial(isValid: _isFormValidated(email, password));
    }
  }
}
