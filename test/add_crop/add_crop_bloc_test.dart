import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/recipe.dart';
import 'package:plantos/src/pages/add_crop/add_crop_bloc.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockCropsService extends Mock implements CropsService {}

class MockUserService extends Mock implements UserService {}

class MockUser extends Mock implements User {}

void main() {
  group("addCropBloc", () {
    test("Enables the add crop button if all the fields filled and valid", () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop crop = Crop(
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(vegetative: true),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: crop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: crop),
        ]),
      );
    });

    test("Does not enable the add crop button if the name is empty", () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop crop = Crop(
          name: "",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(vegetative: true),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: crop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: crop),
        ]),
      );
    });

    test("Does not enable the add crop button if the ec is empty", () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop crop = Crop(
          name: "Test",
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
          fertigationCrop: true,
          ec: "",
          startDate: Timestamp.now(),
          cropState: CropState(vegetative: true),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: crop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: crop),
        ]),
      );
    });

    test("Does not enable the add crop button if the start date is empty", () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop crop = Crop(
          name: "Test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: null,
          cropState: CropState(vegetative: true),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: crop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: crop),
        ]),
      );
    });

    test("Does not enable the add crop button if there are no schedules", () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop crop = Crop(
          name: "Test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(vegetative: true),
          schedules: [],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: crop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: crop),
        ]),
      );
    });

    test("Does not enable the add crop button if the cropstate is not set", () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop crop = Crop(
          name: "Test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: false,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: crop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: crop),
        ]),
      );
    });

    test(
        "Enables the add crop button after correcting the name which was empty",
        () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop wrongCrop = Crop(
          name: "",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      Crop correctedCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: wrongCrop));
      addCropBloc.add(CropFieldChangedEvent(crop: correctedCrop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: wrongCrop),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: correctedCrop),
        ]),
      );
    });

    test("Enables the add crop button after correcting the ec which was empty",
        () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop wrongCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      Crop correctedCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: wrongCrop));
      addCropBloc.add(CropFieldChangedEvent(crop: correctedCrop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: wrongCrop),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: correctedCrop),
        ]),
      );
    });

    test(
        "Enables the add crop button after adding at least one schedule which was empty",
        () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop wrongCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [],
          selected: false);

      Crop correctedCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: wrongCrop));
      addCropBloc.add(CropFieldChangedEvent(crop: correctedCrop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: wrongCrop),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: correctedCrop),
        ]),
      );
    });

    test(
        "Enables the add crop button after setting a crop state after which it was not set",
        () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop wrongCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: false,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      Crop correctedCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: wrongCrop));
      addCropBloc.add(CropFieldChangedEvent(crop: correctedCrop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: wrongCrop),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: correctedCrop),
        ]),
      );
    });

    test(
        "Enables the add crop button after setting a start date which was not set",
        () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop wrongCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: null,
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      Crop correctedCrop = Crop(
          name: "test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(
              budding: false,
              vegetative: true,
              flowering: false,
              harvested: false,
              ripening: false),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);
      addCropBloc.add(CropFieldChangedEvent(crop: wrongCrop));
      addCropBloc.add(CropFieldChangedEvent(crop: correctedCrop));
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: wrongCrop),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: correctedCrop),
        ]),
      );
    });

    test(
        "Once add crop button is clicked will validate the fields and if valid sets the loading",
        () {
      MockAuthService authService = MockAuthService();
      MockCropsService cropsService = MockCropsService();
      MockUser currentUser = MockUser();
      MockUserService userService = MockUserService();

      var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
          "address2", "state", "city", "country", "postcode", "name");

      Crop crop = Crop(
          name: "Test",
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
          fertigationCrop: true,
          ec: "1.5",
          startDate: Timestamp.now(),
          cropState: CropState(vegetative: true),
          schedules: [
            Schedule(
              Timestamp.now(),
              CropAction(true, false),
              Repeat(true, true, false, true, false, true, false),
            )
          ],
          selected: false);

      AddCropBloc addCropBloc =
          AddCropBloc(cropsService, authService, userService);

      when(currentUser.email).thenReturn("baktash.29.ra@gmail.com");

      when(authService.getCurrentUser()).thenAnswer((_) async {
        return currentUser;
      });

      addCropBloc.add(CropFieldChangedEvent(crop: crop));
      addCropBloc.add(ClickSubmitAddCropEvent());
      expectLater(
        addCropBloc,
        emitsInOrder([
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: false,
              crop: null),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: false,
              isValid: true,
              crop: crop),
          AddCropState(
              error: "",
              isLoading: true,
              isSuccess: false,
              isValid: true,
              crop: crop),
          AddCropState(
              error: "",
              isLoading: false,
              isSuccess: true,
              isValid: true,
              crop: crop),
        ]),
      );
    });
  });
}
