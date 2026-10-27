import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get userData => _userData;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      final email = prefs.getString('email') ?? '';
      _userData = {
        'name': prefs.getString('name') ?? '',
        'email': email,
        'phone': prefs.getString('phone') ?? '',
        'emergencyContacts': prefs.getStringList('emergencyContacts_$email') ?? [],
      };
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');

    if (storedEmail == email && storedPassword == password) {
      _isLoggedIn = true;
      _userData = {
        'name': prefs.getString('name') ?? '',
        'email': email,
        'phone': prefs.getString('phone') ?? '',
        'emergencyContacts': prefs.getStringList('emergencyContacts_$email') ?? [],
      };
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', true);

    _isLoggedIn = true;
    _userData = {'name': name, 'email': email, 'phone': phone, 'emergencyContacts': []};
    await prefs.setStringList('emergencyContacts_$email', []);
    notifyListeners();
    return true;
  }

  Future<void> updateProfile(String name, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);

    _userData = {
      'name': name,
      'email': email,
      'phone': phone,
      'emergencyContacts': _userData['emergencyContacts'] ?? [],
    };
    notifyListeners();
  }

  Future<void> updateEmergencyContacts(List<String> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final email = _userData['email'];
    await prefs.setStringList('emergencyContacts_$email', contacts);
    _userData['emergencyContacts'] = contacts;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    _userData = {};
    notifyListeners();
  }
}