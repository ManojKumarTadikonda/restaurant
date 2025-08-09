import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as lc;
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepository {
  final String baseUrl = 'http://34.226.249.86:3000/api/customer';
  final lc.Location location = lc.Location();

  Future<bool> checkPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }

    lc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == lc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != lc.PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<lc.LocationData> getLocation() async {
    return await location.getLocation();
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final city = place.locality?.isNotEmpty == true
          ? place.locality
          : place.subAdministrativeArea?.isNotEmpty == true
          ? place.subAdministrativeArea
          : place.administrativeArea;
      return '$city';
    } else {
      return 'Unknown City';
    }
  }

  Future<bool> sendLocationToBackend({
    required double lat,
    required double lng,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesstoken') ?? ''; 

    if (token == null || token.isEmpty) {
      print("No token found in SharedPreferences");
      return false;
    }
    print("Token found: $token");
    print("Sending location: lat=$lat, lng=$lng, address=$address");
    final response = await http.post(
      Uri.parse('$baseUrl/location'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "token": token,
      },
      body: jsonEncode({
        "lat": lat,
        "lng": lng,
        "address": address,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print(
        "Error sending location: ${response.statusCode} - ${response.body}",
      );
      return false;
    }
  }
}
