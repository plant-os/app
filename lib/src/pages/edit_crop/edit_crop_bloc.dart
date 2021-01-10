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

  EditCropBloc(this.cropsService, this.authService, this.userService)
      : super(EditCropState.initial());

  @override
  Stream<EditCropState> mapEventToState(EditCropEvent event) async* {
    if (event is EditCropFieldChangedEvent) {
      yield* _mapCropFieldChangedToState(event);
    } else if (event is ClickSubmitEditCropEvent) {
      yield* _mapAddCropPressedToState(event);
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
