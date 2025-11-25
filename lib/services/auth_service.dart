import 'package:jawara/models/user.dart';
import 'package:jawara/models/user_role.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Current logged in user
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  UserRole? get currentRole => _currentUser?.role;
  bool get isLoggedIn => _currentUser != null;

  // Login method
  Future<bool> login(String email, String password) async {
    // TODO: Implementasi real API call
    // Simulasi login untuk development
    await Future.delayed(const Duration(seconds: 1));

    // Dummy users untuk testing
    final dummyUsers = {
      'admin@jawara.com': User(
        id: 1,
        name: 'Admin Sistem',
        email: 'admin@jawara.com',
        role: UserRole.adminSistem,
      ),
      'ketua@jawara.com': User(
        id: 2,
        name: 'Ketua RT',
        email: 'ketua@jawara.com',
        role: UserRole.ketuaRT,
      ),
      'sekretaris@jawara.com': User(
        id: 3,
        name: 'Sekretaris',
        email: 'sekretaris@jawara.com',
        role: UserRole.sekretaris,
      ),
      'bendahara@jawara.com': User(
        id: 4,
        name: 'Bendahara',
        email: 'bendahara@jawara.com',
        role: UserRole.bendahara,
      ),
      'warga@jawara.com': User(
        id: 5,
        name: 'Warga',
        email: 'warga@jawara.com',
        role: UserRole.warga,
      ),
    };

    if (dummyUsers.containsKey(email) && password == 'password') {
      _currentUser = dummyUsers[email];
      return true;
    }

    return false;
  }

  // Logout method
  Future<void> logout() async {
    // TODO: Clear session, tokens, cache
    _currentUser = null;
  }

  // Check if user has permission
  bool hasPermission(
    AppModule module, {
    bool view = false,
    bool create = false,
    bool edit = false,
    bool delete = false,
    bool export = false,
  }) {
    if (_currentUser == null) return false;
    
    return RolePermissions.hasPermission(
      _currentUser!.role,
      module,
      view: view,
      create: create,
      edit: edit,
      delete: delete,
      export: export,
    );
  }

  // Check if user can access module
  bool canAccessModule(AppModule module) {
    if (_currentUser == null) return false;
    
    final accessibleModules = RolePermissions.getAccessibleModules(_currentUser!.role);
    return accessibleModules.contains(module);
  }

  // Get user's accessible modules
  List<AppModule> getAccessibleModules() {
    if (_currentUser == null) return [];
    return RolePermissions.getAccessibleModules(_currentUser!.role);
  }

  // Check if user is admin
  bool get isAdmin => _currentUser?.role == UserRole.adminSistem;

  // Check if user is staff (admin, ketua, sekretaris, bendahara)
  bool get isStaff {
    if (_currentUser == null) return false;
    return _currentUser!.role != UserRole.warga;
  }

  // Check if user is warga
  bool get isWarga => _currentUser?.role == UserRole.warga;
}
