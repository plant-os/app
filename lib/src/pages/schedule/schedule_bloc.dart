import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/schedule.dart';
import 'package:plantos/src/models/task.dart';
import 'package:plantos/src/services/programs_service.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ProgramsService _programsService = ProgramsService();

  final String programId;
  final String? scheduleId;
  final Schedule? initial;

  String name = "";
  int startDay = 0;
  List<Task> tasks = [];

  ScheduleBloc(this.programId, this.scheduleId, this.initial)
      : super(ScheduleState.initial());

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleLoadedEvent) {
      if (initial != null) {
        tasks = []..addAll(initial!.tasks);
      }
      yield state.update(
        isFetched: initial != null,
        initial: initial,
        tasks: List.unmodifiable(tasks),
      );
    } else if (event is ScheduleTextFieldChangedEvent) {
      yield* _mapTextFieldChangedToState(event);
    } else if (event is SchedulePressedEvent) {
      yield* _mapSchedulePressedToState();
    } else if (event is ScheduleAddTaskEvent) {
      tasks.add(event.task);
      yield state.update(tasks: List.unmodifiable(tasks));
    } else if (event is ScheduleEditTaskEvent) {
      tasks.removeAt(event.index);
      tasks.insert(event.index, event.task);
      yield state.update(tasks: List.unmodifiable(tasks));
    } else if (event is ScheduleDeleteTaskEvent) {
      tasks.removeAt(event.index);
      yield state.update(tasks: List.unmodifiable(tasks));
    }
  }

  Stream<ScheduleState> _mapTextFieldChangedToState(
      ScheduleTextFieldChangedEvent event) async* {
    name = event.name;
    var parsedDay = int.tryParse(event.startDay);
    if (parsedDay != null) {
      startDay = parsedDay;
    }
    yield state.update(
      isValid: name.isNotEmpty,
      isFetched: false,
    );
  }

  Stream<ScheduleState> _mapSchedulePressedToState() async* {
    yield state.update(isLoading: true);
    try {
      var schedule = Schedule(
        id: scheduleId,
        name: name,
        startDay: startDay,
        tasks: tasks,
      );
      if (scheduleId == null) {
        _programsService.addSchedule(programId, schedule);
      } else {
        _programsService.updateSchedule(programId, scheduleId!, schedule);
      }
      yield state.update(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      yield state.update(
        isLoading: false,
        error: "$e",
      );
    } finally {
      yield ScheduleState.initial(isValid: name.isNotEmpty);
    }
  }
}
