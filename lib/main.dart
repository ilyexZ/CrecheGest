// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_routes.dart';
import 'presentation/providers/auth_provider.dart';

import 'presentation/screens/login_screen.dart';
import 'presentation/screens/admin/admin_dashboard.dart';
import 'presentation/screens/common/loading_screen.dart';

void main() {
  runApp(const ProviderScope(child: CrecheGestApp()));
}

class CrecheGestApp extends ConsumerWidget {
  const CrecheGestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrecheGest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: AppRoutes.routes,
      home: _getHomeScreen(authState),
    );
  }

  Widget _getHomeScreen(AuthState authState) {
    
    
    if (authState.isLoggedIn) {
      return const AdminDashboard(); // Route based on user role
    }
    if(authState.isLoading){
      return LoadingScreen();
    }
    
    return const LoginScreen();
  }
}