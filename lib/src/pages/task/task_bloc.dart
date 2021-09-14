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
  String action = "irrigation";

  TaskBloc(this.initial) : super(TaskState.initial());

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
    yield state.update(isFetched: this.initial != null, initial: initial);
  }

  bool isValid() {
    return hours != null && minutes != null && ec != null && duration != null;
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
  }

  Task task() {
    return Task(hours!, minutes!, ec!, duration!, action);
  }

  void dispose() {}
}
