import 'package:jawara/models/user_role.dart';

class RoleHelper {
  // Mendapatkan dashboard route berdasarkan role
  static String getDashboardRoute(UserRole role) {
    switch (role) {
      case UserRole.adminSistem:
        return '/admin-dashboard';
      case UserRole.ketuaRT:
        return '/ketua-rt-dashboard';
      case UserRole.sekretaris:
        return '/sekretaris-dashboard';
      case UserRole.bendahara:
        return '/bendahara-dashboard';
      case UserRole.warga:
        return '/warga-dashboard';
    }
  }

  // Cek apakah role memiliki akses ke fitur tertentu
  static bool hasAccess(UserRole role, String feature) {
    switch (feature) {
      case 'data_warga':
        return [UserRole.adminSistem, UserRole.ketuaRT, UserRole.sekretaris].contains(role);
      case 'keuangan_full':
        return [UserRole.adminSistem, UserRole.bendahara].contains(role);
      case 'keuangan_view':
        return [UserRole.adminSistem, UserRole.bendahara, UserRole.warga].contains(role);
      case 'marketplace':
        return [UserRole.adminSistem, UserRole.warga].contains(role);
      case 'laporan':
        return [UserRole.adminSistem, UserRole.bendahara, UserRole.ketuaRT, UserRole.sekretaris].contains(role);
      case 'manajemen_sistem':
        return role == UserRole.adminSistem;
      default:
        return false;
    }
  }

  // Mendapatkan fitur yang tersedia untuk role
  static List<String> getAvailableFeatures(UserRole role) {
    List<String> features = [];
    
    // Dashboard selalu ada
    features.add('dashboard');
    
    // Data Warga & Rumah
    if (hasAccess(role, 'data_warga')) {
      features.add('data_warga');
    }
    
    // Keuangan
    if (hasAccess(role, 'keuangan_full')) {
      features.add('keuangan_full');
    } else if (hasAccess(role, 'keuangan_view')) {
      features.add('keuangan_view');
    }
    
    // Marketplace
    if (hasAccess(role, 'marketplace')) {
      features.add('marketplace');
    }
    
    // Laporan
    if (hasAccess(role, 'laporan')) {
      features.add('laporan');
    }
    
    // Manajemen Sistem
    if (hasAccess(role, 'manajemen_sistem')) {
      features.add('manajemen_sistem');
    }
    
    // Pesan & Notifikasi (semua role kecuali bendahara)
    if (role != UserRole.bendahara) {
      features.add('pesan');
    }
    
    return features;
  }
}