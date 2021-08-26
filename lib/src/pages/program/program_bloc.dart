import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/schedule.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'program_state.dart';
part 'program_event.dart';

class ProgramBloc extends Bloc<ProgramEvent, ProgramState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  final String programId;
  final Program program;

  ProgramBloc(this.programId, this.program)
      : super(ProgramState.initial(program: program));

  void dispose() {}

  @override
  Stream<ProgramState> mapEventToState(ProgramEvent event) async* {
    print("handling event $event");
    if (event is ProgramLoadEvent) {
      programsService.listSchedules(programId).listen((event) {
        add(ProgramSchedulesLoadedEvent(event));
      });
    } else if (event is ProgramSchedulesLoadedEvent) {
      yield* _mapSchedulesLoadedToState(event);
    } else if (event is ProgramDeleteScheduleEvent) {
      programsService.deleteSchedule(programId, event.scheduleId);
    }
  }

  Stream<ProgramState> _mapSchedulesLoadedToState(
      ProgramSchedulesLoadedEvent event) async* {
    yield state.update(
      isLoading: false,
      isFetched: true,
      schedules: event.schedules,
    );
  }
}
