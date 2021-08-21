part of 'appdrawer_bloc.dart';

abstract class AppDrawerEvent {}

class AppDrawerPressLogout extends AppDrawerEvent {}

class AppDrawerUserLoaded extends AppDrawerEvent {
  final UserModel user;

  AppDrawerUserLoaded(this.user);
}
