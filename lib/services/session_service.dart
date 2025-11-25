import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:jawara/models/user.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';
  static const String _keyToken = 'auth_token';
  static const String _keyRememberMe = 'remember_me';

  // Save session
  Future<bool> saveSession(User user, String token, {bool rememberMe = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
      await prefs.setString(_keyToken, token);
      await prefs.setBool(_keyRememberMe, rememberMe);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current session
  Future<Map<String, dynamic>?> getSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      
      if (!isLoggedIn) return null;

      final userData = prefs.getString(_keyUserData);
      final token = prefs.getString(_keyToken);
      
      if (userData == null || token == null) return null;

      return {
        'user': User.fromJson(jsonDecode(userData)),
        'token': token,
        'isLoggedIn': isLoggedIn,
      };
    } catch (e) {
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get auth token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_keyUserData);
      if (userData == null) return null;
      return User.fromJson(jsonDecode(userData));
    } catch (e) {
      return null;
    }
  }

  // Clear session (logout)
  Future<bool> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserData);
      await prefs.remove(_keyToken);
      // Keep remember me preference
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check remember me
  Future<bool> shouldRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  // Update user data
  Future<bool> updateUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }
}
