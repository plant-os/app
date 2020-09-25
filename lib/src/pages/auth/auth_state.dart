part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthUninitializedState extends AuthState {}

class AuthAuthenticatedState extends AuthState {}

class AuthUnauthenticatedState extends AuthState {}