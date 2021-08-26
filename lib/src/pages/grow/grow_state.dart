part of 'grow_bloc.dart';

class GrowState {
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isFetched;
  final String error;
  final Grow grow;

  // The programs to populate in the drop-down list.
  final List<Program> programs;

  // The devices to populate in the drop-down list.
  final List<Device> devices;

  GrowState({
    required this.isValid,
    required this.isLoading,
    required this.isSuccess,
    required this.isFetched,
    required this.error,
    required this.grow,
    required this.programs,
    required this.devices,
  });

  factory GrowState.initial({
    Grow? grow,
  }) {
    return GrowState(
      isValid: true,
      isLoading: false,
      isSuccess: false,
      isFetched: false,
      error: '',
      grow: grow ?? Grow.initial(),
      programs: [],
      devices: [],
    );
  }

  GrowState update({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isFetched,
    String? error,
    Grow? grow,
    List<Program>? programs,
    List<Device>? devices,
  }) {
    return GrowState(
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFetched: isFetched ?? this.isFetched,
      error: error ?? this.error,
      grow: grow ?? this.grow,
      programs: programs ?? this.programs,
      devices: devices ?? this.devices,
    );
  }

  @override
  String toString() =>
      "GrowState{isValid: $isValid, isSuccess: $isSuccess, isLoading: $isLoading, isFetched: $isFetched, error: $error, grow: $grow, programs: $programs, devices: $devices}";

  @override
  bool operator ==(dynamic o) =>
      o is GrowState &&
      o.isValid == isValid &&
      o.isSuccess == isSuccess &&
      o.isLoading == isLoading &&
      o.isFetched == isFetched &&
      o.error == error &&
      o.grow == grow &&
      listEquals(o.programs, programs) &&
      listEquals(o.devices, devices);

  @override
  int get hashCode => hashValues(isValid, isSuccess, isLoading, isFetched,
      error, grow, hashList(programs), hashList(devices));
}
