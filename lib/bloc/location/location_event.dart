abstract class LocationEvent {}

class GetUserLocation extends LocationEvent {}

class FetchCities extends LocationEvent {}

class FilterCities extends LocationEvent {
  final String query;
  FilterCities(this.query);
}

