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
    // Removed setCredentials call here
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'username': email,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
          'Login failed: HTTP ${e.response?.statusCode} ${e.response?.statusMessage}');
    }
  }

  Future<void> logout() async {
    // If you have a logout endpoint, it'll now send the same Basic header.
    try {
      await dio.post('/auth/logout');
    } on DioException {
      // Ignore errors during logout
    }
  }

  // Children endpoints
  Future<List<Map<String, dynamic>>> getChildren() async {
    try {
      final response = await dio.get('/children');
      final data = response.data as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['children'] ?? []);
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
      final data = response.data as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['parents'] ?? []);
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
