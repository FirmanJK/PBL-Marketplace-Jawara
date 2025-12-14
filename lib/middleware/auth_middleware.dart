import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/role_helper.dart';

class AuthMiddleware extends StatefulWidget {
  final Widget child;
  final bool requireAuth;
  
  const AuthMiddleware({
    super.key,
    required this.child,
    this.requireAuth = true,
  });

  @override
  State<AuthMiddleware> createState() => _AuthMiddlewareState();
}

class _AuthMiddlewareState extends State<AuthMiddleware> {
  final AuthService _authService = AuthService();
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    if (!widget.requireAuth) {
      setState(() => _isChecking = false);
      return;
    }

    try {
      // Check if user is logged in
      if (!_authService.isLoggedIn) {
        // Redirect to login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      // Check if token is still valid
      final isValid = await _authService.isTokenValid();
      if (!isValid) {
        // Token expired, logout and redirect to login
        await _authService.logout();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      setState(() => _isChecking = false);
    } catch (e) {
      print('Auth check error: $e');
      // On error, redirect to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memeriksa autentikasi...'),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}

class RoleBasedWidget extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;
  final Widget? fallback;

  const RoleBasedWidget({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentRole = authService.currentRole;

    if (currentRole == null) {
      return fallback ?? const SizedBox.shrink();
    }

    final hasAccess = allowedRoles.contains(currentRole.name);
    
    if (hasAccess) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}