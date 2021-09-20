import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/task.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'task_state.dart';
part 'task_event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Task? initial;

  AuthService authService = AuthService();
  UserService userService = UserService();
  ProgramsService programsService = ProgramsService();

  int? hours;
  int? minutes;
  double? ec;
  int? duration;
  String action;

  TaskBloc(this.initial)
      : action = initial?.action ?? "irrigation",
        super(TaskState.initial());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    print("handling event $event");
    if (event is TaskTextFieldChangedEvent) {
      yield* _mapTaskTextFieldChangedEventToState(event);
    } else if (event is TaskActionChangedEvent) {
      yield* _mapTaskActionChangedEventToState(event);
    } else if (event is TaskLoadedEvent) {
      yield* _mapTaskTaskLoadedEventEventToState();
    }
  }

  Stream<TaskState> _mapTaskTaskLoadedEventEventToState() async* {
    yield state.update(
        isFetched: this.initial != null,
        initial: initial,
        showEc: action == "fertigation");
  }

  bool isValid() {
    return hours != null &&
        hours! >= 0 &&
        hours! < 24 &&
        minutes != null &&
        minutes! >= 0 &&
        minutes! < 60 &&
        (action == "irrigation" || ec != null) &&
        duration != null &&
        duration! > 0;
  }

  Stream<TaskState> _mapTaskTextFieldChangedEventToState(
      TaskTextFieldChangedEvent event) async* {
    hours = int.tryParse(event.hours);
    minutes = int.tryParse(event.minutes);
    ec = double.tryParse(event.ec);
    duration = int.tryParse(event.duration);

    // Set isFetched to false here as we want to ensure the text fields aren't reset to the initial values.
    yield state.update(isValid: isValid(), isFetched: false);
  }

  Stream<TaskState> _mapTaskActionChangedEventToState(
      TaskActionChangedEvent event) async* {
    action = event.action;
    yield state.update(showEc: action == "fertigation");
  }

  Task task() {
    return Task(hours!, minutes!, ec ?? 0.0, duration!, action);
  }

  void dispose() {}
}
