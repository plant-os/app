part of 'crop_details_bloc.dart';

class CropDetailsState {
  final String error;
  final bool isLoading;
  CropDetailsState({
    @required this.error,
    @required this.isLoading,
  });

  factory CropDetailsState.initial(
      {Crop crop, String error, bool isSucess, bool isValid, bool isLoading}) {
    return CropDetailsState(
      error: error ?? "",
      isLoading: isLoading ?? false,
    );
  }

  CropDetailsState update(
      {bool isValid, bool isLoading, bool isSuccess, String error, Crop crop}) {
    return CropDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return "AddCropState{isLoading: $isLoading, error: $error}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic other) {
    return other.isLoading == isLoading && other.error == error;
  }
}
