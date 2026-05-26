import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = false;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  bool get isAdmin {
    if (_user == null) return false;
    return _user!['is_admin'] == true;
  }

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = json.decode(userJson);
    }
    notifyListeners();
    return null;
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService().login(email, senha);

    if (result.containsKey('token')) {
      _token = result['token'];
      _user = result['user'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      if (_user != null) {
        await prefs.setString('user', json.encode(_user));
      }
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> dadosUsuario) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService().register(dadosUsuario);

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> verifyCode(String email, String codigo) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService().verifyCode(email, codigo);

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService().forgotPassword(email);

    _isLoading = false;
    notifyListeners();
    return result;
  }


  Future<Map<String, dynamic>> resetPassword(String email, String codigo, String novaSenha) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService().resetPassword(email, codigo, novaSenha);

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }
}
