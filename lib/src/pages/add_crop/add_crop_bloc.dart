import 'package:flutter/material.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'add_crop_event.dart';
part 'add_crop_state.dart';

class AddCropBloc extends Bloc<AddCropEvent, AddCropState> {
  final CropsService cropsService;
  final AuthService authService;
  final UserService userService;

  AddCropBloc(this.cropsService, this.authService, this.userService);

  @override
  AddCropState get initialState => AddCropState.initial();

  @override
  Stream<AddCropState> mapEventToState(AddCropEvent event) async* {
    if (event is CropFieldChangedEvent) {
      yield* _mapCropFieldChangedToState(event);
    } else if (event is ClickSubmitAddCropEvent) {
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

  Stream<AddCropState> _mapCropFieldChangedToState(
      CropFieldChangedEvent event) async* {
    yield state.update(isValid: _isFormValidated(event.crop), crop: event.crop);
  }

  Stream<AddCropState> _mapAddCropPressedToState(
      ClickSubmitAddCropEvent event) async* {
    yield state.update(isLoading: true);
    try {
      var firebaseUser = await authService.getCurrentUser();
      var currentUser =
          await userService.getCurrentUserDetails(firebaseUser.email);
      await cropsService.addCrop(state.crop, currentUser);
      yield state.update(isLoading: false, isSuccess: true);
    } catch (e) {
      print(e);
      yield state.update(isLoading: false, error: e.message);
      yield AddCropState.initial(
          crop: state.crop, isValid: _isFormValidated(state.crop));
    }
  }
}
