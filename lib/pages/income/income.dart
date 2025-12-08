import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Pemasukan'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              icon: Icons.category_outlined,
              title: 'Kategori Iuran',
              subtitle: 'Kelola kategori iuran',
              color: const Color(0xFF10B981),
              route: '/income/categories',
            ),
            _buildMenuCard(
              context,
              icon: Icons.receipt_long_outlined,
              title: 'Tagih Iuran',
              subtitle: 'Buat tagihan iuran',
              color: const Color(0xFF3B82F6),
              route: '/income/bill',
            ),
            _buildMenuCard(
              context,
              icon: Icons.list_alt_outlined,
              title: 'Daftar Tagihan',
              subtitle: 'Lihat semua tagihan',
              color: const Color(0xFF8B5CF6),
              route: '/income/bills',
            ),
            _buildMenuCard(
              context,
              icon: Icons.attach_money_outlined,
              title: 'Pemasukan Lain',
              subtitle: 'Daftar pemasukan lain',
              color: const Color(0xFFF59E0B),
              route: '/income/other/list',
            ),
            _buildMenuCard(
              context,
              icon: Icons.add_circle_outline,
              title: 'Tambah Pemasukan',
              subtitle: 'Tambah pemasukan lain',
              color: const Color(0xFF0891B2),
              route: '/income/other/add',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
