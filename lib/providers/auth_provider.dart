import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService().login(email, senha);

    if (result.containsKey('token')) {
      _token = result['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
