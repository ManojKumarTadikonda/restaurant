abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;
  final String address;

  LocationLoaded(this.latitude, this.longitude, this.address);
}

class LocationError extends LocationState {
  final String error;
  LocationError(this.error);
}

