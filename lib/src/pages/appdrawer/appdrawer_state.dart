part of 'appdrawer_bloc.dart';

class AppDrawerState {
  final bool isLoading;
  final String error;
  final UserModel? user;

  AppDrawerState({
    required this.isLoading,
    required this.error,
    required this.user,
  });

  factory AppDrawerState.initial() {
    return AppDrawerState(
      isLoading: false,
      error: '',
      user: null,
    );
  }

  AppDrawerState update({
    bool? isLoading,
    String? error,
    UserModel? user,
  }) {
    return AppDrawerState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  String toString() =>
      "AppDrawerState{isLoading: $isLoading, error: $error, user: $user}";

  @override
  bool operator ==(dynamic o) =>
      o is AppDrawerState &&
      o.isLoading == isLoading &&
      o.error == error &&
      o.user == user;

  @override
  int get hashCode => hashValues(isLoading, error, user);
}
