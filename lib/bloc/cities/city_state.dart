import 'package:equatable/equatable.dart';
import 'package:restaurant/data/models/city_model.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final List<City> cities; 
  const CityLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class CityError extends CityState {
  final String error;
  const CityError(this.error);

  @override
  List<Object?> get props => [error];
}
