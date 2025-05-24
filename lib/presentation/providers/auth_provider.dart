// lib/presentation/providers/auth_provider.dart
import 'dart:developer';

import 'package:creche/core/services/api_service.dart';
import 'package:creche/presentation/providers/child_provider.dart';
import 'package:creche/presentation/providers/parent_provider.dart';
import 'package:creche/presentation/providers/parent_request_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/user_model.dart';

class AuthState {
  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? currentUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoggedIn => currentUser != null;
  bool get isAdmin => currentUser?.role == UserRole.admin;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final FlutterSecureStorage _storage;
  static const _keyUsername = 'auth_username';
  static const _keyPassword = 'auth_password';

  AuthNotifier(this._apiService)
      : _storage = const FlutterSecureStorage(),
        super(AuthState()) {
    _loadCredentials();
    
  }

  // Load stored credentials and attempt auto-login
  Future<void> _loadCredentials() async {
    final storedUser = await _storage.read(key: _keyUsername);
    final storedPass = await _storage.read(key: _keyPassword);
    // if (storedUser != null && storedPass != null) {
    //   await login(storedUser, storedPass, store: false);
    // }
  }

  Future<bool> login(String email, String password, {bool store = true}) async {
  state = state.copyWith(isLoading: true, errorMessage: null);
  try {
    final response = await _apiService.login(email, password);
    final user = User.fromJson(response['user']);
    
    // Add explicit role verification
    if (user.role == null) {
      throw Exception('User role not found');
    }

    _apiService.setCredentials(email, password);
    state = state.copyWith(currentUser: user, isLoading: false);
    
    if (store) {
      await _storage.write(key: _keyUsername, value: email);
      await _storage.write(key: _keyPassword, value: password);
    }
    return true;
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: 'Failed to load user role: ${e.toString()}',
    );
    return false;
  }
}

  Future<void> logout(WidgetRef ref) async {
  state = state.copyWith(isLoading: false);
  try {
    await _apiService.logout();
  } catch (_) {}
  
  // Clear state and storage
  state = AuthState();
  await _storage.delete(key: _keyUsername);
  await _storage.delete(key: _keyPassword);

  // Add this to reset all providers
  ref.invalidate(childProvider);
  ref.invalidate(parentProvider);
  ref.invalidate(parentRequestProvider);
}
}

// Providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthNotifier(apiService);
});

final authNotifierProvider = Provider<AuthNotifier>((ref) => ref.read(authProvider.notifier));
