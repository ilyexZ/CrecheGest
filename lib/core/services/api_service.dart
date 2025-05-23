import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8081/api';
  final Dio dio;
  String? _username;
  String? _password;

  ApiService()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {
              'accept': '*/*',
              'Content-Type': 'application/json',
            },
          ),
        );

  void setCredentials(String username, String password) {
    _username = username;
    _password = password;
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    dio.options.headers['Authorization'] = basicAuth;
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'username': email,
          'password': password,
        },
      );
      
      // Set credentials after successful login
      setCredentials(email, password);
      
      return response.data;
    } on DioException catch (e) {
      throw Exception(
          'Login failed: HTTP ${e.response?.statusCode} ${e.response?.statusMessage}');
    }
  }

  Future<void> logout() async {
    try {
      //await dio.post('/auth/logout');
    } catch (_) {
      // Ignore errors during logout
    } finally {
      // Clear stored credentials and remove auth header
      _username = null;
      _password = null;
      dio.options.headers.remove('Authorization');
    }
  }

  // Children endpoints
  Future<List<Map<String, dynamic>>> getChildren() async {
    try {
      final response = await dio.get('/children');
      // Check if the response is a List or a Map
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        final data = response.data as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data['children'] ?? []);
      }
    } on DioException catch (e) {
      throw Exception(
          'HTTP ${e.response?.statusCode}: ${e.response?.statusMessage}');
    }
  }

  Future<Map<String, dynamic>> createChild(
      Map<String, dynamic> childData) async {
    try {
      final response = await dio.post(
        '/children',
        data: childData,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
          'HTTP ${e.response?.statusCode}: ${e.response?.statusMessage}');
    }
  }

  // Parents endpoints
  Future<List<Map<String, dynamic>>> getParents() async {
    try {
      final response = await dio.get('/parents');
      
      // Fixed response parsing logic
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        final data = response.data as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data['parents'] ?? []);
      }
    } on DioException catch (e) {
      throw Exception(
          'HTTP ${e.response?.statusCode}: ${e.response?.statusMessage}');
    }
  }

  // Employees endpoints
  Future<List<Map<String, dynamic>>> getEmployees() async {
    try {
      final response = await dio.get('/employees');
      final data = response.data as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['employees'] ?? []);
    } on DioException catch (e) {
      throw Exception(
          'HTTP ${e.response?.statusCode}: ${e.response?.statusMessage}');
    }
  }
}