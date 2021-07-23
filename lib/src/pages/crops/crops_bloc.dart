import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/user.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

part 'crops_event.dart';
part 'crops_state.dart';

class CropsBloc extends Bloc<CropsEvent, CropsState> {
  final AuthService authService;
  final UserService userService;
  final CropsService cropsService;

  CropsBloc(this.authService, this.cropsService, this.userService)
      : super(CropStateLoading()) {
    initialise();
  }

  @override
  Stream<CropsState> mapEventToState(CropsEvent event) async* {
    if (event is CropsLoaded) {
      yield* _mapLoadCropsToState(event);
    }
  }

  void initialise() async {
    var firebaseUser = await authService.getCurrentUser();

    // To get the crops belonging to the company we need the current user's company Id.
    var currentUser =
        await userService.getCurrentUserDetails(firebaseUser!.email!);
    cropsService.getCropslist(currentUser.company!.id).listen((crops) {
      add(
        CropsLoaded(crops, currentUser),
      );
    });
  }

  String cropStateIndicator(CropState state) {
    if (state.vegetative) {
      return "Vegetative";
    } else if (state.budding) {
      return "Budding";
    } else if (state.flowering) {
      return "Flowering";
    } else if (state.harvested) {
      return "Harvested";
    } else if (state.ripening) {
      return "Ripening";
    }
    return "Not Specified";
  }

  int convertDate(Timestamp startDate) {
    var dateTimeStartDate = new DateTime.fromMillisecondsSinceEpoch(
        startDate.millisecondsSinceEpoch);
    var currentTime = DateTime.now();
    var diff = currentTime.difference(dateTimeStartDate).inDays;
    return diff;
  }

  void dispose() {}

  Stream<CropsState> _mapLoadCropsToState(CropsLoaded event) async* {
    var ongoingCrops =
        event.crops.where((crop) => crop.cropState!.harvested != true).toList();
    var pastCrops =
        event.crops.where((crop) => crop.cropState!.harvested == true).toList();
    yield CropsStateDone(ongoingCrops, pastCrops, event.currentUser);
  }
}
