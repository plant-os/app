import 'package:flutter/material.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/crops_service.dart';

part 'add_schedule_event.dart';
part 'add_schedule_state.dart';

class AddScheduleBloc extends Bloc<AddScheduleEvent, AddScheduleState> {
  final CropsService cropsService;

  AddScheduleBloc(this.cropsService);

  @override
  AddScheduleState get initialState => AddScheduleState.initial();

  @override
  Stream<AddScheduleState> mapEventToState(AddScheduleEvent event) async* {
    if (event is ScheduleFieldChangedEvent) {
      yield* _mapScheduleFieldChangedToState(event);
    } else if (event is ClickSubmitAddScheduleEvent) {
      yield* _mapAddSchedulePressedToState(event);
    }
  }

  void dispose() {}

  bool _isFormValidated(CropAction action, Repeat repeat) {
    return repeat.toJson().values.any((element) => element == true) &&
        action.toJson().values.any((element) => element == true);
  }

  Stream<AddScheduleState> _mapScheduleFieldChangedToState(
      ScheduleFieldChangedEvent event) async* {
    yield state.update(
        isValid: _isFormValidated(event.schedule.action, event.schedule.repeat),
        schedule: event.schedule);
  }

  Stream<AddScheduleState> _mapAddSchedulePressedToState(
      ClickSubmitAddScheduleEvent event) async* {}
}
