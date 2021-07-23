import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/add_schedule/add_schedule.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockCropsService extends Mock implements CropsService {}

class MockUserService extends Mock implements UserService {}

void main() {
  group("addScheduleBloc", () {
    test("Enables the add schedule button if all the fields filled and valid",
        () {
      MockCropsService cropsService = MockCropsService();

      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      );

      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(schedule));
      expectLater(
        addScheduleBloc,
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

    test("Does not enable the add schedule button if the action is not set",
        () {
      MockCropsService cropsService = MockCropsService();

      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(false, false),
        Repeat(true, true, false, true, false, true, false),
      );
      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(schedule));
      expectLater(
        addScheduleBloc,
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
        "Does not enable the add schedule button if no repeat of the days is selected",
        () {
      MockCropsService cropsService = MockCropsService();

      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(false, false, false, false, false, false, false),
      );

      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(schedule));
      expectLater(
        addScheduleBloc,
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
        "Does not enable the add schedule button if the action and repeats are not set",
        () {
      MockCropsService cropsService = MockCropsService();

      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(false, false),
        Repeat(false, false, false, false, false, false, false),
      );
      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(schedule));
      expectLater(
        addScheduleBloc,
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
        "Enables the add schedule button after correcting the action which was not set",
        () {
      MockCropsService cropsService = MockCropsService();

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

      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(wrongSchedule));
      addScheduleBloc.add(ScheduleFieldChangedEvent(correctedSchedule));
      expectLater(
        addScheduleBloc,
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
        "Enables the add schedule button after correcting the repeats which were all unselected",
        () {
      MockCropsService cropsService = MockCropsService();

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

      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(wrongSchedule));
      addScheduleBloc.add(ScheduleFieldChangedEvent(correctedSchedule));
      expectLater(
        addScheduleBloc,
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
        "Enables the add schedule button after correcting action and repeats which both were unselected.",
        () {
      MockCropsService cropsService = MockCropsService();

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

      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(wrongSchedule));
      addScheduleBloc.add(ScheduleFieldChangedEvent(correctedSchedule));
      expectLater(
        addScheduleBloc,
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
        "Once add schedule button is clicked will validate the fields and if valid sets the loading",
        () {
      MockCropsService cropsService = MockCropsService();

      Schedule schedule = Schedule(
        Timestamp.now(),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      );

      AddScheduleBloc addScheduleBloc = AddScheduleBloc(cropsService);
      addScheduleBloc.add(ScheduleFieldChangedEvent(schedule));
      addScheduleBloc.add(ClickSubmitAddScheduleEvent());
      expectLater(
        addScheduleBloc,
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
