// city_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/models/city_model.dart';

class CityRepository {
  final String username = "manoj38519";

  Future<List<City>> fetchCities({String? query}) async {
    final url = query == null || query.isEmpty
        ? "http://api.geonames.org/searchJSON?country=IN&featureClass=P&maxRows=1000&username=$username"
        : "http://api.geonames.org/searchJSON?name=$query&country=IN&featureClass=P&maxRows=10&username=$username";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> geonames = data["geonames"] ?? [];

      return geonames.map((e) {
        return City(
          name: e["name"] ?? "",
          region: e["adminName1"], 
          lat: double.parse(e["lat"].toString()), 
          lng: double.parse(e["lng"].toString()),
        );
      }).toList();
    } else {
      throw Exception("Failed to load cities");
    }
  }
}
