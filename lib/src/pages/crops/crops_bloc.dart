import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantos/src/services/crops_service.dart';

part 'crops_state.dart';
part 'crops_event.dart';

class CropsBloc extends Bloc<CropsBloc, CropsState> {
  final CropsService cropsService = CropsService();
  CropsBloc() {
    initialise();
  }

  void initialise() {
    this.cropsService.getCropslist();
    this.cropsService.addCrop();
  }

  CropsState get initialState => CropsState.initial();

  @override
  Stream<CropsState> mapEventToState(CropsBloc event) {
    throw UnimplementedError();
  }
}
