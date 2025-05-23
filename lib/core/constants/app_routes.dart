// lib/core/constants/app_routes.dart
import 'package:flutter/material.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/admin/admin_dashboard.dart';
// Import other screens as needed

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String adminDashboard = '/admin-dashboard';
  static const String childDetails = '/child-details';
  static const String employeeDetails = '/employee-details';
  static const String parentDetails = '/parent-details';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    adminDashboard: (context) => const AdminDashboard(),
    // Add other routes as you create the screens
    // childDetails: (context) => const ChildDetailsScreen(),
    // employeeDetails: (context) => const EmployeeDetailsScreen(),
    // parentDetails: (context) => const ParentDetailsScreen(),
  };
}