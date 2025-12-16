import 'package:jawara/models/user.dart';
import 'package:jawara/models/user_role.dart';

/// Data user demo untuk testing login dengan berbagai role
class DemoUsers {
  static List<Map<String, dynamic>> getUsersData() {
    return [
      {
        'id': 1,
        'name': 'Admin Sistem',
        'email': 'admin@jawara.com',
        'username': 'admin',
        'password': 'admin123',
        'role': 'admin_sistem',
        'phone': '081234567890',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 2,
        'name': 'Budi Santoso',
        'email': 'ketua@rt01.com',
        'username': 'ketua_rt',
        'password': 'ketua123',
        'role': 'ketua_rt',
        'phone': '081234567891',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 3,
        'name': 'Siti Aminah',
        'email': 'sekretaris@rt01.com',
        'username': 'sekretaris',
        'password': 'sekretaris123',
        'role': 'sekretaris',
        'phone': '081234567892',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 4,
        'name': 'Ahmad Wijaya',
        'email': 'bendahara@rt01.com',
        'username': 'bendahara',
        'password': 'bendahara123',
        'role': 'bendahara',
        'phone': '081234567893',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 5,
        'name': 'Dewi Sartika',
        'email': 'warga@rt01.com',
        'username': 'warga',
        'password': 'warga123',
        'role': 'warga',
        'phone': '081234567894',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];
  }

  static List<User> getUsers() {
    return getUsersData().map((userData) {
      return User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        role: UserRoleExtension.fromString(userData['role']),
        phone: userData['phone'],
        createdAt: DateTime.parse(userData['created_at']),
      );
    }).toList();
  }

  static User? findUserByCredentials(String email, String password) {
    final usersData = getUsersData();
    
    try {
      final userData = usersData.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );
      
      return User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        role: UserRoleExtension.fromString(userData['role']),
        phone: userData['phone'],
        createdAt: DateTime.parse(userData['created_at']),
      );
    } catch (e) {
      return null;
    }
  }

  static Map<String, String> getCredentialsForRole(UserRole role) {
    final usersData = getUsersData();
    final userData = usersData.firstWhere(
      (user) => user['role'] == role.value,
      orElse: () => usersData.last,
    );
    
    return {
      'email': userData['email'],
      'password': userData['password'],
    };
  }

  static User? findUserByEmail(String email) {
    final usersData = getUsersData();
    
    try {
      final userData = usersData.firstWhere(
        (user) => user['email'] == email,
      );
      
      return User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        role: UserRoleExtension.fromString(userData['role']),
        phone: userData['phone'],
        createdAt: DateTime.parse(userData['created_at']),
      );
    } catch (e) {
      return null;
    }
  }
}