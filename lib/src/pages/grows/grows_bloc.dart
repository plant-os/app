import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'grows_event.dart';
part 'grows_state.dart';

class GrowsBloc extends Bloc<GrowsEvent, GrowsState> {
  AuthService authService = AuthService();
  UserService userService = UserService();

  GrowsBloc() : super(GrowsState.initial());

  void dispose() {}

  @override
  Stream<GrowsState> mapEventToState(GrowsEvent event) async* {
    if (event is GrowsInitialFetchEvent) {
      yield* _mapGrowsInitialFetchEventToState();
    } else {
      throw "unhandled event: $event";
    }
  }

  Stream<GrowsState> _mapGrowsInitialFetchEventToState() async* {
    yield state.update(isLoading: true);
    // TODO: Subscribe to grows.
  }
}
