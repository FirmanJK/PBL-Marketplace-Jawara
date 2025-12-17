import 'package:jawara/models/user_role.dart';
import 'package:jawara/services/session_service.dart';

/// Helper class untuk mengakses local storage (token, user data, dll)
class LocalStorage {
  static final _sessionService = SessionService();

  /// Get token dari SharedPreferences
  static Future<String?> getToken() async {
    try {
      return await _sessionService.getToken();
    } catch (_) {
      return null;
    }
  }

  /// Get user ID dari SharedPreferences
  static Future<int?> getUserId() async {
    try {
      final user = await _sessionService.getCurrentUser();
      return user?.id;
    } catch (_) {
      return null;
    }
  }

  /// Get user email dari SharedPreferences
  static Future<String?> getUserEmail() async {
    try {
      final user = await _sessionService.getCurrentUser();
      return user?.email;
    } catch (_) {
      return null;
    }
  }

  /// Get user role dari SharedPreferences
  static Future<String?> getUserRole() async {
    try {
      final user = await _sessionService.getCurrentUser();
      if (user == null) return null;
      return user.role.value;
    } catch (_) {
      return null;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Clear all stored data (logout)
  static Future<void> clear() async {
    try {
      await _sessionService.clearSession();
    } catch (_) {
      // Handle error silently
    }
  }
}
