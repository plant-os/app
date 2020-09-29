import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/pages/login/login_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group("loginBloc", () {
    test("Enables the login button if the email and password are correct", () {
      MockAuthService authService = MockAuthService();
      LoginBloc loginBloc = LoginBloc(authService);
      loginBloc.add(LoginTextFieldChangedEvent(
          email: "aaa@bbb.com", password: "test1234"));
      expectLater(
        loginBloc,
        emitsInOrder([
          LoginState(
              error: "", isLoading: false, isSuccess: false, isValid: false),
          LoginState(
              error: "", isLoading: false, isSuccess: false, isValid: true),
        ]),
      );
    });

    test("Does not enable the login button if the email is not a valid email",
        () {
      MockAuthService authService = MockAuthService();
      LoginBloc loginBloc = LoginBloc(authService);
      loginBloc.add(LoginTextFieldChangedEvent(
          email: "aaafgfhkg.com", password: "test1234"));
      expectLater(
        loginBloc,
        emitsInOrder([
          LoginState(
              error: "", isLoading: false, isSuccess: false, isValid: false),
        ]),
      );
    });
    test(
        "Once login button is clicked will validate the fields and sets the loading",
        () {
      MockAuthService authService = MockAuthService();
      LoginBloc loginBloc = LoginBloc(authService);
      loginBloc.add(LoginTextFieldChangedEvent(
          email: "aaa@bbb.com", password: "test1234"));
      loginBloc.add(LoginPressedEvent());
      expectLater(
        loginBloc,
        emitsInOrder([
          LoginState(
              error: "", isLoading: false, isSuccess: false, isValid: false),
          LoginState(
              error: "", isLoading: false, isSuccess: false, isValid: true),
          LoginState(
              error: "", isLoading: true, isSuccess: false, isValid: true),
          LoginState(
              error: "", isLoading: false, isSuccess: true, isValid: true),
        ]),
      );
    });
  });
}
