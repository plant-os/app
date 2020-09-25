import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/pages/login/login_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group("loginBloc", () {
    test("Enables the login button if the username and password are correct",
        () {
      MockAuthService authService = MockAuthService();
      // when(authService).thenAnswer((_) => Future.value(true));
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
  });
}
