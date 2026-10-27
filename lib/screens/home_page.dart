import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/auth_provider.dart';
import '../widgets/action_card.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../models/models.dart';
import 'flood_prediction_page.dart';
import 'emergency_contacts_page.dart';
import 'emergency_support_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _weatherData;
  Position? _currentPosition;
  String _currentCity = 'Loading...';
  bool _isSearching = false;
  List<LocationData> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _currentCity = '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      });
      _fetchWeatherForLocation(position.latitude, position.longitude, _currentCity);
    } else {
      setState(() {
        _currentCity = 'Location permission denied';
      });
      _fetchWeatherForLocation(51.5074, -0.1278, 'London'); // Default to London
    }
  }

  Future<void> _fetchWeatherForLocation(double latitude, double longitude, String cityName) async {
    final weatherData = await WeatherService.fetchWeather(latitude, longitude, cityName);
    if (weatherData != null) {
      setState(() {
        _weatherData = {
          'main': {'temp': weatherData.temperature, 'humidity': weatherData.humidity},
          'weather': [{
            'description': WeatherService.getWeatherDescription(weatherData.weatherCode),
            'icon': WeatherService.getWeatherIcon(weatherData.weatherCode)
          }],
          'wind': {'speed': weatherData.windSpeed},
          'rain': {'amount': weatherData.rainfall},
          'name': cityName,
          'weatherCode': weatherData.weatherCode
        };
      });
    }
  }

  void _searchLocations(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = await LocationService.searchLocations(query);
    setState(() {
      _searchResults = results;
    });
  }

  void _selectLocation(LocationData location) {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults = [];
      _currentCity = location.name;
    });
    _fetchWeatherForLocation(location.latitude, location.longitude, location.name);
  }

  Widget _buildWeatherCard() {
    if (_weatherData == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [const Color(0xFF1E3A5F), const Color(0xFF0D47A1)]
                : [Colors.white, const Color(0xFFE3F2FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            if (_isSearching)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search location...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                          _searchResults = [];
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: _searchLocations,
                ),
              ),

            // Search results
            if (_searchResults.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final location = _searchResults[index];
                    return ListTile(
                      title: Text(
                        location.name,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      subtitle: Text(
                        location.country,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                      ),
                      onTap: () => _selectLocation(location),
                    );
                  },
                ),
              ),

            // Weather header with location and search button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _currentCity,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                          if (!_isSearching) {
                            _searchController.clear();
                            _searchResults = [];
                          }
                        });
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weather content
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Temperature and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${_weatherData!['main']['temp']}°C',
                            style: GoogleFonts.roboto(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildWeatherIcon(_weatherData!['weather'][0]['icon']),
                        ],
                      ),
                      Text(
                        _weatherData!['weather'][0]['description'],
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Weather details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Humidity: ${_weatherData!['main']['humidity']}%',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      'Wind: ${_weatherData!['wind']['speed']} m/s',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    if (_weatherData!['rain'] != null && _weatherData!['rain']['amount'] > 0)
                      Text(
                        'Rain: ${_weatherData!['rain']['amount']} mm',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(String iconCode) {
    // Map weather icon codes to Material Icons
    IconData getIconForWeather(String code) {
      switch (code) {
        case '01d': return Icons.wb_sunny; // Clear sky
        case '02d': return Icons.wb_cloudy; // Few clouds
        case '03d': return Icons.cloud; // Scattered clouds
        case '04d': return Icons.cloud; // Broken clouds
        case '09d': return Icons.grain; // Shower rain
        case '10d': return Icons.beach_access; // Rain
        case '11d': return Icons.flash_on; // Thunderstorm
        case '13d': return Icons.ac_unit; // Snow
        case '50d': return Icons.blur_on; // Mist
        default: return Icons.wb_sunny;
      }
    }

    return Icon(
      getIconForWeather(iconCode),
      size: 40,
      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.orange,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.brightness == Brightness.dark
                ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
                : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Beautiful App Title Header
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme.brightness == Brightness.dark
                          ? [const Color(0xFF1565C0), const Color(0xFF42A5F5)]
                          : [const Color(0xFF1976D2), const Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FloodGuard',
                              style: GoogleFonts.roboto(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Your Flood Protection Companion',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.waves,
                        color: Colors.white.withOpacity(0.8),
                        size: 24,
                      ),
                    ],
                  ),
                ),

                Text(
                  'Welcome back, ${authProvider.userData['name']}!',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stay informed and prepared',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                // Weather Section
                _buildWeatherCard(),
                const SizedBox(height: 24),
                // Action Cards
                Text(
                  'Quick Actions',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    ActionCard(
                      title: 'Predict Flood Risk',
                      description: 'Analyze current weather conditions and predict flood risks in your area using AI-powered models',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FloodPredictionPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      title: 'Emergency Contacts',
                      description: 'Manage your emergency contact list for flood alerts and notifications',
                      icon: Icons.contacts,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EmergencyContactsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      title: 'Emergency Support',
                      description: 'Quick access to emergency services and helpline numbers',
                      icon: Icons.phone,
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EmergencySupportPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}