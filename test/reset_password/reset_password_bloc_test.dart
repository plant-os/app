import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/pages/reset_password/reset_password_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group(
    "resetPasswordBloc",
    () {
      test("Enables the reset password button if the email is valid", () {
        MockAuthService authService = MockAuthService();
        ResetPasswordBloc resetPasswordBloc = ResetPasswordBloc(authService);
        resetPasswordBloc
            .add(ResetPasswordTextFieldChangedEvent(email: "aaa@bbb.com"));
        expectLater(
          resetPasswordBloc,
          emitsInOrder([
            ResetPasswordState(
                error: "", isLoading: false, isSuccess: false, isValid: false),
            ResetPasswordState(
                error: "", isLoading: false, isSuccess: false, isValid: true),
          ]),
        );
      });

      test(
          "Does not enable the reset password button if the email is not valid",
          () {
        MockAuthService authService = MockAuthService();
        ResetPasswordBloc resetPasswordBloc = ResetPasswordBloc(authService);
        resetPasswordBloc
            .add(ResetPasswordTextFieldChangedEvent(email: "scdsfsdfvsd.com"));
        expectLater(
          resetPasswordBloc,
          emitsInOrder([
            ResetPasswordState(
                error: "", isLoading: false, isSuccess: false, isValid: false),
          ]),
        );
      });

      test(
          "Once login button is clicked will validate the fields and sets the loading",
          () {
        MockAuthService authService = MockAuthService();
        ResetPasswordBloc resetPasswordBloc = ResetPasswordBloc(authService);
        resetPasswordBloc
            .add(ResetPasswordTextFieldChangedEvent(email: "aaa@bbb.com"));
        resetPasswordBloc.add(ResetPasswordPressedEvent());
        expectLater(
          resetPasswordBloc,
          emitsInOrder([
            ResetPasswordState(
                error: "", isLoading: false, isSuccess: false, isValid: false),
            ResetPasswordState(
                error: "", isLoading: false, isSuccess: false, isValid: true),
            ResetPasswordState(
                error: "", isLoading: true, isSuccess: false, isValid: true),
            ResetPasswordState(
                error: "", isLoading: false, isSuccess: true, isValid: true),
          ]),
        );
      });
    },
  );
}
