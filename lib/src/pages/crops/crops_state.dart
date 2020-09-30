part of 'crops_bloc.dart';

class CropsState {
  final bool isValid;

  CropsState({this.isValid});

  factory CropsState.initial({bool isValid}) {
    return CropsState(isValid: isValid ?? false);
  }
}
