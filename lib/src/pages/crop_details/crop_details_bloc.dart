import 'package:flutter/material.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'crop_details_event.dart';
part 'crop_details_state.dart';

class CropDetailsBloc extends Bloc<CropDetailsEvent, CropDetailsState> {
  final CropsService cropsService;
  final AuthService authService;
  final UserService userService;

  CropDetailsBloc(this.cropsService, this.authService, this.userService);

  @override
  CropDetailsState get initialState => CropDetailsState.initial();

  @override
  Stream<CropDetailsState> mapEventToState(CropDetailsEvent event) async* {}

  void dispose() {}
}
