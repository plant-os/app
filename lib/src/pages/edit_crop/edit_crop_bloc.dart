import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';
import 'package:quiver/strings.dart';

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

  void dispose() {}

  @override
  Stream<EditCropState> mapEventToState(EditCropEvent event) async* {
    if (event is ClickSubmitEditCropEvent) {
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
    return isNotBlank(crop.name) &&
        isNotBlank(crop.ec) &&
        crop.startDate != null;
  }

  Stream<EditCropState> _mapChangeScheduleEventToState(
      ChangeScheduleEvent event) async* {
    List<Schedule> schedules = List.from(state.crop.schedules);
    schedules[event.index] = event.schedule;

    var updatedCrop = state.crop.withValues(schedules: schedules);

    yield state.update(
        isValid: _isFormValidated(updatedCrop), crop: updatedCrop);
  }

  Stream<EditCropState> _mapRemoveScheduleEventToState(
      RemoveScheduleEvent event) async* {
    List<Schedule> schedules = List.from(state.crop.schedules);
    schedules.removeAt(event.index);

    var updatedCrop = state.crop.withValues(schedules: schedules);

    yield state.update(
        isValid: _isFormValidated(updatedCrop), crop: updatedCrop);
  }

  Stream<EditCropState> _mapAddScheduleEventState(
      AddScheduleEvent event) async* {
    List<Schedule> updatedSchedules = List.from(state.crop.schedules)
      ..add(event.schedule);
    var updatedCrop = state.crop.withValues(schedules: updatedSchedules);
    yield state.update(
        isValid: _isFormValidated(updatedCrop), crop: updatedCrop);
  }

  Stream<EditCropState> _mapChangeNameEventToState(
      ChangeNameEvent event) async* {
    var updatedCrop = state.crop.withValues(name: event.name);
    yield state.update(
        isValid: _isFormValidated(updatedCrop), crop: updatedCrop);
  }

  Stream<EditCropState> _mapChangeEcEventToState(ChangeEcEvent event) async* {
    var updatedCrop = state.crop.withValues(ec: event.ec);
    yield state.update(
        isValid: _isFormValidated(updatedCrop), crop: updatedCrop);
  }

  Stream<EditCropState> _mapSetStartDateEventToState(
      SetStartDateEvent event) async* {
    var updatedCrop =
        state.crop.withValues(startDate: Timestamp.fromDate(event.startDate));
    yield state.update(
        isValid: _isFormValidated(updatedCrop), crop: updatedCrop);
  }

  Stream<EditCropState> _mapChangeCropStateEventToState(
      ChangeCropStateEvent event) async* {
    var updatedCrop =
        state.crop.withValues(cropState: CropState.of(event.updatedCropState));
    yield state.update(
        isValid: _isFormValidated(updatedCrop), crop: updatedCrop);
  }

  Stream<EditCropState> _mapAddCropPressedToState(
      ClickSubmitEditCropEvent event) async* {
    yield state.update(isLoading: true);
    try {
      if (initialCrop == null) {
        var firebaseUser = await authService.getCurrentUser();
        var currentUser =
            await userService.getCurrentUserDetails(firebaseUser.email);
        var cropWithCompany =
            state.crop.withValues(company: currentUser.company);
        await cropsService.addCrop(cropWithCompany, currentUser);
      } else {
        await cropsService.editCrop(state.crop);
      }
      yield state.update(isLoading: false, isSuccess: true);
    } catch (e) {
      print(e);
      yield state.update(isLoading: false, error: e.message);
      yield EditCropState.initial(
          crop: state.crop, isValid: _isFormValidated(state.crop));
    }
  }
}
