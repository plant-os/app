import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/recipe.dart';
import 'package:plantos/src/pages/add_crop/add_crop_bloc.dart';
import 'package:plantos/src/pages/edit_crop/edit_crop.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockCropsService extends Mock implements CropsService {}

class MockUserService extends Mock implements UserService {}

class MockUser extends Mock implements User {}

void main() {
  group("editCropBloc", () {
    final company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
        "address2", "state", "city", "country", "postcode", "name");

    final basil = Crop(
        name: "Basil",
        id: "0PMenXf6rWRuEt8EGm7w",
        company: company,
        cameras: [
          Camera(
            "Csv3NHDYZU92Oh9WaytO",
            "description",
            "0PMenXf6rWRuEt8EGm7w",
            Company("3S220zGg1GghXT075bcH", "registryId", "address1",
                "address2", "state", "city", "country", "postcode", "name"),
          )
        ],
        recipes: [
          Recipe("OeaXWL10wbrnUevDYavG", "deviceZone", "name", "registryId",
              company, Ec(1.5, 1.5, 1.5), Ph(7, 5, 6))
        ],
        ec: "1.5",
        startDate: Timestamp.fromDate(DateTime.parse("2021-01-14")),
        cropState: CropState(vegetative: true),
        schedules: [
          Schedule(
            Timestamp.fromDate(DateTime.parse("2021-01-14T14+00:00")),
            CropAction(true, false),
            Repeat(true, true, false, true, false, true, false),
          )
        ],
        selected: false);

    test("should allow saving if all fields are valid", () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      EditCropBloc editCropBloc =
          EditCropBloc(cropsService, authService, userService, null);

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
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: basil),
        ]),
      );
    });
  });
}
