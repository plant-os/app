import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/add_schedule/add_schedule.dart';
import 'package:plantos/src/pages/edit_schedule/edit_schedule_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockCropsService extends Mock implements CropsService {}

class MockUserService extends Mock implements UserService {}

void main() {
  group("editScheduleBloc", () {
    test("Enables the edit schedule button if all the fields filled and valid",
        () {
      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      );

      EditScheduleBloc editScheduleBloc = EditScheduleBloc(schedule);
      editScheduleBloc.add(EditScheduleFieldChangedEvent(schedule: schedule));
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              schedule: schedule),
        ]),
      );
    });

    test("Does not enable the edit schedule button if the action is not set",
        () {
      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(false, false),
        Repeat(true, true, false, true, false, true, false),
      );
      EditScheduleBloc editScheduleBloc = EditScheduleBloc(schedule);
      editScheduleBloc.add(EditScheduleFieldChangedEvent(schedule: schedule));
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: schedule),
        ]),
      );
    });

    test(
        "Does not enable the edit schedule button if no repeat of the days is selected",
        () {
      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(false, false, false, false, false, false, false),
      );

      EditScheduleBloc editScheduleBloc = EditScheduleBloc(schedule);
      editScheduleBloc.add(EditScheduleFieldChangedEvent(schedule: schedule));
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: schedule),
        ]),
      );
    });

    test(
        "Does not enable the edit schedule button if the action and repeats are not set",
        () {
      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(false, false),
        Repeat(false, false, false, false, false, false, false),
      );
      EditScheduleBloc editScheduleBloc = EditScheduleBloc(schedule);
      editScheduleBloc.add(EditScheduleFieldChangedEvent(schedule: schedule));
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: schedule),
        ]),
      );
    });

    test(
        "Enables the edit schedule button after correcting the action which was not set",
        () {
      Schedule wrongSchedule = Schedule(
        Timestamp.now(),
        CropAction(false, false),
        Repeat(true, true, false, true, false, true, false),
      );

      Schedule correctedSchedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      );

      EditScheduleBloc editScheduleBloc = EditScheduleBloc(wrongSchedule);
      editScheduleBloc
          .add(EditScheduleFieldChangedEvent(schedule: wrongSchedule));
      editScheduleBloc
          .add(EditScheduleFieldChangedEvent(schedule: correctedSchedule));
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: wrongSchedule),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              schedule: correctedSchedule),
        ]),
      );
    });

    test(
        "Enables the edit schedule button after correcting the repeats which were all unselected",
        () {
      Schedule wrongSchedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(false, false, false, false, false, false, false),
      );

      Schedule correctedSchedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      );

      EditScheduleBloc editScheduleBloc = EditScheduleBloc(wrongSchedule);
      editScheduleBloc
          .add(EditScheduleFieldChangedEvent(schedule: wrongSchedule));
      editScheduleBloc
          .add(EditScheduleFieldChangedEvent(schedule: correctedSchedule));
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: wrongSchedule),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              schedule: correctedSchedule),
        ]),
      );
    });

    test(
        "Enables the edit schedule button after correcting action and repeats which both were unselected.",
        () {
      Schedule wrongSchedule = Schedule(
        Timestamp.now(),
        CropAction(false, false),
        Repeat(false, false, false, false, false, false, false),
      );

      Schedule correctedSchedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      );

      EditScheduleBloc editScheduleBloc = EditScheduleBloc(wrongSchedule);
      editScheduleBloc
          .add(EditScheduleFieldChangedEvent(schedule: wrongSchedule));
      editScheduleBloc
          .add(EditScheduleFieldChangedEvent(schedule: correctedSchedule));
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: wrongSchedule),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              schedule: correctedSchedule),
        ]),
      );
    });

    test(
        "Once edit schedule button is clicked will validate the fields and if valid sets the loading",
        () {
      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      );

      EditScheduleBloc editScheduleBloc = EditScheduleBloc(schedule);
      editScheduleBloc.add(EditScheduleFieldChangedEvent(schedule: schedule));
      editScheduleBloc.add(ClickSubmitEditScheduleEvent());
      expectLater(
        editScheduleBloc,
        emitsInOrder([
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              schedule: null),
          AddScheduleState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              schedule: schedule),
        ]),
      );
    });
  });
}
