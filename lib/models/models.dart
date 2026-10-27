class User {
  final String name;
  final String email;
  final String phone;
  final List<String> emergencyContacts;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.emergencyContacts,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'emergencyContacts': emergencyContacts,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      emergencyContacts: List<String>.from(map['emergencyContacts'] ?? []),
    );
  }
}

class WeatherData {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double rainfall;
  final String location;
  final int weatherCode;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainfall,
    required this.location,
    required this.weatherCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, String location) {
    return WeatherData(
      temperature: json['current']['temperature_2m']?.toDouble() ?? 0.0,
      humidity: json['current']['relative_humidity_2m']?.toDouble() ?? 0.0,
      windSpeed: json['current']['windspeed_10m']?.toDouble() ?? 0.0,
      rainfall: json['current']['rain']?.toDouble() ?? 0.0,
      location: location,
      weatherCode: json['current']['weather_code']?.toInt() ?? 0,
    );
  }
}

class LocationData {
  final String name;
  final double latitude;
  final double longitude;
  final String country;

  LocationData({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      name: json['name'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      country: json['country'] ?? '',
    );
  }
}

class FloodPredictionResult {
  final String riskLevel;
  final double confidence;
  final Map<String, double> features;

  FloodPredictionResult({
    required this.riskLevel,
    required this.confidence,
    required this.features,
  });
}