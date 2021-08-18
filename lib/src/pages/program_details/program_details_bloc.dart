import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'program_details_state.dart';
part 'program_details_event.dart';

class ProgramDetailsBloc
    extends Bloc<ProgramDetailsEvent, ProgramDetailsState> {
  final String id;
  final Program initial;

  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  ProgramDetailsBloc(this.id, this.initial) : super(ProgramDetailsStateLoading());

  @override
  Stream<ProgramDetailsState> mapEventToState(
      ProgramDetailsEvent event) async* {
    if (event is ProgramDetailsLoaded) {
      yield* _mapLoadProgramDetailsToState(event);
    }
  }

  void dispose() {}

  Stream<ProgramDetailsState> _mapLoadProgramDetailsToState(
      ProgramDetailsLoaded event) async* {
    yield ProgramDetailsStateDone(event.programs);
  }
}
