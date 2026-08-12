import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/user_model.dart';
import '../core/models/user_profile_model.dart';
import 'api_service.dart';
import '../core/constants/app_constants.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? _user;
  String? _token;
  UserProfileModel? _profile;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  UserProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  bool get isPendingUser {
    final isPendingIdentity = _user?.roles.contains('PendingAssignment') ?? false;
    final divId = _profile?.divisionId;
    return isPendingIdentity && (divId == null || divId == 0);
  }

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

      _token = authResponse.token;
      _user = authResponse.user;

      bool isAuthorized = _user!.isAdmin;

      if (!isAuthorized) {
        final profile = await fetchUserProfile();
        if (profile != null && profile.divisionName?.toLowerCase() == 'admin') {
          isAuthorized = true;
        }
      }

      if (!isAuthorized) {
        _token = null;
        _user = null;
        _profile = null;
        _setLoading(false);
        throw Exception('Access denied. Only Admin division employees are allowed.');
      }

      await _saveAuthData(_token!, _user!);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Forgot Password method
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    try {
      await _apiService.post(
        AppConstants.forgotPasswordEndpoint,
        body: {'email': email},
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      debugPrint('Error in forgotPassword: $e');
      return false;
    }
  }

  // Reset Password method
  Future<bool> resetPassword(
      String email, String token, String newPassword) async {
    _setLoading(true);
    try {
      await _apiService.post(
        AppConstants.resetPasswordEndpoint,
        body: {
          'email': email,
          'token': token,
          'newPassword': newPassword,
        },
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      debugPrint('Error in resetPassword: $e');
      return false;
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

  Future<UserProfileModel?> fetchUserProfile() async {
    if (_token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _profile = UserProfileModel.fromJson(data);
        notifyListeners();
        return _profile;
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
    return null;
  }

  Future<bool> updateUserProfile(UserProfileModel updatedProfile,
      {String? password, String? currentPassword}) async {
    if (_token == null) return false;

    try {
      final response = await http.put(
        Uri.parse('${AppConstants.apiBaseUrl}/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode(updatedProfile.toJson(password: password, currentPassword: currentPassword)),
      );

      if (response.statusCode == 200) {
        _profile = updatedProfile;
        // Also update the short UserModel name if changed
        if (_user != null) {
          _user = UserModel(
            id: _user!.id,
            userName: updatedProfile.username,
            name: '${updatedProfile.firstName} ${updatedProfile.lastName}',
            roles: _user!.roles,
          );
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error updating user profile: $e');
    }
    return false;
  }
}
