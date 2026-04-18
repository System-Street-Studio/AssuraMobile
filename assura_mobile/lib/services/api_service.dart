import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = AppConstants.apiBaseUrl});

  // Helper for GET requests
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(headers),
    );
    return _processResponse(response);
  }

  // Helper for POST requests
  Future<dynamic> post(String endpoint,
      {dynamic body, Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(headers),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Helper for PUT requests
  Future<dynamic> put(String endpoint,
      {dynamic body, Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(headers),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Helper for DELETE requests
  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(headers),
    );
    return _processResponse(response);
  }

  Map<String, String> _getHeaders(Map<String, String>? customHeaders) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Request failed with status: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }
}
