import 'package:jawara/models/user_role.dart';

class User {
  final int id;
  final int? residentId;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final DateTime? createdAt;

  User({
    required this.id,
    this.residentId,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      residentId: json['resident_id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRoleExtension.fromString(json['role'] as String),
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident_id': residentId,
      'name': name,
      'email': email,
      'role': role.value,
      'phone': phone,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    int? residentId,
    String? name,
    String? email,
    UserRole? role,
    String? phone,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      residentId: residentId ?? this.residentId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
