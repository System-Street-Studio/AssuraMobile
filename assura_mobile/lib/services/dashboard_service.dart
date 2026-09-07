import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../core/models/dashboard_stats_model.dart';
import 'auth_service.dart';

class DashboardService with ChangeNotifier {
  DashboardStatsModel? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardStatsModel? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final AuthService _authService;

  DashboardService(this._authService);

  Future<void> fetchDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _authService.token;
      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse(
          '${AppConstants.apiBaseUrl}${AppConstants.dashboardStatsEndpoint}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _stats = DashboardStatsModel.fromJson(data);
      } else {
        _error = 'Failed to fetch dashboard stats: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
