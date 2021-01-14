// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:plantos/src/models/camera.dart';
// import 'package:plantos/src/models/company.dart';
// import 'package:plantos/src/models/crop.dart';
// import 'package:plantos/src/models/recipe.dart';
// import 'package:plantos/src/services/auth_service.dart';
// import 'package:plantos/src/services/crops_service.dart';
// import 'package:plantos/src/services/user_service.dart';

// class MockAuthService extends Mock implements AuthService {}

// class MockUserService extends Mock implements UserService {}

// class MockCropsService extends Mock implements CropsService {}

// void main() {
//   group(
//     "cropDetailsBloc",
//     () {
//       test("Once redirected to the crop details page loads all the actions",
//           () async {
//         MockAuthService authService = MockAuthService();
//         MockUserService userService = MockUserService();
//         MockCropsService cropsService = MockCropsService();
//         var currentTime = Timestamp.now();

//         var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
//             "address2", "state", "city", "country", "postcode", "name");

//         var crop = Crop(
//             name: "Basil",
//             id: "0PMenXf6rWRuEt8EGm7w",
//             company: company,
//             cameras: [
//               Camera(
//                 "Csv3NHDYZU92Oh9WaytO",
//                 "description",
//                 "0PMenXf6rWRuEt8EGm7w",
//                 Company("3S220zGg1GghXT075bcH", "registryId", "address1",
//                     "address2", "state", "city", "country", "postcode", "name"),
//               )
//             ],
//             recipes: [
//               Recipe("OeaXWL10wbrnUevDYavG", "deviceZone", "name", "registryId",
//                   company, Ec(1.5, 1.5, 1.5), Ph(7, 5, 6))
//             ],
//             fertigationCrop: true,
//             ec: "1.5",
//             startDate: currentTime,
//             cropState: CropState(harvested: true),
//             schedules: [
//               Schedule(
//                 currentTime,
//                 CropAction(true, false),
//                 Repeat(false, false, false, true, false, true, false),
//               )
//             ],
//             selected: false);

//         var actionRepeat = ActionRepeat(
//             id: "aaa",
//             cropId: "bbb",
//             time: Timestamp.now(),
//             action: "Fertigation",
//             canceled: false);

//         var actionRepeats = [actionRepeat];

//         when(cropsService.skippedActions("0PMenXf6rWRuEt8EGm7w"))
//             .thenAnswer((_) async {
//           return actionRepeats;
//         });

//         CropDetailsBloc cropDetailsBloc =
//             CropDetailsBloc(cropsService, authService, userService, crop);

//         when(cropDetailsBloc.generateActionRepeats()).thenAnswer((_) async {
//           return actionRepeats;
//         });

//         // var generatedActionRepeats =
//         //     await cropDetailsBloc.generateActionRepeats();

//         expectLater(
//           cropDetailsBloc,
//           emitsInOrder(
//             [ActionsLoading(), CropDetailsStateDone(actionRepeats)],
//           ),
//         );
//       });
//     },
//   );
// }
