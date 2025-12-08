import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // State untuk setiap menu yang memiliki sub-menu
  bool _isDashboardExpanded = false;
  bool _isResidentsExpanded = false;
  bool _isIncomeExpanded = false;
  bool _isSpendingExpanded = false;
  bool _isFinancialReportExpanded = false;
  bool _isActivitiesExpanded = false;
  bool _isMessagesExpanded = false;
  bool _isApprovalExpanded = false;
  bool _isFamilyMutationExpanded = false;
  bool _isActivityLogExpanded = false;
  bool _isUserManagementExpanded = false;
  bool _isChannelTransferExpanded = false;
  bool _isMarketplaceExpanded = false;

  void _closeAllMenusExcept(String menuName) {
    setState(() {
      if (menuName != 'dashboard') _isDashboardExpanded = false;
      if (menuName != 'residents') _isResidentsExpanded = false;
      if (menuName != 'income') _isIncomeExpanded = false;
      if (menuName != 'spending') _isSpendingExpanded = false;
      if (menuName != 'financialReport') _isFinancialReportExpanded = false;
      if (menuName != 'activities') _isActivitiesExpanded = false;
      if (menuName != 'messages') _isMessagesExpanded = false;
      if (menuName != 'approval') _isApprovalExpanded = false;
      if (menuName != 'familyMutation') _isFamilyMutationExpanded = false;
      if (menuName != 'activityLog') _isActivityLogExpanded = false;
      if (menuName != 'userManagement') _isUserManagementExpanded = false;
      if (menuName != 'channelTransfer') _isChannelTransferExpanded = false;
      if (menuName != 'marketplace') _isMarketplaceExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header dengan SafeArea
            Container(
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
              child: Row(
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jawara Pintar',
                          style: TextStyle(
                            color: Color(0xFF0891B2),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Sistem RT Modern',
                          style: TextStyle(
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
            ),

            // Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Dashboard
                  _buildMenuItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    isExpanded: _isDashboardExpanded,
                    onTap: () {
                      _closeAllMenusExcept('dashboard');
                      setState(
                        () => _isDashboardExpanded = !_isDashboardExpanded,
                      );
                    },
                  ),
                  if (_isDashboardExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.account_balance_wallet_rounded,
                      title: 'Keuangan',
                      route: '/dashboard/finance',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.event_note_rounded,
                      title: 'Kegiatan',
                      route: '/dashboard/activities',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.people_alt_rounded,
                      title: 'Kependudukan',
                      route: '/dashboard/population',
                    ),
                  ],

                  // Data Warga & Rumah
                  _buildMenuItem(
                    icon: Icons.people_rounded,
                    title: 'Data Warga & Rumah',
                    isExpanded: _isResidentsExpanded,
                    onTap: () {
                      _closeAllMenusExcept('residents');
                      setState(
                        () => _isResidentsExpanded = !_isResidentsExpanded,
                      );
                    },
                  ),
                  if (_isResidentsExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Warga - Daftar',
                      route: '/residents/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.person_add_rounded,
                      title: 'Warga - Tambah',
                      route: '/residents/add',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.family_restroom_rounded,
                      title: 'Keluarga',
                      route: '/families',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.home_outlined,
                      title: 'Rumah - Daftar',
                      route: '/houses/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.add_home_rounded,
                      title: 'Rumah - Tambah',
                      route: '/houses/add',
                    ),
                  ],

                  // Pemasukan
                  _buildMenuItem(
                    icon: Icons.attach_money_rounded,
                    title: 'Pemasukan',
                    isExpanded: _isIncomeExpanded,
                    onTap: () {
                      _closeAllMenusExcept('income');
                      setState(() => _isIncomeExpanded = !_isIncomeExpanded);
                    },
                  ),
                  if (_isIncomeExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.list_alt_rounded,
                      title: 'Iuran - Daftar',
                      route: '/income/bills',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.receipt_long_rounded,
                      title: 'Iuran - Detail',
                      route: '/income/bill',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.category_rounded,
                      title: 'Kategori Iuran',
                      route: '/income/categories',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.payments_rounded,
                      title: 'Pemasukan Lain',
                      route: '/income/other/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.add_circle_outline_rounded,
                      title: 'Tambah Pemasukan Lain',
                      route: '/income/other/add',
                    ),
                  ],

                  // Pengeluaran
                  _buildMenuItem(
                    icon: Icons.money_off_rounded,
                    title: 'Pengeluaran',
                    isExpanded: _isSpendingExpanded,
                    onTap: () {
                      _closeAllMenusExcept('spending');
                      setState(
                        () => _isSpendingExpanded = !_isSpendingExpanded,
                      );
                    },
                  ),
                  if (_isSpendingExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.format_list_bulleted_rounded,
                      title: 'Daftar Pengeluaran',
                      route: '/spending/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.add_shopping_cart_rounded,
                      title: 'Tambah Pengeluaran',
                      route: '/spending/add',
                    ),
                  ],

                  // Laporan Keuangan
                  _buildMenuItem(
                    icon: Icons.assessment_rounded,
                    title: 'Laporan Keuangan',
                    isExpanded: _isFinancialReportExpanded,
                    onTap: () {
                      _closeAllMenusExcept('financialReport');
                      setState(
                        () => _isFinancialReportExpanded =
                            !_isFinancialReportExpanded,
                      );
                    },
                  ),
                  if (_isFinancialReportExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.trending_up_rounded,
                      title: 'Laporan Pemasukan',
                      route: '/reports/income',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.trending_down_rounded,
                      title: 'Laporan Pengeluaran',
                      route: '/reports/spending',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.print_rounded,
                      title: 'Cetak Laporan',
                      route: '/reports/print',
                    ),
                  ],

                  // Kegiatan & Broadcast
                  _buildMenuItem(
                    icon: Icons.event_available_rounded,
                    title: 'Kegiatan & Broadcast',
                    isExpanded: _isActivitiesExpanded,
                    onTap: () {
                      _closeAllMenusExcept('activities');
                      setState(
                        () => _isActivitiesExpanded = !_isActivitiesExpanded,
                      );
                    },
                  ),
                  if (_isActivitiesExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.event_rounded,
                      title: 'Daftar Kegiatan',
                      route: '/activities/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.add_task_rounded,
                      title: 'Tambah Kegiatan',
                      route: '/activities/add',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.campaign_rounded,
                      title: 'Daftar Broadcast',
                      route: '/broadcast/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.send_rounded,
                      title: 'Buat Broadcast',
                      route: '/broadcast/add',
                    ),
                  ],

                  // Pesan Warga
                  _buildMenuItem(
                    icon: Icons.message_rounded,
                    title: 'Pesan Warga',
                    isExpanded: _isMessagesExpanded,
                    onTap: () {
                      _closeAllMenusExcept('messages');
                      setState(
                        () => _isMessagesExpanded = !_isMessagesExpanded,
                      );
                    },
                  ),
                  if (_isMessagesExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Semua Pesan',
                      route: '/messages',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.lightbulb_outline_rounded,
                      title: 'Aspirasi',
                      route: '/messages/aspirations',
                    ),
                  ],

                  // Penerimaan Warga
                  _buildMenuItem(
                    icon: Icons.how_to_reg_rounded,
                    title: 'Penerimaan Warga',
                    isExpanded: _isApprovalExpanded,
                    onTap: () {
                      _closeAllMenusExcept('approval');
                      setState(
                        () => _isApprovalExpanded = !_isApprovalExpanded,
                      );
                    },
                  ),
                  if (_isApprovalExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.approval_rounded,
                      title: 'Daftar Permohonan',
                      route: '/resident-approvals',
                    ),
                  ],

                  // Mutasi Keluarga
                  _buildMenuItem(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Mutasi Keluarga',
                    isExpanded: _isFamilyMutationExpanded,
                    onTap: () {
                      _closeAllMenusExcept('familyMutation');
                      setState(
                        () => _isFamilyMutationExpanded =
                            !_isFamilyMutationExpanded,
                      );
                    },
                  ),
                  if (_isFamilyMutationExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.list_rounded,
                      title: 'Daftar Mutasi',
                      route: '/family-mutations/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.add_rounded,
                      title: 'Tambah Mutasi',
                      route: '/family-mutations/add',
                    ),
                  ],

                  // Log Aktivitas
                  _buildMenuItem(
                    icon: Icons.history_rounded,
                    title: 'Log Aktivitas',
                    isExpanded: _isActivityLogExpanded,
                    onTap: () {
                      _closeAllMenusExcept('activityLog');
                      setState(
                        () => _isActivityLogExpanded = !_isActivityLogExpanded,
                      );
                    },
                  ),
                  if (_isActivityLogExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.view_list_rounded,
                      title: 'Daftar Log',
                      route: '/activity-logs',
                    ),
                  ],

                  // Manajemen Pengguna
                  _buildMenuItem(
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Manajemen Pengguna',
                    isExpanded: _isUserManagementExpanded,
                    onTap: () {
                      _closeAllMenusExcept('userManagement');
                      setState(
                        () => _isUserManagementExpanded =
                            !_isUserManagementExpanded,
                      );
                    },
                  ),
                  if (_isUserManagementExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.group_rounded,
                      title: 'Daftar Pengguna',
                      route: '/users',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.person_add_alt_rounded,
                      title: 'Tambah Pengguna',
                      route: '/users/add',
                    ),
                  ],

                  // Channel Transfer
                  _buildMenuItem(
                    icon: Icons.compare_arrows_rounded,
                    title: 'Channel Transfer',
                    isExpanded: _isChannelTransferExpanded,
                    onTap: () {
                      _closeAllMenusExcept('channelTransfer');
                      setState(
                        () => _isChannelTransferExpanded =
                            !_isChannelTransferExpanded,
                      );
                    },
                  ),
                  if (_isChannelTransferExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.list_alt_rounded,
                      title: 'Daftar Channel',
                      route: '/channels/list',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.add_box_rounded,
                      title: 'Tambah Channel',
                      route: '/channels/add',
                    ),
                  ],

                  // Marketplace
                  _buildMenuItem(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Marketplace',
                    isExpanded: _isMarketplaceExpanded,
                    onTap: () {
                      _closeAllMenusExcept('marketplace');
                      setState(
                        () => _isMarketplaceExpanded = !_isMarketplaceExpanded,
                      );
                    },
                  ),
                  if (_isMarketplaceExpanded) ...[
                    _buildSubMenuItem(
                      icon: Icons.camera_alt_rounded,
                      title: 'Unggah Produk',
                      route: '/marketplace/upload',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.grid_view_rounded,
                      title: 'Katalog Produk',
                      route: '/marketplace/catalog',
                    ),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isExpanded
            ? const Color(0xFF0891B2).withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isExpanded ? const Color(0xFF0891B2) : const Color(0xFF6B7280),
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isExpanded
                ? const Color(0xFF1F2937)
                : const Color(0xFF4B5563),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: isExpanded ? const Color(0xFF0891B2) : const Color(0xFF6B7280),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 12, top: 2, bottom: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
          Navigator.pop(context); // Close drawer
          Navigator.pushNamed(context, route);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
