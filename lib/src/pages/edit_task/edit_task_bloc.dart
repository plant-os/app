import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/task.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'edit_task_state.dart';
part 'edit_task_event.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final String id;
  final Task initial;

  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  EditTaskBloc(this.id, this.initial) : super(EditTaskState());

  @override
  Stream<EditTaskState> mapEventToState(EditTaskEvent event) async* {
    // TODO:
    // - change hour
    // - change minute
    // - change task
    // - change EC
    // - change duration

    // if (event is EditTaskLoaded) {
    //   yield* _mapLoadEditTaskToState(event);
    // }
  }

  void dispose() {}

  // Stream<EditTaskState> _mapLoadEditTaskToState(EditTaskLoaded event) async* {
  //   yield EditTaskState();
  // }
}
