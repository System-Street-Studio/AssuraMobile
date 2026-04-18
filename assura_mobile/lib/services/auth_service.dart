import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/user_model.dart';
import 'api_service.dart';
import '../core/constants/app_constants.dart';

class AuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthService() {
    _loadAuthData();
  }

  // Login method
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    try {
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        body: {'username': username, 'password': password},
      );

      final authResponse = AuthResponseModel.fromJson(response);

      // Check if user is Admin
      if (!authResponse.user.isAdmin) {
        _setLoading(false);
        throw Exception('Only Admin users can access the mobile app.');
      }

      _user = authResponse.user;
      _token = authResponse.token;

      await _saveAuthData(_token!, _user!);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Logout method
  Future<void> logout() async {
    _user = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Save auth data to shared preferences
  Future<void> _saveAuthData(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Load auth data from shared preferences
  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
    }
    notifyListeners();
  }
}
