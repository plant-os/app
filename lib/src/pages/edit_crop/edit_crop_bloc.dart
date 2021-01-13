import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'edit_crop_event.dart';
part 'edit_crop_state.dart';

class EditCropBloc extends Bloc<EditCropEvent, EditCropState> {
  final CropsService cropsService;
  final AuthService authService;
  final UserService userService;

  final Crop initialCrop;

  EditCropBloc(
      this.cropsService, this.authService, this.userService, this.initialCrop)
      : super(EditCropState.initial(crop: initialCrop));

  @override
  Stream<EditCropState> mapEventToState(EditCropEvent event) async* {
    if (event is EditCropFieldChangedEvent) {
      yield* _mapCropFieldChangedToState(event);
    } else if (event is ClickSubmitEditCropEvent) {
      yield* _mapAddCropPressedToState(event);
    } else if (event is ChangeCropStateEvent) {
      yield* _mapChangeCropStateEventToState(event);
    } else if (event is SetStartDateEvent) {
      yield* _mapSetStartDateEventToState(event);
    } else if (event is ChangeNameEvent) {
      yield* _mapChangeNameEventToState(event);
    } else if (event is ChangeEcEvent) {
      yield* _mapChangeEcEventToState(event);
    } else if (event is AddScheduleEvent) {
      yield* _mapAddScheduleEventState(event);
    } else if (event is ChangeScheduleEvent) {
      yield* _mapChangeScheduleEventToState(event);
    } else if (event is RemoveScheduleEvent) {
      yield* _mapRemoveScheduleEventToState(event);
    } else {
      throw Exception("unhandled event");
    }
  }

  bool _isFormValidated(Crop crop) {
    return crop.name.isNotEmpty &&
        crop.ec.isNotEmpty &&
        crop.cropState.toJson().values.any((element) => element == true) &&
        crop.fertigationCrop == true &&
        crop.schedules.length > 0 &&
        crop.startDate != null;
  }

  void dispose() {}

  Stream<EditCropState> _mapCropFieldChangedToState(
      EditCropFieldChangedEvent event) async* {
    yield state.update(isValid: _isFormValidated(event.crop), crop: event.crop);
  }

  Stream<EditCropState> _mapChangeScheduleEventToState(
      ChangeScheduleEvent event) async* {
    var schedules = List.from(state.crop.schedules);
    schedules[event.index] = event.schedule;

    yield state.update(crop: state.crop.withValues(schedules: schedules));
  }

  Stream<EditCropState> _mapRemoveScheduleEventToState(
      RemoveScheduleEvent event) async* {
    var schedules = List.from(state.crop.schedules);
    schedules.removeAt(event.index);
    yield state.update(crop: state.crop.withValues(schedules: schedules));
  }

  Stream<EditCropState> _mapAddScheduleEventState(
      AddScheduleEvent event) async* {
    var updatedSchedules = List.from(state.crop.schedules)..add(event.schedule);
    yield state.update(
        crop: state.crop.withValues(schedules: updatedSchedules));
  }

  Stream<EditCropState> _mapChangeNameEventToState(
      ChangeNameEvent event) async* {
    yield state.update(crop: state.crop.withValues(name: event.name));
  }

  Stream<EditCropState> _mapChangeEcEventToState(ChangeEcEvent event) async* {
    yield state.update(crop: state.crop.withValues(ec: event.ec));
  }

  Stream<EditCropState> _mapSetStartDateEventToState(
      SetStartDateEvent event) async* {
    yield state.update(
        crop: state.crop
            .withValues(startDate: Timestamp.fromDate(event.startDate)));
  }

  Stream<EditCropState> _mapChangeCropStateEventToState(
      ChangeCropStateEvent event) async* {
    yield state.update(
        crop: state.crop
            .withValues(cropState: CropState.of(event.updatedCropState)));
  }

  Stream<EditCropState> _mapAddCropPressedToState(
      ClickSubmitEditCropEvent event) async* {
    yield state.update(isLoading: true);
    try {
      await cropsService.editCrop(state.crop);
      yield state.update(isLoading: false, isSuccess: true);
    } catch (e) {
      print(e);
      yield state.update(isLoading: false, error: e.message);
      yield EditCropState.initial(
          crop: state.crop, isValid: _isFormValidated(state.crop));
    }
  }
}
