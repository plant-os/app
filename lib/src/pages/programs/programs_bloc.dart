import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/program.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'programs_state.dart';
part 'programs_event.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  ProgramsBloc() : super(ProgramsStateLoading());

  @override
  Stream<ProgramsState> mapEventToState(ProgramsEvent event) async* {
    if (event is ProgramsInitialFetchEvent) {
      initialise();
    } else if (event is ProgramsLoaded) {
      yield* _mapLoadProgramsToState(event);
    } else if (event is DeleteProgramEvent) {
      programsService.delete(event.programId);
    } else if (event is EditProgramEvent) {
    } else if (event is NewProgramEvent) {
      // TODO: Show new program modal.
    }
  }

  void initialise() async {
    var firebaseUser = await authService.getCurrentUser();

    // To get the Programs belonging to the company we need the current user's
    // company id.
    var currentUser =
        await userService.getCurrentUserDetails(firebaseUser!.email!);

    // Whenever the list of programs changes we pipe the new list into a
    // ProgramsLoaded event.
    programsService.list(currentUser.company!.id).listen((programs) {
      add(ProgramsLoaded(programs));
    });
  }

  void dispose() {}

  Stream<ProgramsState> _mapLoadProgramsToState(ProgramsLoaded event) async* {
    yield ProgramsStateDone(event.programs);
  }
}
