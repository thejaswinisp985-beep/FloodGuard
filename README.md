# FloodGuard - Flood Risk Prediction App

A beautiful Flutter application with a flood/water theme designed to help users predict flood risks and stay safe during flood events.

## Features

### 🌊 Beautiful Water Theme
- Stunning blue gradient backgrounds
- Water-themed icons and colors
- Responsive design for all screen sizes

### 🔐 User Authentication
- Registration with local storage
- Login validation
- Profile management
- Secure data storage using SharedPreferences

### 🏠 Home Dashboard
- Personalized welcome message
- Weather updates section
- Quick action cards for flood prediction and contacts

### 🌧️ Flood Risk Prediction
- Advanced ML model using TensorFlow Lite
- 9 environmental parameters input
- Real-time risk assessment (High/Medium/Low)
- Beautiful result visualization

### 👤 User Profile
- Edit personal information
- Update contact details
- Profile picture placeholder

### 🌙 Dark/Light Theme Toggle
- Seamless theme switching
- Persistent theme preference

### 📱 Responsive Design
- Works on mobile and web
- Adaptive layouts
- Touch-friendly interface

## Screenshots

### Starting Page
- Upper section: Flood safety image
- Bottom section: Get Started and Login buttons

### Home Page
- Weather updates card
- Quick action cards for prediction and contacts
- Navigation drawer with profile and theme options

### Flood Prediction
- Form with 9 environmental parameters
- Real-time prediction with color-coded results
- Loading states and error handling

## Technical Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **Machine Learning**: TensorFlow Lite
- **Fonts**: Google Fonts (Pacifico, Roboto)
- **Icons**: Material Design Icons

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  tflite_flutter: ^0.12.1
  shared_preferences: ^2.2.2
  provider: ^6.1.1
  http: ^1.2.0
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
```

## Getting Started

1. **Prerequisites**
   - Flutter SDK (3.6.2 or higher)
   - Android Studio or VS Code
   - Android/iOS device or emulator

2. **Installation**
   ```bash
   # Clone the repository
   git clone <repository-url>
   cd flood_demo

   # Install dependencies
   flutter pub get
   ```

3. **Running the App**
   ```bash
   # For Android
   flutter run

   # For Web
   flutter run -d chrome

   # For iOS (macOS only)
   flutter run -d ios
   ```

4. **Building for Production**
   ```bash
   # Android APK
   flutter build apk --release

   # iOS (macOS only)
   flutter build ios --release

   # Web
   flutter build web --release
   ```

## App Flow

1. **Starting Page**: Welcome screen with flood safety image and navigation buttons
2. **Registration/Login**: User authentication with local storage
3. **Home Page**: Dashboard with weather updates and action cards
4. **Flood Prediction**: ML-powered risk assessment
5. **Profile**: User information management
6. **Coming Soon**: Placeholder for future features

## Weather Integration

The app includes weather updates using the OpenWeatherMap API. To enable real weather data:

1. Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
2. Replace `'YOUR_API_KEY'` in `lib/main.dart` with your actual API key
3. Update the city name if desired

## ML Model

The flood prediction uses a TensorFlow Lite model trained on environmental parameters:
- Rainfall (mm)
- River Level (m)
- Dam Water Level (%)
- Soil Moisture (%)
- Humidity (%)
- Wind Speed (kmph)
- Above Sea Level (m)
- Drainage Capacity (%)
- Population Density

## Security & Privacy

- User data stored locally using SharedPreferences
- No external servers required
- Secure authentication validation
- Privacy-focused design

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue on GitHub
- Check the Flutter documentation
- Review the code comments for implementation details

---

**Stay Safe, Stay Prepared** 🌊
