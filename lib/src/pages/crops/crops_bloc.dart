import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/services/auth_service.dart';
import 'package:plantos/src/services/crops_service.dart';
import 'package:rxdart/rxdart.dart';

part 'crops_event.dart';
part 'crops_state.dart';

class CropsBloc extends Bloc<CropsEvent, CropsState> {
  final AuthService authService;
  final CropsService cropsService;
  final _username = BehaviorSubject<String>();
  final cropsList = BehaviorSubject<List<Crop>>();

  CropsBloc(this.authService, this.cropsService) {
    initialise();
  }

  @override
  CropsState get initialState => CropsState.initial();

  @override
  Stream<CropsState> mapEventToState(CropsEvent event) async* {
    // if (event is LoginTextFieldChangedEvent)
    //   yield* _mapTextFieldChangedToState(event);
    // else
    if (event is AddCropPressedEvent) yield* _mapAddCropPressedToState();
  }

  void initialise() async {
    authService.getCurrentUser().then(
          (value) => _username.add(value.displayName),
        );
    List<Crop> cropsList = await this.cropsService.getCropslist();
    this.cropsList.add(cropsList);
  }

  Stream<String> get username => _username.stream;

  // Stream<CropsState> _mapTextFieldChangedToState(
  //     LoginTextFieldChangedEvent event) async* {
  //   _email = event.email;
  //   _password = event.password;
  //   yield state.update(isValid: _isFormValidated());
  // }

  // bool _isFormValidated() {
  //   return EmailValidator.validate(_email) && _password.isNotEmpty;
  // }

  Stream<CropsState> _mapAddCropPressedToState() async* {
    yield state.update(isLoading: true);
    try {
      // await authService.login(_email, _password);
      yield state.update(isLoading: false, isSuccess: true);
    } catch (e) {
      print(e);
      yield state.update(isLoading: false, error: e.message);
      // yield CropsState.initial(isValid: _isFormValidated());
    }
  }

  void dispose() {
    cropsList.close();
  }
}
