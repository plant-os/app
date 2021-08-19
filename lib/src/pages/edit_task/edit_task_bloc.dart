import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/task.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'edit_task_state.dart';
part 'edit_task_event.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final Task? initial;

  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  int? hours;
  int? minutes;
  double? ec;
  int? duration;
  String action = "Irrigation";

  EditTaskBloc(this.initial) : super(EditTaskState.initial());

  @override
  Stream<EditTaskState> mapEventToState(EditTaskEvent event) async* {
    print("handling event $event");
    if (event is EditTaskTextFieldChangedEvent) {
      yield* _mapEditTaskTextFieldChangedEventToState(event);
    } else if (event is EditTaskActionChangedEvent) {
      yield* _mapEditTaskActionChangedEventToState(event);
    } else if (event is EditTaskLoadedEvent) {
      yield* _mapEditTaskEditTaskLoadedEventEventToState();
    }
  }

  Stream<EditTaskState> _mapEditTaskEditTaskLoadedEventEventToState() async* {
    yield state.update(isFetched: this.initial != null, initial: initial);
  }

  bool isValid() {
    return hours != null && minutes != null && ec != null && duration != null;
  }

  Stream<EditTaskState> _mapEditTaskTextFieldChangedEventToState(
      EditTaskTextFieldChangedEvent event) async* {
    hours = int.tryParse(event.hours);
    minutes = int.tryParse(event.minutes);
    ec = double.tryParse(event.ec);
    duration = int.tryParse(event.duration);

    // Set isFetched to false here as we want to ensure the text fields aren't reset to the initial values.
    yield state.update(isValid: isValid(), isFetched: false);
  }

  Stream<EditTaskState> _mapEditTaskActionChangedEventToState(
      EditTaskActionChangedEvent event) async* {
    action = event.action;
  }

  Task task() {
    return Task(hours!, minutes!, ec!, duration!, action);
  }

  void dispose() {}
}
