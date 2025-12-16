import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/utils/role_helper.dart';

/// Helper class untuk testing dan development
class TestHelper {
  
  /// Data user demo untuk setiap role
  static List<Map<String, dynamic>> getDemoUsers() {
    return [
      {
        'name': 'Admin Sistem',
        'email': 'admin@jawara.com',
        'username': 'admin',
        'password': 'admin123',
        'role': 'admin_sistem',
        'phone': '081234567890',
      },
      {
        'name': 'Ketua RT 01',
        'email': 'ketua@rt01.com',
        'username': 'ketua_rt',
        'password': 'ketua123',
        'role': 'ketua_rt',
        'phone': '081234567891',
      },
      {
        'name': 'Sekretaris RT',
        'email': 'sekretaris@rt01.com',
        'username': 'sekretaris',
        'password': 'sekretaris123',
        'role': 'sekretaris',
        'phone': '081234567892',
      },
      {
        'name': 'Bendahara RT',
        'email': 'bendahara@rt01.com',
        'username': 'bendahara',
        'password': 'bendahara123',
        'role': 'bendahara',
        'phone': '081234567893',
      },
      {
        'name': 'Warga Biasa',
        'email': 'warga@rt01.com',
        'username': 'warga',
        'password': 'warga123',
        'role': 'warga',
        'phone': '081234567894',
      },
    ];
  }

  /// Test login untuk role tertentu
  static Future<bool> testRoleLogin(String email, String password) async {
    final authService = AuthService();
    
    try {
      final response = await authService.login(email, password);
      final user = response.user;
      
      print('🔐 Login Success:');
      print('   Name: ${user.name}');
      print('   Email: ${user.email}');
      print('   Role: ${user.role.label}');
      print('   Dashboard: ${RoleHelper.getDashboardRoute(user.role)}');
      
      // Test permissions
      final features = RoleHelper.getAvailableFeatures(user.role);
      print('   Available Features: ${features.join(', ')}');
      
      return true;
    } catch (e) {
      print('❌ Login Failed: $e');
      return false;
    }
  }

  /// Test login untuk semua role demo
  static Future<void> testAllRoleLogins() async {
    final demoUsers = getDemoUsers();
    
    print('🧪 Testing login for all roles...\n');
    
    for (final user in demoUsers) {
      print('Testing ${user['role']}...');
      await testRoleLogin(user['email'], user['password']);
      print('');
    }
  }

  /// Cek apakah user dengan email tertentu sudah ada
  static Future<bool> userExists(String email) async {
    try {
      // Try to get user info (this will fail if user doesn't exist)
      await ApiService.get('/auth/check-email?email=$email');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Print informasi role dan permissions
  static void printRoleInfo(UserRole role) {
    print('📋 Role Information: ${role.label}');
    print('   Value: ${role.value}');
    print('   Dashboard: ${RoleHelper.getDashboardRoute(role)}');
    
    final permissions = RolePermissions.getPermissions(role);
    print('   Permissions:');
    for (final permission in permissions) {
      final actions = <String>[];
      if (permission.canView) actions.add('View');
      if (permission.canCreate) actions.add('Create');
      if (permission.canEdit) actions.add('Edit');
      if (permission.canDelete) actions.add('Delete');
      if (permission.canExport) actions.add('Export');
      
      print('     ${permission.module.name}: ${actions.join(', ')}');
    }
    print('');
  }

  /// Print informasi semua role
  static void printAllRolesInfo() {
    print('🎭 All Roles Information:\n');
    
    for (final role in UserRole.values) {
      printRoleInfo(role);
    }
  }

  /// Quick login helper untuk development
  static Map<String, String> getQuickLoginCredentials(UserRole role) {
    final demoUsers = getDemoUsers();
    final userData = demoUsers.firstWhere(
      (user) => user['role'] == role.value,
      orElse: () => demoUsers.last, // fallback to warga
    );
    
    return {
      'email': userData['email'],
      'password': userData['password'],
    };
  }

  /// Login cepat untuk development
  static Future<bool> quickLogin(UserRole role) async {
    final credentials = getQuickLoginCredentials(role);
    return await testRoleLogin(credentials['email']!, credentials['password']!);
  }
}

/// Extension untuk memudahkan testing
extension TestUserRole on UserRole {
  /// Quick login untuk role ini
  Future<bool> quickLogin() async {
    return await TestHelper.quickLogin(this);
  }
  
  /// Get credentials untuk role ini
  Map<String, String> get credentials {
    return TestHelper.getQuickLoginCredentials(this);
  }
  
  /// Print info untuk role ini
  void printInfo() {
    TestHelper.printRoleInfo(this);
  }
}