import 'package:flutter/material.dart';
import 'package:jawara/pages/marketplace/marketplace_catalog_page.dart';
import 'package:jawara/pages/marketplace/marketplace_upload_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedOption = 'catalog'; // 'upload' atau 'catalog'

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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedOption == 'upload'
            ? const MarketplaceUploadPage(key: ValueKey('upload'))
            : const MarketplaceCatalogPage(key: ValueKey('catalog')),
      ),
    );
  }
}
