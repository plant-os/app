part of 'edit_crop_bloc.dart';

class EditCropState {
  final Crop crop;
  final String error;
  final bool isSuccess;
  final bool isValid;
  final bool isLoading;
  EditCropState(
      {@required this.crop,
      @required this.error,
      @required this.isSuccess,
      @required this.isLoading,
      @required this.isValid});

  factory EditCropState.initial(
      {Crop crop, String error, bool isSucess, bool isValid, bool isLoading}) {
    return EditCropState(
        crop: crop ?? null,
        error: error ?? "",
        isSuccess: isSucess ?? false,
        isLoading: isLoading ?? false,
        isValid: isValid ?? false);
  }

  EditCropState update(
      {bool isValid, bool isLoading, bool isSuccess, String error, Crop crop}) {
    return EditCropState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      crop: crop ?? this.crop,
    );
  }

  @override
  String toString() {
    return "EditCropState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, crop: $crop}";
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
