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
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "",
              password: ""),
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              email: "aaa@bbb.com",
              password: "test1234"),
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
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "",
              password: ""),
        ]),
      );
    });

    test("Does not enable the login button if the email empty", () {
      MockAuthService authService = MockAuthService();
      LoginBloc loginBloc = LoginBloc(authService);
      loginBloc
          .add(LoginTextFieldChangedEvent(email: "", password: "test1234"));
      expectLater(
        loginBloc,
        emitsInOrder([
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "",
              password: ""),
        ]),
      );
    });

    test("Does not enable the login button if the password is empty", () {
      MockAuthService authService = MockAuthService();
      LoginBloc loginBloc = LoginBloc(authService);
      loginBloc.add(
          LoginTextFieldChangedEvent(email: "aaafgfhkg.com", password: ""));
      expectLater(
        loginBloc,
        emitsInOrder([
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "",
              password: ""),
        ]),
      );
    });

    test(
        "Enables the login button after correcting the password which was empty",
        () {
      MockAuthService authService = MockAuthService();
      LoginBloc loginBloc = LoginBloc(authService);
      loginBloc.add(
          LoginTextFieldChangedEvent(email: "dadas@sfds.com", password: ""));
      loginBloc.add(LoginTextFieldChangedEvent(
          email: "dadas@sfds.com", password: "dssadsa"));
      expectLater(
        loginBloc,
        emitsInOrder([
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "",
              password: ""),
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "dadas@sfds.com",
              password: ""),
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              email: "dadas@sfds.com",
              password: "dssadsa"),
        ]),
      );
    });

    test(
        "Enables the login button after correcting the email which was not valid",
        () {
      MockAuthService authService = MockAuthService();
      LoginBloc loginBloc = LoginBloc(authService);
      loginBloc.add(
          LoginTextFieldChangedEvent(email: "aaafgfhkg.com", password: ""));
      loginBloc.add(
          LoginTextFieldChangedEvent(email: "aaa@bbb.com", password: "dsdsds"));
      expectLater(
        loginBloc,
        emitsInOrder([
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "",
              password: ""),
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "aaafgfhkg.com",
              password: ""),
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              email: "aaa@bbb.com",
              password: "dsdsds"),
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
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              email: "",
              password: ""),
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              email: "aaa@bbb.com",
              password: "test1234"),
          LoginState(
              error: "",
              isLoading: true,
              isSuccess: false,
              isValid: true,
              email: "aaa@bbb.com",
              password: "test1234"),
          LoginState(
              error: "",
              isLoading: false,
              isSuccess: true,
              isValid: true,
              email: "aaa@bbb.com",
              password: "test1234"),
        ]),
      );
    });
  });
}
