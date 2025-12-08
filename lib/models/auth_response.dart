import 'package:jawara/models/user.dart';

/// Response dari /auth/login endpoint
class LoginResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final User user;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 1800,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'user': user.toJson(),
    };
  }
}

/// Response dari /auth/register endpoint
class RegisterResponse {
  final int id;
  final String name;
  final String email;
  final String username;
  final String? phone;
  final String role;
  final DateTime createdAt;

  RegisterResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.phone,
    required this.role,
    required this.createdAt,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'warga',
      createdAt: DateTime.parse(json['created_at'] as String),
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
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Response dari /auth/me endpoint
class CurrentUserResponse {
  final int id;
  final String? residentId;
  final String name;
  final String username;
  final String? email;
  final String? phone;
  final String role;
  final Map<String, dynamic>? resident;

  CurrentUserResponse({
    required this.id,
    this.residentId,
    required this.name,
    required this.username,
    this.email,
    this.phone,
    required this.role,
    this.resident,
  });

  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) {
    return CurrentUserResponse(
      id: json['id'] as int,
      residentId: json['resident_id']?.toString(),
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      resident: json['resident'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident_id': residentId,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'resident': resident,
    };
  }
}

/// Error response dari backend
class ErrorResponse {
  final int? statusCode;
  final String detail;

  ErrorResponse({this.statusCode, required this.detail});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      statusCode: json['status_code'] as int?,
      detail: json['detail'] as String? ?? 'Terjadi kesalahan',
    );
  }

  @override
  String toString() => detail;
}
