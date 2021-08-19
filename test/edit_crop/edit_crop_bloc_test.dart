import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/pages/edit_crop/edit_crop_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/device_service.dart';
import 'package:plantos/src/services/user_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockCropsService extends Mock implements CropsService {}

class MockUserService extends Mock implements UserService {}

class MockDeviceService extends Mock implements DeviceService {}

class MockUser extends Mock implements User {}

void main() {
  group("editCropBloc", () {
    final basil = Crop(
        name: "Basil",
        ec: "1.5",
        startDate: Timestamp.fromDate(DateTime.parse("2021-01-14")),
        cropState: CropState.of("Vegetative"),
        schedules: [
          Schedule(
            Timestamp.fromDate(DateTime.parse("2021-01-14T14+00:00")),
            CropAction(true, false),
            Repeat(true, true, false, true, false, true, false),
          )
        ]);

    test("should allow saving if all fields are valid", () async {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();
      MockDeviceService deviceService = MockDeviceService();

      EditCropBloc editCropBloc = EditCropBloc(null);

      editCropBloc.add(SetStartDateEvent(DateTime.parse("2021-01-14")));
      editCropBloc.add(ChangeNameEvent("Basil"));
      editCropBloc.add(ChangeEcEvent("1.5"));
      editCropBloc.add(AddScheduleEvent(Schedule(
        Timestamp.fromDate(DateTime.parse("2021-01-14T14+00:00")),
        CropAction(true, false),
        Repeat(true, true, false, true, false, true, false),
      )));

      expectLater(
        editCropBloc,
        emitsThrough(
          EditCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: basil,
              devices: []),
        ),
      );
    });
  });
}
