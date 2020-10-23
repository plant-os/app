import 'package:cloud_firestore/cloud_firestore.dart';
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
  final Crop crop;

  CropDetailsBloc(
      this.cropsService, this.authService, this.userService, this.crop) {
    initialise();
  }

  @override
  CropDetailsState get initialState => ActionsLoading();

  @override
  Stream<CropDetailsState> mapEventToState(CropDetailsEvent event) async* {
    if (event is ActionsLoaded) {
      yield* _mapLoadActionsToState(event);
    } else if (event is ClickChangeActionStatusEvent) {
      yield* _mapActionStatusToState(event);
    }
  }

  void initialise() {
    generateActionRepeats().then(
      (value) {
        add(
          ActionsLoaded(value),
        );
      },
    );
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

  Stream<CropDetailsState> _mapLoadActionsToState(ActionsLoaded event) async* {
    yield CropDetailsStateDone(event.actionRepeats);
  }

  Future<List<ActionRepeat>> generateActionRepeats() async {
    final actionRepeats = <ActionRepeat>[];
    final skippedactionRepeats = await cropsService.skippedActions(crop.id);
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

  Stream<CropDetailsState> _mapActionStatusToState(
      ClickChangeActionStatusEvent event) async* {
    if (event.action.canceled == true) {
      try {
        await cropsService.deleteActionFromSkipped(event.action.id);
        final actionRepeats = await generateActionRepeats();
        yield CropDetailsStateDone(actionRepeats);
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await cropsService.addActionToSkipped(event.action);
        final actionRepeats = await generateActionRepeats();
        yield CropDetailsStateDone(actionRepeats);
      } catch (e) {
        print(e);
      }
    }
  }

  void dispose() {}
}
