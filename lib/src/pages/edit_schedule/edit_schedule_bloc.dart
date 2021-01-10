import 'package:flutter/material.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_schedule_event.dart';
part 'edit_schedule_state.dart';

class EditScheduleBloc extends Bloc<EditScheduleEvent, EditScheduleState> {
  final Schedule schedule;

  EditScheduleBloc(this.schedule) : super(EditScheduleState.initial());

  @override
  Stream<EditScheduleState> mapEventToState(EditScheduleEvent event) async* {
    if (event is EditScheduleFieldChangedEvent) {
      yield* _mapScheduleFieldChangedToState(event);
    } else if (event is ClickSubmitEditScheduleEvent) {
      yield* _mapAddSchedulePressedToState(event);
    }
  }

  void dispose() {}

  bool _isFormValidated(CropAction action, Repeat repeat) {
    return repeat.toJson().values.any((element) => element == true) &&
        action.toJson().values.any((element) => element == true);
  }

  Stream<EditScheduleState> _mapScheduleFieldChangedToState(
      EditScheduleFieldChangedEvent event) async* {
    yield state.update(
        isValid: _isFormValidated(event.schedule.action, event.schedule.repeat),
        schedule: event.schedule);
  }

  Stream<EditScheduleState> _mapAddSchedulePressedToState(
      ClickSubmitEditScheduleEvent event) async* {}
}
