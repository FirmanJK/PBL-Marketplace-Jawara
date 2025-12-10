import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan user info
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Pengguna',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? 'email@example.com',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: const Icon(
                          Icons.logout,
                          color: Color(0xFFEF4444),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Menu Akun
              _buildMenuSection(
                title: 'Akun',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    label: 'Informasi Akun',
                    color: const Color(0xFF0891B2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.lock_outline,
                    label: 'Ganti Password',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Pengaturan',
                    color: const Color(0xFF06B6D4),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Menu Bantuan & Informasi
              _buildMenuSection(
                title: 'Bantuan & Informasi',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Bantuan',
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    label: 'Tentang Aplikasi',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // App Version Info
              Center(
                child: Text(
                  'Jawara Pintar v1.0.0',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        ...List.generate(items.length, (index) => _buildMenuItem(items[index])),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: item.color, size: 24),
        ),
        title: Text(
          item.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: item.onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _performLogout(context);
              },
              child: const Text(
                'Keluar',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      await _authService.logout();

      if (mounted) {
        ToastHelper.showSuccess(context, 'Berhasil keluar');
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Gagal keluar: ${e.toString()}');
      }
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
