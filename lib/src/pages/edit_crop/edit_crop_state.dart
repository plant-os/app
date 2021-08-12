part of 'edit_crop_bloc.dart';

class EditCropState {
  final Crop crop;
  final String error;
  final bool isSuccess;
  final bool isValid;
  final bool isLoading;

  final List<Device>? devices;

  EditCropState({
    @required required this.crop,
    this.error = "",
    this.isSuccess = false,
    this.isLoading = false,
    this.isValid = false,
    @required this.devices,
  });

  factory EditCropState.initial({
    Crop? crop,
    String? error,
    bool? isSucess,
    bool? isValid,
    bool? isLoading,
    List<Device>? devices,
  }) {
    return EditCropState(
        crop: crop ?? Crop(cropState: CropState.of("Vegetative")),
        error: error ?? "",
        isSuccess: isSucess ?? false,
        isLoading: isLoading ?? false,
        isValid: isValid ?? false,
        devices: devices);
  }

  EditCropState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    Crop? crop,
    List<Device>? devices,
  }) {
    return EditCropState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      crop: crop ?? this.crop,
      devices: devices ?? this.devices,
    );
  }

  @override
  String toString() {
    return "EditCropState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, error: $error, crop: $crop}";
  }

  // ignore: hash_and_equals
  bool operator ==(dynamic o) =>
      o is EditCropState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.error == error &&
      o.crop == crop;
}
