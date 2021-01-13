import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/semantics.dart';
import 'package:plantos/src/models/crop.dart';
import 'dart:async';
import 'package:intl/intl.dart';
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

  StreamSubscription cropSubscription;
  StreamSubscription skipsSubscription;

  Crop loadedCrop;
  List<ActionRepeat> loadedSkips;

  CropDetailsBloc(
      this.cropsService, this.authService, this.userService, Crop crop)
      : super(LoadingState()) {
    cropSubscription = cropsService
        .get(crop.id)
        .listen((crop) => add(CropSnapshotEvent(crop)));
    skipsSubscription = cropsService
        .skippedActions(crop.id)
        .listen((skips) => add(SkipsSnapshotEvent(skips)));
  }

  @override
  Stream<CropDetailsState> mapEventToState(CropDetailsEvent event) async* {
    print("handling event $event");
    if (event is CropSnapshotEvent) {
      yield* _mapCropSnapshotEventToState(event);
    } else if (event is SkipsSnapshotEvent) {
      yield* _mapSkipsSnapshotEventToState(event);
    } else if (event is ClickChangeActionStatusEvent) {
      yield* _mapClickChangeActionStatusEventToState(event);
    } else {
      throw Exception("unhandled event");
    }
  }

  void dispose() {
    cropSubscription.cancel();
    skipsSubscription.cancel();
  }

  Stream<CropDetailsState> _mapCropSnapshotEventToState(
      CropSnapshotEvent event) async* {
    loadedCrop = event.crop;

    if (loadedCrop != null && loadedSkips != null) {
      yield LoadedState(
          loadedCrop, generateActionRepeats(loadedCrop, loadedSkips));
    }
  }

  Stream<CropDetailsState> _mapSkipsSnapshotEventToState(
      SkipsSnapshotEvent event) async* {
    loadedSkips = event.skips;

    if (loadedCrop != null && loadedSkips != null) {
      yield LoadedState(
          loadedCrop, generateActionRepeats(loadedCrop, loadedSkips));
    }
  }

  Stream<CropDetailsState> _mapClickChangeActionStatusEventToState(
      ClickChangeActionStatusEvent event) async* {
    if (event.action.canceled) {
      await cropsService.deleteActionFromSkipped(event.action.id);
    } else {
      await cropsService.addActionToSkipped(event.action);
    }
    // We intentionally avoid updating the state here as we'll get back a
    // snapshot from the database when it's actually changed via
    // SkipsSnapshotEvent.
  }

  List<DateTime> generateDays() {
    final start = DateTime.now();
    final days = List.generate(
      7,
      (i) => DateTime(
        start.year,
        start.month,
        start.day + (i),
      ),
    );
    return days;
  }

  List<ActionRepeat> generateActionRepeats(
      Crop crop, List<ActionRepeat> skippedactionRepeats) {
    final actionRepeats = <ActionRepeat>[];
    final days = generateDays();

    days.forEach(
      (day) {
        var dayOfTHeWeek = DateFormat('EEEE').format(day);
        crop.schedules.forEach((schedule) async {
          if (dayOfTHeWeek == "Monday") {
            if (schedule.repeat.monday == true) {
              final scheduleDateTime = schedule.time.toDate();
              final time = DateTime(day.year, day.month, day.day,
                  scheduleDateTime.hour, scheduleDateTime.minute);
              var actionRepeat = ActionRepeat(
                  cropId: crop.id,
                  time: Timestamp.fromDate(time),
                  action: schedule.action.irrigation == true
                      ? "Irrigation"
                      : "Fertigation",
                  canceled: false);
              var foundSkippedActions = skippedactionRepeats
                  .where((action) =>
                      action.action == actionRepeat.action &&
                      action.time == actionRepeat.time)
                  .toList();

              if (foundSkippedActions.length > 0) {
                actionRepeat.canceled = true;
                actionRepeat.id = foundSkippedActions.first.id;
                actionRepeats.add(actionRepeat);
              } else {
                actionRepeats.add(actionRepeat);
              }
            }
          } else if (dayOfTHeWeek == "Tuesday") {
            if (schedule.repeat.tuesday == true) {
              final scheduleDateTime = schedule.time.toDate();
              final time = DateTime(day.year, day.month, day.day,
                  scheduleDateTime.hour, scheduleDateTime.minute);
              var actionRepeat = ActionRepeat(
                  cropId: crop.id,
                  time: Timestamp.fromDate(time),
                  action: schedule.action.irrigation == true
                      ? "Irrigation"
                      : "Fertigation",
                  canceled: false);
              var foundSkippedActions = skippedactionRepeats
                  .where((action) =>
                      action.action == actionRepeat.action &&
                      action.time == actionRepeat.time)
                  .toList();

              if (foundSkippedActions.length > 0) {
                actionRepeat.canceled = true;
                actionRepeat.id = foundSkippedActions.first.id;
                actionRepeats.add(actionRepeat);
              } else {
                actionRepeats.add(actionRepeat);
              }
            }
          } else if (dayOfTHeWeek == "Wednesday") {
            if (schedule.repeat.wednesday == true) {
              final scheduleDateTime = schedule.time.toDate();
              final time = DateTime(day.year, day.month, day.day,
                  scheduleDateTime.hour, scheduleDateTime.minute);
              var actionRepeat = ActionRepeat(
                  cropId: crop.id,
                  time: Timestamp.fromDate(time),
                  action: schedule.action.irrigation == true
                      ? "Irrigation"
                      : "Fertigation",
                  canceled: false);
              var foundSkippedActions = skippedactionRepeats
                  .where((action) =>
                      action.action == actionRepeat.action &&
                      action.time == actionRepeat.time)
                  .toList();

              if (foundSkippedActions.length > 0) {
                actionRepeat.canceled = true;
                actionRepeat.id = foundSkippedActions.first.id;
                actionRepeats.add(actionRepeat);
              } else {
                actionRepeats.add(actionRepeat);
              }
            }
          } else if (dayOfTHeWeek == "Thursday") {
            if (schedule.repeat.thursday == true) {
              final scheduleDateTime = schedule.time.toDate();
              final time = DateTime(day.year, day.month, day.day,
                  scheduleDateTime.hour, scheduleDateTime.minute);
              var actionRepeat = ActionRepeat(
                  cropId: crop.id,
                  time: Timestamp.fromDate(time),
                  action: schedule.action.irrigation == true
                      ? "Irrigation"
                      : "Fertigation",
                  canceled: false);
              var foundSkippedActions = skippedactionRepeats
                  .where((action) =>
                      action.action == actionRepeat.action &&
                      action.time == actionRepeat.time)
                  .toList();

              if (foundSkippedActions.length > 0) {
                actionRepeat.canceled = true;
                actionRepeat.id = foundSkippedActions.first.id;
                actionRepeats.add(actionRepeat);
              } else {
                actionRepeats.add(actionRepeat);
              }
            }
          } else if (dayOfTHeWeek == "Friday") {
            if (schedule.repeat.friday == true) {
              final scheduleDateTime = schedule.time.toDate();
              final time = DateTime(day.year, day.month, day.day,
                  scheduleDateTime.hour, scheduleDateTime.minute);
              var actionRepeat = ActionRepeat(
                  cropId: crop.id,
                  time: Timestamp.fromDate(time),
                  action: schedule.action.irrigation == true
                      ? "Irrigation"
                      : "Fertigation",
                  canceled: false);
              var foundSkippedActions = skippedactionRepeats
                  .where((action) =>
                      action.action == actionRepeat.action &&
                      action.time == actionRepeat.time)
                  .toList();

              if (foundSkippedActions.length > 0) {
                actionRepeat.canceled = true;
                actionRepeat.id = foundSkippedActions.first.id;
                actionRepeats.add(actionRepeat);
              } else {
                actionRepeats.add(actionRepeat);
              }
            }
          } else if (dayOfTHeWeek == "Saturday") {
            if (schedule.repeat.saturday == true) {
              final scheduleDateTime = schedule.time.toDate();
              final time = DateTime(day.year, day.month, day.day,
                  scheduleDateTime.hour, scheduleDateTime.minute);
              var actionRepeat = ActionRepeat(
                  cropId: crop.id,
                  time: Timestamp.fromDate(time),
                  action: schedule.action.irrigation == true
                      ? "Irrigation"
                      : "Fertigation",
                  canceled: false);
              var foundSkippedActions = skippedactionRepeats
                  .where((action) =>
                      action.action == actionRepeat.action &&
                      action.time == actionRepeat.time)
                  .toList();

              if (foundSkippedActions.length > 0) {
                actionRepeat.canceled = true;
                actionRepeat.id = foundSkippedActions.first.id;
                actionRepeats.add(actionRepeat);
              } else {
                actionRepeats.add(actionRepeat);
              }
            }
          } else if (dayOfTHeWeek == "Sunday") {
            if (schedule.repeat.sunday == true) {
              final scheduleDateTime = schedule.time.toDate();
              final time = DateTime(day.year, day.month, day.day,
                  scheduleDateTime.hour, scheduleDateTime.minute);
              var actionRepeat = ActionRepeat(
                  cropId: crop.id,
                  time: Timestamp.fromDate(time),
                  action: schedule.action.irrigation == true
                      ? "Irrigation"
                      : "Fertigation",
                  canceled: false);
              var foundSkippedActions = skippedactionRepeats
                  .where((action) =>
                      action.action == actionRepeat.action &&
                      action.time == actionRepeat.time)
                  .toList();

              if (foundSkippedActions.length > 0) {
                actionRepeat.canceled = true;
                actionRepeat.id = foundSkippedActions.first.id;
                actionRepeats.add(actionRepeat);
              } else {
                actionRepeats.add(actionRepeat);
              }
            }
          }
        });
      },
    );
    actionRepeats.sort((a, b) => a.time.toDate().compareTo(b.time.toDate()));
    return actionRepeats;
  }
}
