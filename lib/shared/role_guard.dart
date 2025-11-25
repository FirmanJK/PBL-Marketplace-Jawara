import 'package:flutter/material.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/services/auth_service.dart';

/// Widget untuk membatasi akses berdasarkan role
class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<UserRole>? allowedRoles;
  final AppModule? requiredModule;
  final bool requireView;
  final bool requireCreate;
  final bool requireEdit;
  final bool requireDelete;
  final bool requireExport;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.child,
    this.allowedRoles,
    this.requiredModule,
    this.requireView = false,
    this.requireCreate = false,
    this.requireEdit = false,
    this.requireDelete = false,
    this.requireExport = false,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    // Check if user is logged in
    if (!authService.isLoggedIn) {
      return fallback ?? const SizedBox.shrink();
    }

    // Check role-based access
    if (allowedRoles != null && !allowedRoles!.contains(authService.currentRole)) {
      return fallback ?? const SizedBox.shrink();
    }

    // Check module permission
    if (requiredModule != null) {
      final hasPermission = authService.hasPermission(
        requiredModule!,
        view: requireView,
        create: requireCreate,
        edit: requireEdit,
        delete: requireDelete,
        export: requireExport,
      );

      if (!hasPermission) {
        return fallback ?? const SizedBox.shrink();
      }
    }

    return child;
  }
}

/// Widget untuk menampilkan konten berbeda berdasarkan role
class RoleBasedWidget extends StatelessWidget {
  final Widget? adminWidget;
  final Widget? ketuaRTWidget;
  final Widget? sekretarisWidget;
  final Widget? bendaharaWidget;
  final Widget? wargaWidget;
  final Widget? defaultWidget;

  const RoleBasedWidget({
    super.key,
    this.adminWidget,
    this.ketuaRTWidget,
    this.sekretarisWidget,
    this.bendaharaWidget,
    this.wargaWidget,
    this.defaultWidget,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    if (!authService.isLoggedIn) {
      return defaultWidget ?? const SizedBox.shrink();
    }

    switch (authService.currentRole) {
      case UserRole.adminSistem:
        return adminWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.ketuaRT:
        return ketuaRTWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.sekretaris:
        return sekretarisWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.bendahara:
        return bendaharaWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.warga:
        return wargaWidget ?? defaultWidget ?? const SizedBox.shrink();
      default:
        return defaultWidget ?? const SizedBox.shrink();
    }
  }
}

/// Mixin untuk route guard
mixin RouteGuard {
  bool canAccessRoute(BuildContext context, {
    List<UserRole>? allowedRoles,
    AppModule? requiredModule,
  }) {
    final authService = AuthService();
    
    // Check if user is logged in
    if (!authService.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
      return false;
    }

    // Check role-based access
    if (allowedRoles != null && !allowedRoles.contains(authService.currentRole)) {
      _showAccessDenied(context);
      return false;
    }

    // Check module permission
    if (requiredModule != null && !authService.canAccessModule(requiredModule)) {
      _showAccessDenied(context);
      return false;
    }

    return true;
  }

  void _showAccessDenied(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda tidak memiliki akses ke halaman ini'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pop(context);
  }
}

/// Base page dengan route guard
abstract class GuardedPage extends StatefulWidget {
  final List<UserRole>? allowedRoles;
  final AppModule? requiredModule;

  const GuardedPage({
    super.key,
    this.allowedRoles,
    this.requiredModule,
  });
}

abstract class GuardedPageState<T extends GuardedPage> extends State<T> with RouteGuard {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      canAccessRoute(
        context,
        allowedRoles: widget.allowedRoles,
        requiredModule: widget.requiredModule,
      );
    });
  }
}
