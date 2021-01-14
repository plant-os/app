// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:plantos/src/models/camera.dart';
// import 'package:plantos/src/models/company.dart';
// import 'package:plantos/src/models/crop.dart';
// import 'package:plantos/src/models/recipe.dart';
// import 'package:plantos/src/models/user.dart';
// import 'package:plantos/src/pages/crops/crops.dart';
// import 'package:plantos/src/services/auth_service.dart';
// import 'package:plantos/src/services/crops_service.dart';
// import 'package:plantos/src/services/user_service.dart';

// class MockAuthService extends Mock implements AuthService {}

// class MockUserService extends Mock implements UserService {}

// class MockCropsService extends Mock implements CropsService {}

// class MockUser extends Mock implements User {}

// void main() {
//   group(
//     "cropsBloc",
//     () {
//       test("Once redirected to the crops page loads all the crops", () {
//         MockAuthService authService = MockAuthService();
//         MockUserService userService = MockUserService();
//         MockCropsService cropsService = MockCropsService();
//         MockUser currentUser = MockUser();
//         var currentTime = Timestamp.now();

//         var company = Company("3S220zGg1GghXT075bcH", "registryId", "address1",
//             "address2", "state", "city", "country", "postcode", "name");

//         var user = UserModel(
//             "QbFtM7edkrquUqBwsgtb",
//             "Taha",
//             company,
//             Dashboard(true, false, false),
//             "baktash.29.ra@gmail.com",
//             Role(true, false, false));

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
//                 Repeat(true, true, false, true, false, true, false),
//               )
//             ],
//             selected: false);
//         var crops = [crop];
//         when(currentUser.email).thenReturn("baktash.29.ra@gmail.com");

//         when(authService.getCurrentUser()).thenAnswer((_) async {
//           return currentUser;
//         });

//         when(userService.getCurrentUserDetails("baktash.29.ra@gmail.com"))
//             .thenAnswer((_) async {
//           return user;
//         });

//         Stream<List<Crop>> cropListStream = Stream.fromIterable([crops]);

//         when(cropsService.getCropslist(company.id))
//             .thenAnswer((_) => cropListStream);
//         CropsBloc cropsBloc = CropsBloc(authService, cropsService, userService);

//         expectLater(
//           cropsBloc,
//           emitsInOrder(
//             [CropStateLoading(), CropsStateDone([], crops, user)],
//           ),
//         );
//       });
//     },
//   );
// }
