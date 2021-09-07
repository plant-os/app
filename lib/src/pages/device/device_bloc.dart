import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'device_state.dart';
part 'device_event.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  DeviceBloc() : super(DeviceState.initial());

  void dispose() {}

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {
    print("handling event $event");
  }
}
