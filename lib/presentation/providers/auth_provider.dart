// lib/presentation/providers/auth_provider.dart
import 'package:creche/core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  AuthNotifier(this._apiService) : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final response = await _apiService.login(email, password);
      final user = User.fromJson(response['user']);
      
      // Store token if provided
      // if (response['token'] != null) {
      //   await _apiService.setAuthToken(response['token']);
      // }
      
      state = state.copyWith(currentUser: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('401') 
            ? 'Email ou mot de passe incorrect'
            : 'Erreur de connexion. Veuillez réessayer.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _apiService.logout();
      await _apiService.clearAuthToken();
      state = AuthState();
    } catch (e) {
      // Still clear local state even if server call fails
      state = AuthState();
    }
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final userInfo = await _apiService.getCurrentUser();
      if (userInfo != null) {
        final user = User.fromJson(userInfo);
        state = state.copyWith(currentUser: user, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

// Providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthNotifier(apiService);
});

final authProviderNotifier = Provider<AuthNotifier>((ref) => ref.read(authProvider.notifier));