import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class UserMenuHelper {
  static void showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User Info Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0891B2).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF0891B2),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Sistem',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'admin@jawara.com',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),

              // Profile Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF0891B2),
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Profil',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),

              // Settings Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF0891B2),
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Pengaturan',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),

              const Divider(height: 1),

              // Logout Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Keluar',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showLogoutConfirmation(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                print('🔐 Logout from UserMenuHelper');
                Navigator.pop(context); // Close dialog
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              } catch (e) {
                print('❌ Logout error: $e');
                if (context.mounted) {
                  ToastHelper.showError(
                    context,
                    'Error logout: ${e.toString()}',
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  static Widget buildUserIconButton(BuildContext context) {
    return IconButton(
      onPressed: () => showProfileMenu(context),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFF0891B2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 20),
      ),
      tooltip: 'Profil',
    );
  }
}
