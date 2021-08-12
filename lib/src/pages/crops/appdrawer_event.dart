part of 'appdrawer_bloc.dart';

abstract class AppDrawerEvent {}

class ClickLogout extends AppDrawerEvent {}

class UserLoaded extends AppDrawerEvent {
  final UserModel user;

  UserLoaded(this.user);
}
