import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();

  @override
  AuthState get initialState => AuthUninitializedState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStartedEvent)
      yield* _mapStartedToState();
    else if (event is AuthLoggedInEvent)
      yield* _mapLoggedInToState();
    else if (event is AuthLoggedOutEvent) yield* _mapLoggedOutToState();
  }

  Stream<AuthState> _mapStartedToState() async* {
    if (await _authService.isLoggedIn())
      yield AuthAuthenticatedState();
    else
      yield AuthUnauthenticatedState();
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    yield AuthAuthenticatedState();
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield AuthUnauthenticatedState();
    _authService.logout();
  }
}
