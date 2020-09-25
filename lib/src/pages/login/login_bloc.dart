import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:plantos/src/services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthService authService;
  String _email;
  String _password;

  LoginBloc(this.authService);

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginTextFieldChangedEvent)
      yield* _mapTextFieldChangedToState(event);
    else if (event is LoginPressedEvent) yield* _mapLoginPressedToState();
  }

  Stream<LoginState> _mapTextFieldChangedToState(
      LoginTextFieldChangedEvent event) async* {
    _email = event.email;
    _password = event.password;
    yield state.update(isValid: _isFormValidated());
  }

  bool _isFormValidated() {
    return EmailValidator.validate(_email) && _password.isNotEmpty;
  }

  Stream<LoginState> _mapLoginPressedToState() async* {
    yield state.update(isLoading: true);
    try {
      await authService.login(_email, _password);
      yield state.update(isLoading: false, isSuccess: true);
    } catch (e) {
      print(e);
      yield state.update(isLoading: false, error: e.message);
      yield LoginState.initial(isValid: _isFormValidated());
    }
  }
}
