import 'package:flutter_bloc/flutter_bloc.dart';
import 'city_event.dart';
import 'city_state.dart';
import 'package:restaurant/data/repositories/cities_location_repository.dart';
import 'package:restaurant/data/models/city_model.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository cityRepository;
  List<City> allCities = [];

  CityBloc(this.cityRepository) : super(CityInitial()) {
    on<LoadCities>(_onLoadCities);
    on<SearchCities>(_onSearchCities);
    on<ClearCities>((event, emit) {
      emit(CityLoaded([]));
    });
  }

  Future<void> _onLoadCities(LoadCities event, Emitter<CityState> emit) async {
    emit(CityLoading());
    try {
      allCities = await cityRepository.fetchCities();
      emit(CityLoaded(allCities));
    } catch (e) {
      emit(CityError(e.toString()));
    }
  }

  Future<void> _onSearchCities(
    SearchCities event,
    Emitter<CityState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(CityLoaded(allCities));
      return;
    }

    final filtered = allCities
        .where(
          (city) => city.name.toLowerCase().contains(event.query.toLowerCase()),
        )
        .toList();

    if (filtered.isNotEmpty) {
      emit(CityLoaded(filtered));
    } else {
      emit(CityLoading());
      try {
        final results = await cityRepository.fetchCities(query: event.query);
        emit(CityLoaded(results));
      } catch (e) {
        emit(CityError(e.toString()));
      }
    }
  }
}
