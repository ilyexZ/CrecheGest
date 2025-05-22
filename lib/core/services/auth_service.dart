import '../../../data/models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Mock authentication - replace with actual API calls
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // Mock admin user for testing
    if (email == 'admin@crechegest.com' && password == 'admin123') {
      return User(
        id: '1',
        email: email,
        firstName: 'Admin',
        lastName: 'CrècheGest',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );
    }
    
    return null; // Authentication failed
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Clear any stored tokens/data here
  }
}