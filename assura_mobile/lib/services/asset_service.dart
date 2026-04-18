import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../core/models/asset_model.dart';
import 'auth_service.dart';

class AssetService with ChangeNotifier {
  List<AssetModel> _assets = [];
  bool _isLoading = false;
  String? _error;

  List<AssetModel> get assets => _assets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final AuthService _authService;

  AssetService(this._authService);

  Future<void> fetchAssets() async {
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

      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/Assets');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _assets = data.map((i) => AssetModel.fromJson(i)).toList();
      } else {
        _error = 'Failed to fetch assets: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
