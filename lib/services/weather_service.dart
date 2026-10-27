import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static Future<WeatherData?> fetchWeather(double latitude, double longitude, String location) async {
    try {
      final url = '$_baseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,windspeed_10m,rain,weather_code&timezone=auto';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data, location);
      }
    } catch (e) {
      print('Error fetching weather: $e');
    }
    return null;
  }

  static String getWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0: return 'Clear sky';
      case 1: return 'Mainly clear';
      case 2: return 'Partly cloudy';
      case 3: return 'Overcast';
      case 45: return 'Fog';
      case 48: return 'Depositing rime fog';
      case 51: return 'Light drizzle';
      case 53: return 'Moderate drizzle';
      case 55: return 'Dense drizzle';
      case 56: return 'Light freezing drizzle';
      case 57: return 'Dense freezing drizzle';
      case 61: return 'Slight rain';
      case 63: return 'Moderate rain';
      case 65: return 'Heavy rain';
      case 66: return 'Light freezing rain';
      case 67: return 'Heavy freezing rain';
      case 71: return 'Slight snow fall';
      case 73: return 'Moderate snow fall';
      case 75: return 'Heavy snow fall';
      case 77: return 'Snow grains';
      case 80: return 'Slight rain showers';
      case 81: return 'Moderate rain showers';
      case 82: return 'Violent rain showers';
      case 85: return 'Slight snow showers';
      case 86: return 'Heavy snow showers';
      case 95: return 'Thunderstorm';
      case 96: return 'Thunderstorm with slight hail';
      case 99: return 'Thunderstorm with heavy hail';
      default: return 'Unknown';
    }
  }

  static String getWeatherIcon(int weatherCode) {
    if (weatherCode == 0) return '01d';
    if ([1, 2].contains(weatherCode)) return '02d';
    if (weatherCode == 3) return '03d';
    if ([45, 48].contains(weatherCode)) return '50d';
    if ([51, 53, 55, 56, 57].contains(weatherCode)) return '09d';
    if ([61, 63, 65, 66, 67, 80, 81, 82].contains(weatherCode)) return '10d';
    if ([71, 73, 75, 77, 85, 86].contains(weatherCode)) return '13d';
    if ([95, 96, 99].contains(weatherCode)) return '11d';
    return '01d';
  }
}