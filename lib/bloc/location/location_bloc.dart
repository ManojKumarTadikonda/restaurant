import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepo;

  LocationBloc(this.locationRepo) : super(LocationInitial()) {
    on<GetUserLocation>((event, emit) async {
      emit(LocationLoading());

      try {
        final granted = await locationRepo.checkPermission();
        if (!granted) {
          emit(LocationError("Permission not granted"));
          return;
        }

        final locationData = await locationRepo.getLocation();
        final address = await locationRepo.getAddressFromLatLng(
          locationData.latitude!,
          locationData.longitude!,
        );

        emit(LocationLoaded(
          locationData.latitude!,
          locationData.longitude!,
          address,
        ));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });
  }
  
}
