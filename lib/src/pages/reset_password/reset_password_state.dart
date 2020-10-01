part of 'reset_password_bloc.dart';

class ResetPasswordState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final String email;

  ResetPasswordState(
      {@required this.isValid,
      @required this.isLoading,
      @required this.isSuccess,
      @required this.email,
      @required this.error});

  factory ResetPasswordState.initial({bool isValid, String email}) {
    return ResetPasswordState(
        isValid: isValid ?? false,
        isLoading: false,
        isSuccess: false,
        error: '',
        email: email ?? '');
  }

  ResetPasswordState update(
      {bool isValid,
      bool isLoading,
      bool isSuccess,
      String error,
      String email}) {
    return ResetPasswordState(
        isValid: isValid ?? this.isValid,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        email: email ?? this.email,
        error: error ?? this.error);
  }

  @override
  String toString() {
    return "ResetPasswordState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error}, email: $email";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic other) {
    return other.isValid == isValid &&
        other.isSuccess == isSuccess &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.email == email;
  }
}
