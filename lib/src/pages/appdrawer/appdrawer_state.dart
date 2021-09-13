part of 'appdrawer_bloc.dart';

class AppDrawerState {
  final bool isLoading;
  final bool isFetched;
  final String error;
  final UserModel? user;

  AppDrawerState({
    required this.isLoading,
    required this.isFetched,
    required this.error,
    required this.user,
  });

  factory AppDrawerState.initial() {
    return AppDrawerState(
      isLoading: false,
      isFetched: false,
      error: '',
      user: null,
    );
  }

  AppDrawerState update({
    bool? isLoading,
    bool? isFetched,
    String? error,
    UserModel? user,
  }) {
    return AppDrawerState(
      isLoading: isLoading ?? this.isLoading,
      isFetched: isFetched ?? this.isFetched,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  String toString() =>
      "AppDrawerState{isLoading: $isLoading, isFetched: $isFetched, error: $error, user: $user}";

  @override
  bool operator ==(dynamic o) =>
      o is AppDrawerState &&
      o.isLoading == isLoading &&
      o.isFetched == isFetched &&
      o.error == error &&
      o.user == user;

  @override
  int get hashCode => hashValues(isLoading, isFetched, error, user);
}
