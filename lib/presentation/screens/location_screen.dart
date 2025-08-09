import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant/bloc/cities/city_bloc.dart';
import 'package:restaurant/bloc/cities/city_event.dart';
import 'package:restaurant/bloc/cities/city_state.dart';
import 'package:restaurant/bloc/location/location_bloc.dart';
import 'package:restaurant/bloc/location/location_event.dart';
import 'package:restaurant/bloc/location/location_state.dart';
import 'package:restaurant/data/repositories/location_repository.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _cityScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) async {
        if (state is LocationLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is LocationLoaded) {
          Navigator.pop(context);
          final locationRepo = LocationRepository();
          final success=await locationRepo.sendLocationToBackend(
            lat: state.latitude,
            lng: state.longitude,
            address: state.address,
          );
          if (success) {
            _showSuccessDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to send location")),
            );
          }
        } else if (state is LocationError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F9F2),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Find restaurants near you',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please enter your location or allow access\nto your location to find restaurants near you.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<LocationBloc>().add(
                                  GetUserLocation(),
                                );
                              },
                              icon: const Icon(
                                Icons.navigation,
                                color: Colors.white,
                              ),
                              label: const Text('Use current location'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Or',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              context.read<CityBloc>().add(SearchCities(value));
                            },
                            decoration: InputDecoration(
                              hintText: 'Search location',
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height *
                                0.5, 
                            child: Scrollbar(
                              controller: _cityScrollController,
                              thumbVisibility: true,
                              child: BlocBuilder<CityBloc, CityState>(
                                builder: (context, state) {
                                  if (state is CityLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is CityLoaded) {
                                    if (state.cities.isEmpty) {
                                      return const Center(
                                        child: Text('No cities found'),
                                      );
                                    }
                                    return ListView.builder(
                                      controller: _cityScrollController,
                                      itemCount: state.cities.length,
                                      itemBuilder: (context, index) {
                                        final city = state.cities[index];
                                        return ListTile(
                                          leading: const Icon(
                                            Icons.navigation,
                                            color: Colors.green,
                                          ),
                                          title: Text(
                                            city.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          subtitle: Text(
                                            city.region ?? '',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          onTap: () async {
                                            _searchController.text = city.name;

                                            final locationRepo =
                                                LocationRepository();

                                            try {
                                              
                                              final success = await locationRepo
                                                  .sendLocationToBackend(
                                                    lat: city.lat,
                                                    lng: city.lng,
                                                    address: city.name,
                                                  );

                                              if (success) {
                                                _searchController.clear();
                                                context.read<CityBloc>().add(
                                                  LoadCities(),
                                                );
                                                _showSuccessDialog();
                                              } else {
                                                _searchController.clear();
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Failed to send location",
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Error: ${e.toString()}",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    );
                                  } else if (state is CityError) {
                                    return Center(child: Text(state.error));
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Success", style: TextStyle(color: Colors.green)),
        content: const Text("Location sent successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
