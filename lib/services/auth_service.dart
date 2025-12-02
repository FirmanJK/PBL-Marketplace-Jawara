import 'dart:convert';
import 'package:jawara/models/user.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/models/auth_response.dart';
import 'package:jawara/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Current logged in user
  User? _currentUser;
  String? _accessToken;

  User? get currentUser => _currentUser;
  UserRole? get currentRole => _currentUser?.role;
  bool get isLoggedIn => _currentUser != null && _accessToken != null;
  String? get accessToken => _accessToken;

  /// Initialize auth service - load saved session
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Load access token
    _accessToken = prefs.getString('access_token');

    // Load user data
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      try {
        final Map<String, dynamic> decoded = Map.from(
          jsonDecode(userJson) as Map,
        );
        _currentUser = User.fromJson(decoded);
      } catch (e) {
        print('Error loading user from prefs: $e');
      }
    }
  }

  /// Login dengan email dan password
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await ApiService.post(
        '/auth/login',
        body: {'email': email, 'password': password},
      );

      // Handle error response
      if (response is Map && response.containsKey('detail')) {
        throw ErrorResponse.fromJson(response as Map<String, dynamic>);
      }

      final loginResponse = LoginResponse.fromJson(
        response as Map<String, dynamic>,
      );

      // Save token and user
      _accessToken = loginResponse.accessToken;
      _currentUser = loginResponse.user;

      await _saveSession(loginResponse);

      return loginResponse;
    } on ApiException catch (e) {
      // Convert ApiException to ErrorResponse so it can be caught properly
      throw ErrorResponse(statusCode: e.statusCode, detail: e.message);
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  /// Register user baru
  Future<RegisterResponse> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String nik,
    required String gender,
    required DateTime birthDate,
    String? phone,
    String? birthPlace,
  }) async {
    try {
      final response = await ApiService.post(
        '/auth/register',
        body: {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'password_confirm': passwordConfirm,
          'phone': phone,
          'nik': nik,
          'gender': gender,
          'birth_date': birthDate.toString().split(' ')[0], // YYYY-MM-DD
          'birth_place': birthPlace,
        },
      );

      // Handle error response
      if (response is Map && response.containsKey('detail')) {
        throw ErrorResponse.fromJson(response as Map<String, dynamic>);
      }

      return RegisterResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Register error: $e');
      rethrow;
    }
  }

  /// Get current user profile
  Future<CurrentUserResponse> getCurrentUser() async {
    if (_accessToken == null) {
      throw Exception('No access token');
    }

    try {
      final response = await ApiService.get('/auth/me', token: _accessToken);

      return CurrentUserResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Get current user error: $e');
      rethrow;
    }
  }

  /// Refresh access token
  Future<LoginResponse> refreshToken() async {
    if (_accessToken == null) {
      throw Exception('No access token to refresh');
    }

    try {
      final response = await ApiService.post(
        '/auth/refresh',
        body: {'token': _accessToken},
      );

      final loginResponse = LoginResponse.fromJson(
        response as Map<String, dynamic>,
      );

      // Update token and user
      _accessToken = loginResponse.accessToken;
      _currentUser = loginResponse.user;

      await _saveSession(loginResponse);

      return loginResponse;
    } catch (e) {
      print('Refresh token error: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
    _accessToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('current_user');
    await prefs.remove('token_expires_at');
  }

  /// Save session ke SharedPreferences
  Future<void> _saveSession(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    // Save token
    await prefs.setString('access_token', loginResponse.accessToken);

    // Save user data
    await prefs.setString(
      'current_user',
      jsonEncode(loginResponse.user.toJson()),
    );

    // Save token expiration time
    final expiresAt = DateTime.now().add(
      Duration(seconds: loginResponse.expiresIn),
    );
    await prefs.setString('token_expires_at', expiresAt.toIso8601String());
  }

  /// Check if token is still valid
  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAtStr = prefs.getString('token_expires_at');

    if (expiresAtStr == null) return false;

    final expiresAt = DateTime.parse(expiresAtStr);
    return DateTime.now().isBefore(expiresAt);
  }

  /// Check if user has specific role
  bool hasRole(UserRole role) => _currentUser?.role == role;

  /// Check if user is admin
  bool get isAdmin => _currentUser?.role == UserRole.adminSistem;

  /// Check if user is staff (admin, ketua, sekretaris, bendahara)
  bool get isStaff {
    if (_currentUser == null) return false;
    return _currentUser!.role != UserRole.warga;
  }

  /// Check if user is warga
  bool get isWarga => _currentUser?.role == UserRole.warga;
}
