import 'package:flutter/material.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/services/auth_service.dart';

class RoleBasedSidebar extends StatelessWidget {
  const RoleBasedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    if (currentUser == null) {
      return const Drawer(child: Center(child: Text('Not logged in')));
    }

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            _buildHeader(currentUser.name, currentUser.role),
            
            // Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _buildMenuItems(context, currentUser.role),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String userName, UserRole role) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0891B2).withOpacity(0.1),
            const Color(0xFF0284C7).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0891B2), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0891B2).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.book_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jawara Pintar',
                      style: TextStyle(
                        color: Color(0xFF0891B2),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role.label,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context, UserRole role) {
    final authService = AuthService();
    final List<Widget> menuItems = [];

    // Dashboard - Semua role kecuali warga biasa bisa akses penuh
    if (authService.hasPermission(AppModule.dashboard, view: true)) {
      menuItems.add(_buildMenuItem(
        icon: Icons.dashboard_rounded,
        title: 'Dashboard',
        route: '/dashboard/finance',
        context: context,
      ));
      menuItems.add(const Divider(height: 16));
    }

    // Data Warga & Rumah - Admin, Ketua RT, Sekretaris
    if (authService.hasPermission(AppModule.dataWarga, view: true)) {
      menuItems.add(_buildExpandableMenu(
        icon: Icons.people_rounded,
        title: 'Data Warga & Rumah',
        children: [
          _buildSubMenuItem(
            icon: Icons.person_outline_rounded,
            title: 'Warga - Daftar',
            route: '/residents/list',
            context: context,
          ),
          if (authService.hasPermission(AppModule.dataWarga, create: true))
            _buildSubMenuItem(
              icon: Icons.person_add_rounded,
              title: 'Warga - Tambah',
              route: '/residents/add',
              context: context,
            ),
          _buildSubMenuItem(
            icon: Icons.family_restroom_rounded,
            title: 'Keluarga',
            route: '/families',
            context: context,
          ),
          _buildSubMenuItem(
            icon: Icons.home_outlined,
            title: 'Rumah - Daftar',
            route: '/houses/list',
            context: context,
          ),
          if (authService.hasPermission(AppModule.dataWarga, create: true))
            _buildSubMenuItem(
              icon: Icons.add_home_rounded,
              title: 'Rumah - Tambah',
              route: '/houses/add',
              context: context,
            ),
        ],
      ));
      menuItems.add(const Divider(height: 16));
    }

    // Keuangan - Admin, Bendahara (full), Warga (read only riwayat)
    if (authService.hasPermission(AppModule.keuangan, view: true)) {
      final canManage = authService.hasPermission(AppModule.keuangan, create: true);
      
      menuItems.add(_buildExpandableMenu(
        icon: Icons.account_balance_wallet_rounded,
        title: 'Keuangan',
        children: [
          if (canManage) ...[
            _buildSubMenuItem(
              icon: Icons.list_alt_rounded,
              title: 'Iuran - Daftar',
              route: '/income/bills',
              context: context,
            ),
            _buildSubMenuItem(
              icon: Icons.category_rounded,
              title: 'Kategori Iuran',
              route: '/income/categories',
              context: context,
            ),
            _buildSubMenuItem(
              icon: Icons.format_list_bulleted_rounded,
              title: 'Daftar Pengeluaran',
              route: '/spending/list',
              context: context,
            ),
            _buildSubMenuItem(
              icon: Icons.add_shopping_cart_rounded,
              title: 'Tambah Pengeluaran',
              route: '/spending/add',
              context: context,
            ),
          ] else ...[
            // Warga hanya bisa lihat riwayat transaksi sendiri
            _buildSubMenuItem(
              icon: Icons.history_rounded,
              title: 'Riwayat Transaksi',
              route: '/income/bills',
              context: context,
            ),
          ],
        ],
      ));
      menuItems.add(const Divider(height: 16));
    }

    // Marketplace - Admin (full), Warga (full)
    if (authService.hasPermission(AppModule.marketplace, view: true)) {
      menuItems.add(_buildExpandableMenu(
        icon: Icons.shopping_bag_rounded,
        title: 'Marketplace',
        children: [
          if (authService.hasPermission(AppModule.marketplace, create: true))
            _buildSubMenuItem(
              icon: Icons.camera_alt_rounded,
              title: 'Unggah Produk',
              route: '/marketplace/upload',
              context: context,
            ),
          _buildSubMenuItem(
            icon: Icons.grid_view_rounded,
            title: 'Katalog Produk',
            route: '/marketplace/catalog',
            context: context,
          ),
        ],
      ));
      menuItems.add(const Divider(height: 16));
    }

    // Notifikasi - Admin, Ketua RT, Sekretaris (full), Warga (read only)
    if (authService.hasPermission(AppModule.notifikasi, view: true)) {
      menuItems.add(_buildExpandableMenu(
        icon: Icons.notifications_rounded,
        title: 'Notifikasi & Pesan',
        children: [
          _buildSubMenuItem(
            icon: Icons.message_rounded,
            title: 'Pesan Warga',
            route: '/messages',
            context: context,
          ),
          if (authService.hasPermission(AppModule.notifikasi, create: true))
            _buildSubMenuItem(
              icon: Icons.campaign_rounded,
              title: 'Broadcast',
              route: '/broadcast/list',
              context: context,
            ),
        ],
      ));
      menuItems.add(const Divider(height: 16));
    }

    // Laporan - Admin, Bendahara, Ketua RT, Sekretaris
    if (authService.hasPermission(AppModule.dashboard, export: true)) {
      menuItems.add(_buildExpandableMenu(
        icon: Icons.assessment_rounded,
        title: 'Laporan',
        children: [
          _buildSubMenuItem(
            icon: Icons.trending_up_rounded,
            title: 'Laporan Pemasukan',
            route: '/reports/income',
            context: context,
          ),
          _buildSubMenuItem(
            icon: Icons.trending_down_rounded,
            title: 'Laporan Pengeluaran',
            route: '/reports/spending',
            context: context,
          ),
          _buildSubMenuItem(
            icon: Icons.print_rounded,
            title: 'Cetak Laporan',
            route: '/reports/print',
            context: context,
          ),
        ],
      ));
      menuItems.add(const Divider(height: 16));
    }

    // Admin only menus
    if (role == UserRole.adminSistem) {
      menuItems.add(_buildExpandableMenu(
        icon: Icons.admin_panel_settings_rounded,
        title: 'Manajemen Sistem',
        children: [
          _buildSubMenuItem(
            icon: Icons.group_rounded,
            title: 'Manajemen Pengguna',
            route: '/users',
            context: context,
          ),
          _buildSubMenuItem(
            icon: Icons.history_rounded,
            title: 'Log Aktivitas',
            route: '/activity-logs',
            context: context,
          ),
        ],
      ));
    }

    return menuItems;
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0891B2), size: 22),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildExpandableMenu({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: const Color(0xFF0891B2), size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      children: children,
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 12, top: 2, bottom: 2),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF6B7280), size: 18),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
