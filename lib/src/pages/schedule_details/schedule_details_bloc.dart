import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/task.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/programs_service.dart';

part 'schedule_details_event.dart';
part 'schedule_details_state.dart';

class ScheduleDetailsBloc
    extends Bloc<ScheduleDetailsEvent, ScheduleDetailsState> {
  AuthService _authService = AuthService();
  ProgramsService _programsService = ProgramsService();

  final String programId;
  final String? scheduleId;
  final Schedule? initial;

  String name = "";
  int startDay = 0;
  List<Task> tasks = [];

  ScheduleDetailsBloc(this.programId, this.scheduleId, this.initial)
      : super(ScheduleDetailsState.initial());

  @override
  Stream<ScheduleDetailsState> mapEventToState(
      ScheduleDetailsEvent event) async* {
    if (event is ScheduleDetailsLoadedEvent) {
      if (initial != null) {
        tasks = []..addAll(initial!.tasks);
      }
      yield state.update(
          isFetched: initial != null,
          initial: initial,
          tasks: List.unmodifiable(tasks));
    } else if (event is ScheduleDetailsTextFieldChangedEvent) {
      yield* _mapTextFieldChangedToState(event);
    } else if (event is ScheduleDetailsPressedEvent) {
      yield* _mapScheduleDetailsPressedToState();
    } else if (event is ScheduleDetailsAddTaskEvent) {
      tasks.add(event.task);
      yield state.update(tasks: List.unmodifiable(tasks));
    } else if (event is ScheduleDetailsEditTaskEvent) {
      tasks.removeAt(event.index);
      tasks.insert(event.index, event.task);
      yield state.update(tasks: List.unmodifiable(tasks));
    } else if (event is ScheduleDetailsDeleteTaskEvent) {
      tasks.removeAt(event.index);
      yield state.update(tasks: List.unmodifiable(tasks));
    }
  }

  Stream<ScheduleDetailsState> _mapTextFieldChangedToState(
      ScheduleDetailsTextFieldChangedEvent event) async* {
    name = event.name;
    var parsedDay = int.tryParse(event.startDay);
    if (parsedDay != null) {
      startDay = parsedDay;
    }
    yield state.update(isValid: name.isNotEmpty, isFetched: false);
  }

  Stream<ScheduleDetailsState> _mapScheduleDetailsPressedToState() async* {
    yield state.update(isLoading: true);
    try {
      if (scheduleId == null) {
        _programsService.addSchedule(
            programId, Schedule(scheduleId, name, startDay, tasks));
      } else {
        _programsService.updateSchedule(programId, scheduleId!,
            Schedule(scheduleId, name, startDay, tasks));
      }
      yield state.update(isLoading: false, isSuccess: true);
    } catch (e) {
      print(e);
      yield state.update(isLoading: false, error: "$e");
    } finally {
      yield ScheduleDetailsState.initial(isValid: name.isNotEmpty);
    }
  }
}
