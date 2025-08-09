import 'package:equatable/equatable.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object?> get props => [];
}

class LoadCities extends CityEvent {}
class ClearCities extends CityEvent {}
class SearchCities extends CityEvent {
  final String query;
  const SearchCities(this.query);

  @override
  List<Object?> get props => [query];
}
