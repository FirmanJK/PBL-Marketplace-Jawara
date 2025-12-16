enum UserRole {
  adminSistem, // Admin Sistem - Full access
  ketuaRT, // Ketua RT/RW - Dashboard, Data Warga, Notifikasi
  sekretaris, // Sekretaris - Dashboard, Data Warga, Notifikasi
  bendahara, // Bendahara - Keuangan, Dashboard
  warga, // Warga - Marketplace, Notifikasi, Riwayat Transaksi
}

// Extension untuk mendapatkan label role
extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.adminSistem:
        return 'Admin Sistem';
      case UserRole.ketuaRT:
        return 'Ketua RT/RW';
      case UserRole.sekretaris:
        return 'Sekretaris';
      case UserRole.bendahara:
        return 'Bendahara';
      case UserRole.warga:
        return 'Warga';
    }
  }

  String get value {
    switch (this) {
      case UserRole.adminSistem:
        return 'admin';
      case UserRole.ketuaRT:
        return 'ketua_rt';
      case UserRole.sekretaris:
        return 'sekretaris';
      case UserRole.bendahara:
        return 'bendahara';
      case UserRole.warga:
        return 'warga';
    }
  }

  // Parse dari string
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
      case 'admin_sistem':
        return UserRole.adminSistem;
      case 'ketua_rt':
      case 'ketua_rw':
        return UserRole.ketuaRT;
      case 'sekretaris':
        return UserRole.sekretaris;
      case 'bendahara':
        return UserRole.bendahara;
      case 'warga':
        return UserRole.warga;
      default:
        return UserRole.warga;
    }
  }
}

// Modul akses dalam sistem
enum AppModule {
  authentication, // A. Autentikasi & Otorisasi
  dataWarga, // B. Manajemen Data Warga
  keuangan, // C. Keuangan
  marketplace, // D. Marketplace
  notifikasi, // E. Notifikasi
  dashboard, // F. Dashboard & Reporting
}

// Permission untuk setiap modul
class ModulePermission {
  final AppModule module;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canExport;

  const ModulePermission({
    required this.module,
    this.canView = false,
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
    this.canExport = false,
  });

  // Full access
  const ModulePermission.fullAccess(this.module)
    : canView = true,
      canCreate = true,
      canEdit = true,
      canDelete = true,
      canExport = true;

  // Read only
  const ModulePermission.readOnly(this.module)
    : canView = true,
      canCreate = false,
      canEdit = false,
      canDelete = false,
      canExport = false;

  // View and export
  const ModulePermission.viewAndExport(this.module)
    : canView = true,
      canCreate = false,
      canEdit = false,
      canDelete = false,
      canExport = true;
}

// Role permissions mapping
class RolePermissions {
  static List<ModulePermission> getPermissions(UserRole role) {
    switch (role) {
      case UserRole.adminSistem:
        // Admin Sistem: Full access ke semua modul (A-F)
        return [
          const ModulePermission.fullAccess(AppModule.authentication),
          const ModulePermission.fullAccess(AppModule.dataWarga),
          const ModulePermission.fullAccess(AppModule.keuangan),
          const ModulePermission.fullAccess(AppModule.marketplace),
          const ModulePermission.fullAccess(AppModule.notifikasi),
          const ModulePermission.fullAccess(AppModule.dashboard),
        ];

      case UserRole.ketuaRT:
        // Ketua RT/RW: Dashboard (F), Data Warga (B), Notifikasi (E)
        return [
          const ModulePermission.readOnly(AppModule.authentication),
          const ModulePermission.fullAccess(AppModule.dataWarga),
          const ModulePermission.readOnly(AppModule.keuangan),
          const ModulePermission.readOnly(AppModule.marketplace),
          const ModulePermission.fullAccess(AppModule.notifikasi),
          const ModulePermission.viewAndExport(AppModule.dashboard),
        ];

      case UserRole.sekretaris:
        // Sekretaris: Dashboard (F), Data Warga (B), Notifikasi (E)
        return [
          const ModulePermission.readOnly(AppModule.authentication),
          const ModulePermission.fullAccess(AppModule.dataWarga),
          const ModulePermission.readOnly(AppModule.keuangan),
          const ModulePermission.readOnly(AppModule.marketplace),
          const ModulePermission.fullAccess(AppModule.notifikasi),
          const ModulePermission.viewAndExport(AppModule.dashboard),
        ];

      case UserRole.bendahara:
        // Bendahara: Keuangan (C), Dashboard (F)
        return [
          const ModulePermission.readOnly(AppModule.authentication),
          const ModulePermission.readOnly(AppModule.dataWarga),
          const ModulePermission.fullAccess(AppModule.keuangan),
          const ModulePermission.readOnly(AppModule.marketplace),
          const ModulePermission.readOnly(AppModule.notifikasi),
          const ModulePermission.viewAndExport(AppModule.dashboard),
        ];

      case UserRole.warga:
        // Warga: Marketplace (D), Notifikasi (E), Riwayat Transaksi (C - read only)
        return [
          const ModulePermission.readOnly(AppModule.authentication),
          const ModulePermission.readOnly(AppModule.dataWarga),
          ModulePermission(
            module: AppModule.keuangan,
            canView: true, // Hanya lihat riwayat transaksi sendiri
            canCreate: false,
            canEdit: false,
            canDelete: false,
            canExport: false,
          ),
          const ModulePermission.fullAccess(AppModule.marketplace),
          const ModulePermission.readOnly(AppModule.notifikasi),
          const ModulePermission.readOnly(AppModule.dashboard),
        ];
    }
  }

  // Check if role has permission for specific module and action
  static bool hasPermission(
    UserRole role,
    AppModule module, {
    bool view = false,
    bool create = false,
    bool edit = false,
    bool delete = false,
    bool export = false,
  }) {
    final permissions = getPermissions(role);
    final modulePermission = permissions.firstWhere(
      (p) => p.module == module,
      orElse: () => ModulePermission(module: module),
    );

    if (view && !modulePermission.canView) return false;
    if (create && !modulePermission.canCreate) return false;
    if (edit && !modulePermission.canEdit) return false;
    if (delete && !modulePermission.canDelete) return false;
    if (export && !modulePermission.canExport) return false;

    return true;
  }

  // Get accessible modules for role
  static List<AppModule> getAccessibleModules(UserRole role) {
    return getPermissions(
      role,
    ).where((p) => p.canView).map((p) => p.module).toList();
  }
}
