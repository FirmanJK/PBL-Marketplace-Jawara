import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/auth_service.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String username;
  final String? phone;
  final String role;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.phone,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'phone': phone,
      'role': role,
      'created_at': createdAt,
    };
  }
}

class UsersService {
  static const String endpoint = '/users';
  static final AuthService _authService = AuthService();

  /// Get all users with optional filters
  static Future<List<UserModel>> getUsers({
    int skip = 0,
    int limit = 100,
    String? search,
    String? role,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (search != null) 'search': search,
        if (role != null) 'role': role,
      };

      final token = _authService.accessToken;
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await ApiService.get(
        endpoint,
        queryParams: queryParams,
        token: token,
      );

      final List<dynamic> data = response is List
          ? response
          : response['data'] ?? [];
      return data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  /// Get user by ID
  static Future<UserModel> getUserById(int id) async {
    try {
      final token = _authService.accessToken;
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await ApiService.get('$endpoint/$id', token: token);
      final data = response is Map ? response : response['data'] ?? response;
      return UserModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  /// Create new user
  static Future<UserModel> createUser({
    required String name,
    required String email,
    required String username,
    required String password,
    String? phone,
    String role = 'viewer',
  }) async {
    try {
      final token = _authService.accessToken;
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final body = {
        'name': name,
        'email': email,
        'username': username,
        'password': password,
        'phone': phone,
        'role': role,
      };

      final response = await ApiService.post(
        endpoint,
        body: body,
        token: token,
      );
      final data = response is Map ? response : response['data'] ?? response;
      return UserModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Update user
  static Future<UserModel> updateUser(
    int id, {
    String? name,
    String? email,
    String? phone,
    String? role,
  }) async {
    try {
      final token = _authService.accessToken;
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final body = <String, dynamic>{
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (role != null) 'role': role,
      };

      final response = await ApiService.put(
        '$endpoint/$id',
        body: body,
        token: token,
      );
      final data = response is Map ? response : response['data'] ?? response;
      return UserModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user
  static Future<void> deleteUser(int id) async {
    try {
      final token = _authService.accessToken;
      if (token == null) {
        throw Exception('Not authenticated');
      }

      await ApiService.delete('$endpoint/$id', token: token);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
