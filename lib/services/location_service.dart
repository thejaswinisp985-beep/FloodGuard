import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/models.dart';

class LocationService {
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<List<LocationData>> searchLocations(String query) async {
    if (query.isEmpty) return [];

    try {
      final url = '$_geocodingBaseUrl?name=$query&count=10&language=en&format=json';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] ?? [];

        return results.map<LocationData>((result) {
          return LocationData.fromJson(result);
        }).toList();
      }
    } catch (e) {
      print('Error searching locations: $e');
    }

    return [];
  }

  static String getLocationDisplayName(LocationData location) {
    if (location.country.isNotEmpty) {
      return '${location.name}, ${location.country}';
    }
    return location.name;
  }
}