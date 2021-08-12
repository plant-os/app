part of 'appdrawer_bloc.dart';

class LoadingAppDrawerState implements AppDrawerState {}

class DefaultAppDrawerState implements AppDrawerState {
  final UserModel user;

  DefaultAppDrawerState(this.user);
}

class AppDrawerState {}
