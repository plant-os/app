part of 'grows_bloc.dart';

abstract class GrowsEvent {}

class GrowsInitialFetchEvent extends GrowsEvent {}

class GrowsLoadedEvent extends GrowsEvent {}
