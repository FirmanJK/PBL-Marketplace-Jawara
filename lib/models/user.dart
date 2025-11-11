class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    required this.createdAt,
  });
}
