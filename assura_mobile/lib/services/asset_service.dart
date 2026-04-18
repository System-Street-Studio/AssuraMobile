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

  Future<bool> updateAssetStatus(AssetModel asset, String newStatus) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _authService.token;
      if (token == null) throw Exception('Not authenticated');

      final url =
          Uri.parse('${AppConstants.apiBaseUrl}/api/Assets/${asset.id}');

      final body = {
        'id': asset.id,
        'assetCode': asset.assetCode,
        'assetTag': asset.assetTag,
        'assetDate': asset.assetDate.toIso8601String(),
        'status': newStatus,
        'serialNumber': asset.serialNumber,
        'purchaseValue': asset.purchaseValue,
        'warranty': asset.warranty,
        'notes': asset.notes,
        'categoryId': asset.categoryId,
        'divisionId': asset.divisionId,
        'productId': asset.productId,
        'supplierId': asset.supplierId,
        'assignedUserId': asset.assignedUserId,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final index = _assets.indexWhere((a) => a.id == asset.id);
        if (index != -1) {
          _assets[index] = AssetModel.fromJson(json.decode(response.body));
        }
        return true;
      } else {
        _error = 'Failed to update asset: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      _error = 'An error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  AssetModel? getAssetByCode(String code) {
    try {
      return _assets
          .firstWhere((a) => a.assetCode.toLowerCase() == code.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}
