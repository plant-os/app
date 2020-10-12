part of 'add_crop_bloc.dart';

class AddCropState {
  final Crop crop;
  final String error;
  final bool isSuccess;
  final bool isValid;
  final bool isLoading;
  AddCropState(
      {@required this.crop,
      @required this.error,
      @required this.isSuccess,
      @required this.isLoading,
      @required this.isValid});

  factory AddCropState.initial(
      {Crop crop, String error, bool isSucess, bool isValid, bool isLoading}) {
    return AddCropState(
        crop: crop ?? null,
        error: error ?? "",
        isSuccess: isSucess ?? false,
        isLoading: isLoading ?? false,
        isValid: isValid ?? false);
  }

  AddCropState update(
      {bool isValid, bool isLoading, bool isSuccess, String error, Crop crop}) {
    return AddCropState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      crop: crop ?? this.crop,
    );
  }

  @override
  String toString() {
    return "AddCropState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, crop: $crop}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic other) {
    return other.isValid == isValid &&
        other.isSuccess == isSuccess &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.crop == crop;
  }
}
