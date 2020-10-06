import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/user.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:plantos/src/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

part 'crops_event.dart';
part 'crops_state.dart';

class CropsBloc extends Bloc<CropsEvent, CropsState> {
  StreamSubscription _ongoingCropsSubscription;
  StreamSubscription _pastCropsSubscription;
  final AuthService authService;
  final UserService userService;
  final CropsService cropsService;
  final _username = BehaviorSubject<String>.seeded("User");
  final _currentUser = BehaviorSubject<UserModel>();
  final cropsListOngoing = BehaviorSubject<List<Crop>>.seeded([]);
  final cropsListPast = BehaviorSubject<List<Crop>>.seeded([]);

  CropsBloc(this.authService, this.cropsService, this.userService) {
    initialise();
  }

  @override
  CropsState get initialState => CropsState.initial();

  @override
  Stream<CropsState> mapEventToState(CropsEvent event) async* {
    if (event is LoadOngoingCrops) {
      yield* _mapLoadOngoingCropsToState();
    } else if (event is LoadPastCrops) {
      yield* _mapLoadPastCropsToState();
    } else if (event is AddCrop) {
      yield* _mapAddCropToState(event);
    } else if (event is UpdateCrop) {
      yield* _mapUpdateCropToState(event);
    } else if (event is DeleteCrop) {
      yield* _mapDeleteCropToState(event);
    } else if (event is OngoingCropsUpdated) {
      // yield* _mapOngoingCropsUpdateToState(event);
    } else if (event is PastCropsUpdated) {
      yield* _mapPastCropsUpdateToState(event);
    }
  }

  void initialise() async {
    authService.getCurrentUser().then((value) async {
      var currentUser = await userService.getCurrentUserDetails(value.email);
      _currentUser.add(currentUser);
      _username.add(currentUser.name);
      // List<Crop> cropsListOngoing =
      //     await this.cropsService.getCropslistOngoing(currentUser.company.id);
      // this.cropsListOngoing.add(cropsListOngoing);
      // List<Crop> cropsListPast =
      //     await this.cropsService.getCropslistPast(currentUser.company.id);
      // this.cropsListPast.add(cropsListPast);
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

  Stream<String> get username => _username.stream;

  // Stream<CropsState> _mapAddCropPressedToState() async* {
  //   yield state.update(isLoading: true);
  //   try {
  //     // await authService.login(_email, _password);
  //     yield state.update(isLoading: false, isSuccess: true);
  //   } catch (e) {
  //     print(e);
  //     yield state.update(isLoading: false, error: e.message);
  //     // yield CropsState.initial(isValid: _isFormValidated());
  //   }
  // }

  void dispose() {
    cropsListOngoing.close();
    cropsListPast.close();
  }

  _mapLoadOngoingCropsToState() {
    _ongoingCropsSubscription?.cancel();
    _ongoingCropsSubscription =
        cropsService.getCropslistOngoing(_currentUser.value.company.id).listen(
              (crops) => add(OngoingCropsUpdated(crops)),
            );
  }

  _mapLoadPastCropsToState() {
    _pastCropsSubscription?.cancel();
    _pastCropsSubscription =
        cropsService.getCropslistPast(_currentUser.value.company.id).listen(
              (crops) => add(OngoingCropsUpdated(crops)),
            );
  }

  _mapAddCropToState(AddCrop event) {}

  _mapUpdateCropToState(UpdateCrop event) {}

  _mapDeleteCropToState(DeleteCrop event) {}

  // _mapOngoingCropsUpdateToState(OngoingCropsUpdated event) async* {
  //   yield CropsLoaded(event.crops);
  // }

  _mapPastCropsUpdateToState(PastCropsUpdated event) {}
}
