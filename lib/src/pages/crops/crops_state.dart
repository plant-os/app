part of 'crops_bloc.dart';

class CropsState {
  final bool isValid;
  // final bool isLoading;
  // final bool isSuccess;
  // final String error;

  CropsState({
    @required this.isValid,
  });
  // @required this.isLoading,
  // @required this.isSuccess,
  // @required this.error});

  factory CropsState.initial({bool isValid}) {
    return CropsState(
      isValid: isValid ?? false,
      // isLoading: false,
      // isSuccess: false,
      // error: ''
    );
  }

  CropsState update(
      {bool isValid, bool isLoading, bool isSuccess, String error}) {
    return CropsState(
      isValid: isValid ?? this.isValid,
      // isLoading: isLoading ?? this.isLoading,
      // isSuccess: isSuccess ?? this.isSuccess,
      // error: error ?? this.error
    );
  }

  @override
  String toString() {
    return "LoginState{isValid: $isValid";
    // isSuccess: $isSuccess, isLoading: $isLoading, error: $error}
    // ";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic other) {
    return other.isValid == isValid;
    // &&
    //     other.isSuccess == isSuccess &&
    //     other.isLoading == isLoading &&
    //     other.error == error;
  }
}
