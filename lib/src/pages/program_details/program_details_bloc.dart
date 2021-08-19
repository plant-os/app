import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'program_details_state.dart';
part 'program_details_event.dart';

class ProgramDetailsBloc
    extends Bloc<ProgramDetailsEvent, ProgramDetailsState> {
  final String programId;
  final Program initial;

  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  ProgramDetailsBloc(this.programId, this.initial)
      : super(ProgramDetailsStateLoading());

  @override
  Stream<ProgramDetailsState> mapEventToState(
      ProgramDetailsEvent event) async* {
    print("handling event $event");
    if (event is LoadProgramDetailsEvent) {
      programsService.listSchedules(programId).listen((event) {
        add(SchedulesLoaded(event));
      });
    } else if (event is SchedulesLoaded) {
      yield* _mapSchedulesLoadedToState(event);
    }
  }

  void dispose() {}

  Stream<ProgramDetailsState> _mapSchedulesLoadedToState(
      SchedulesLoaded event) async* {
    yield ProgramDetailsStateDone(initial, event.schedules);
  }
}
