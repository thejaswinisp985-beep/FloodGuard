import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App Constants
class AppConstants {
  static const String appName = 'FloodGuard';
  static const String appTitle = 'FloodGuard';

  // Colors
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color lightBackground = Color(0xFFE3F2FD);
  static const Color darkBackgroundStart = Color(0xFF0D47A1);
  static const Color darkBackgroundEnd = Color(0xFF1565C0);

  // API Keys and URLs
  static const String openMeteoBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  // Email Configuration
  static const String smtpHost = 'smtp.gmail.com';
  static const int smtpPort = 587;
  static const String emailUsername = 'your-email@gmail.com';
  static const String emailPassword = 'your-app-password';

  // Emergency Numbers
  static const Map<String, String> emergencyNumbers = {
    'Police': '100',
    'Fire Department': '101',
    'Ambulance': '102',
    'Disaster Management': '108',
    'National Helpline': '112',
  };

  // Feature Names for Flood Prediction
  static const List<String> featureNames = [
    'Rainfall (mm)',
    'River Level (m)',
    'Dam Water Level (%)',
    'Soil Moisture (%)',
    'Humidity (%)',
    'Wind Speed (kmph)',
    'Above Sea Level (m)',
    'Drainage Capacity (%)',
    'Population Density'
  ];

  // Feature Descriptions
  static const List<String> featureDescriptions = [
    'Enter rainfall in mm to assess water accumulation risk.',
    'Enter river level in meters for flood potential.',
    'Enter dam water level percentage for overflow risk.',
    'Enter soil moisture percentage for saturation level.',
    'Enter humidity percentage affecting evaporation.',
    'Enter wind speed in kmph for storm intensity.',
    'Enter elevation in meters above sea level.',
    'Enter drainage capacity percentage for water flow.',
    'Enter population density for vulnerability assessment.'
  ];

  // Labels for Prediction
  static const List<String> predictionLabels = ['High', 'Low', 'Medium'];
}

// Theme Extensions
extension ThemeDataExtensions on ThemeData {
  Color get surfaceWithOpacity => colorScheme.surface.withOpacity(0.8);
  Color get onSurfaceColor => colorScheme.onSurface;
}

// Text Styles
class AppTextStyles {
  static TextStyle heading1(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle heading2(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle heading3(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle body(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle caption(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: 14,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
    );
  }
}