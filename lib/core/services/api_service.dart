// lib/data/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8081/api';
  static const String tokenKey = 'auth_token';
  
  String? _authToken;

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'accept':'*/*','Content-Type': 'application/json'},
      body: json.encode({
        'username': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<void> logout() async {
    final headers = await _getAuthHeaders();
    
    await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: headers,
    );
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final headers = await _getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      await clearAuthToken();
      return null;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // Children endpoints
  Future<List<Map<String, dynamic>>> getChildren() async {
    final headers = await _getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/children'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['children'] ?? []);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> createChild(Map<String, dynamic> childData) async {
    final headers = await _getAuthHeaders();
    
    final response = await http.post(
      Uri.parse('$baseUrl/children'),
      headers: headers,
      body: json.encode(childData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // Parents endpoints
  Future<List<Map<String, dynamic>>> getParents() async {
    final headers = await _getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/parents'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['parents'] ?? []);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // Employees endpoints
  Future<List<Map<String, dynamic>>> getEmployees() async {
    final headers = await _getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/employees'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['employees'] ?? []);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // Token management
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  Future<String?> getStoredToken() async {
    if (_authToken != null) return _authToken;
    
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(tokenKey);
    return _authToken;
  }

  // Private helper methods
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getStoredToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}