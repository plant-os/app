import 'package:flutter/material.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'edit_schedule_event.dart';
part 'edit_schedule_state.dart';

class EditScheduleBloc extends Bloc<EditScheduleEvent, EditScheduleState> {
  EditScheduleBloc(Schedule schedule)
      : super(EditScheduleState.initial(schedule: schedule));

  @override
  Stream<EditScheduleState> mapEventToState(EditScheduleEvent event) async* {
    print("handling event $event");
    if (event is EditScheduleFieldChangedEvent) {
      yield* _mapScheduleFieldChangedToState(event);
    } else if (event is EditTimeEvent) {
      yield* _mapEditTimeToState(event.time);
    } else if (event is ToggleRepeatEvent) {
      yield* _mapToggleRepeatToState(event.day);
    } else if (event is SetActionEvent) {
      yield* _mapSetActionToState(event.isFertigation);
    } else if (event is ClickSubmitEditScheduleEvent) {
      yield* _mapAddSchedulePressedToState(event);
    }
  }

  void dispose() {}

  bool _isFormValidated(CropAction action, Repeat repeat) {
    return true;
  }

  Stream<EditScheduleState> _mapScheduleFieldChangedToState(
      EditScheduleFieldChangedEvent event) async* {
    yield state.update(
        isValid: _isFormValidated(event.schedule.action, event.schedule.repeat),
        schedule: event.schedule);
  }

  Stream<EditScheduleState> _mapEditTimeToState(TimeOfDay time) async* {
    // FIXME(simon): We shouldn't be storing year and month here. We should
    // store the hour and minute in firestore rather than using a Timestamp.
    DateTime timeOfDay = DateTime(1970, 1, 1, time.hour, time.minute);

    Schedule updated =
        state.schedule.copyWith(time: Timestamp.fromDate(timeOfDay));

    var updatedS = state.update(schedule: updated);

    yield state.update(schedule: updated);
  }

// FIXME(simon): This is wacky.
  Repeat toggleDay(String day) {
    switch (day) {
      case "Monday":
        return state.schedule.repeat
            .copyWith(monday: !state.schedule.repeat.monday);
      case "Tuesday":
        return state.schedule.repeat
            .copyWith(tuesday: !state.schedule.repeat.tuesday);
      case "Wednesday":
        return state.schedule.repeat
            .copyWith(wednesday: !state.schedule.repeat.wednesday);
      case "Thursday":
        return state.schedule.repeat
            .copyWith(thursday: !state.schedule.repeat.thursday);
      case "Friday":
        return state.schedule.repeat
            .copyWith(friday: !state.schedule.repeat.friday);
      case "Saturday":
        return state.schedule.repeat
            .copyWith(saturday: !state.schedule.repeat.saturday);
      case "Sunday":
        return state.schedule.repeat
            .copyWith(sunday: !state.schedule.repeat.sunday);
      default:
        throw Exception("Unhandled case");
    }
  }

  Stream<EditScheduleState> _mapToggleRepeatToState(String day) async* {
    yield state.update(
        schedule: state.schedule.copyWith(repeat: toggleDay(day)));
  }

  Stream<EditScheduleState> _mapSetActionToState(bool isFertigation) async* {
    // FIXME(simon): Huh??
    yield state.update(
        schedule: state.schedule
            .copyWith(action: CropAction(!isFertigation, isFertigation)));
  }

  Stream<EditScheduleState> _mapAddSchedulePressedToState(
      ClickSubmitEditScheduleEvent event) async* {}
}
