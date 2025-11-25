import 'package:flutter/material.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/pages/marketplace_catalog_page.dart';
import 'package:jawara/pages/marketplace_upload_page.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/shared/role_guard.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedOption = 'upload'; // 'upload' atau 'catalog'

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cek route untuk menentukan halaman awal
    final route = ModalRoute.of(context)?.settings.name;
    if (route == '/marketplace/catalog') {
      _selectedOption = 'catalog';
    } else if (route == '/marketplace/upload') {
      _selectedOption = 'upload';
    }
  }

  void _showProfileMenu(BuildContext context) {
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
              // Profile Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withOpacity(0.1),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              const Divider(height: 1),
              
              // Settings Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withOpacity(0.1),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
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
                    color: Colors.red.withOpacity(0.1),
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
                  _showLogoutConfirmation(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
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
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace Warga'),
        actions: [
          // Dropdown untuk memilih mode
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF0891B2)),
            ),
            child: DropdownButton<String>(
              value: _selectedOption,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0891B2)),
              style: const TextStyle(
                color: Color(0xFF0891B2),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'upload',
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, size: 18, color: Color(0xFF0891B2)),
                      SizedBox(width: 8),
                      Text('Unggah Produk'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'catalog',
                  child: Row(
                    children: [
                      Icon(Icons.grid_view, size: 18, color: Color(0xFF0891B2)),
                      SizedBox(width: 8),
                      Text('Katalog Produk'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedOption = value);
                }
              },
            ),
          ),
          
          // Profile Icon Button
          IconButton(
            onPressed: () => _showProfileMenu(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0891B2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
            tooltip: 'Profil',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedOption == 'upload'
            ? const MarketplaceUploadPage(key: ValueKey('upload'))
            : const MarketplaceCatalogPage(key: ValueKey('catalog')),
      ),
    );
  }
}
