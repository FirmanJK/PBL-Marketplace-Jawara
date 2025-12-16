import 'package:flutter/material.dart';
import 'package:jawara/widgets/user_info_widget.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/pages/messages/resident_messages.dart';

class SekretarisDashboardPage extends StatefulWidget {
  const SekretarisDashboardPage({super.key});

  @override
  State<SekretarisDashboardPage> createState() => _SekretarisDashboardPageState();
}

class _SekretarisDashboardPageState extends State<SekretarisDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SekretarisHomePage(),
    const SekretarisDataPage(),
    const CitizenMessagesPage(),
    const SekretarisProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF0891B2),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 0,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Data Warga',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Pesan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Akun',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SekretarisHomePage extends StatelessWidget {
  const SekretarisHomePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JAWARA',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info - Temporarily disabled to isolate null check error
              // const UserInfoWidget(),
              // const SizedBox(height: 16),
              
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0891B2).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang, Sekretaris',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kelola data warga dan administrasi RT/RW',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Kegiatan Section
              const Text(
                'Kegiatan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'Daftar Kegiatan',
                    Icons.list_alt,
                    const Color(0xFF0891B2),
                    '/activities/list',
                  ),
                  _buildFeatureCard(
                    context,
                    'Tambah Kegiatan',
                    Icons.add_circle,
                    const Color(0xFF0891B2),
                    '/activities/add',
                  ),
                  _buildFeatureCard(
                    context,
                    'Broadcast',
                    Icons.campaign,
                    const Color(0xFF10B981),
                    '/broadcast/list',
                  ),
                  _buildFeatureCard(
                    context,
                    'Tambah Broadcast',
                    Icons.add_box,
                    const Color(0xFFF59E0B),
                    '/broadcast/add',
                  ),
                ],
              ),
              

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pencarian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cari warga, keluarga, atau rumah...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                Navigator.pop(context);
                if (value.isNotEmpty) {
                  _performSearch(context, value);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/residents/list');
                    },
                    icon: const Icon(Icons.people),
                    label: const Text('Cari Warga'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/families');
                    },
                    icon: const Icon(Icons.family_restroom),
                    label: const Text('Cari Keluarga'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  static void _performSearch(BuildContext context, String query) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hasil Pencarian: "$query"'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Tidak ada hasil ditemukan'),
              subtitle: Text('Coba kata kunci lain'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/residents/list');
            },
            child: const Text('Lihat Semua Warga'),
          ),
        ],
      ),
    );
  }
}

class SekretarisDataPage extends StatefulWidget {
  const SekretarisDataPage({super.key});

  @override
  State<SekretarisDataPage> createState() => _SekretarisDataPageState();
}

class _SekretarisDataPageState extends State<SekretarisDataPage> {
  
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifikasi Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              'Data Baru',
              'Ada 5 warga baru yang perlu diverifikasi',
              '2 jam yang lalu',
              Icons.person_add,
              Colors.blue,
            ),
            _buildNotificationItem(
              'Update Data',
              'Data keluarga telah diperbarui',
              '5 jam yang lalu',
              Icons.family_restroom,
              Colors.green,
            ),
            _buildNotificationItem(
              'Mutasi',
              'Ada permintaan mutasi keluarga baru',
              '1 hari yang lalu',
              Icons.swap_horiz,
              Colors.orange,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'refresh':
        _showRefreshDialog(context);
        break;
      case 'filter':
        _showFilterDialog(context);
        break;
      case 'sort':
        _showSortDialog(context);
        break;
      case 'export':
        _showExportDialog(context);
        break;
      case 'settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'help':
        Navigator.pushNamed(context, '/help');
        break;
      case 'about':
        Navigator.pushNamed(context, '/about');
        break;
    }
  }

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.refresh, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Refresh Data'),
          ],
        ),
        content: const Text('Apakah Anda ingin memperbarui data warga?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data warga berhasil diperbarui'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
            child: const Text('Refresh', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.filter_list, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Filter Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Data Warga'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
            CheckboxListTile(
              title: const Text('Data Keluarga'),
              value: false,
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
            CheckboxListTile(
              title: const Text('Data Rumah'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter berhasil diterapkan'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
            child: const Text('Terapkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.sort, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Urutkan Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Nama A-Z'),
              value: 'name_asc',
              groupValue: 'name_asc',
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
            RadioListTile<String>(
              title: const Text('Nama Z-A'),
              value: 'name_desc',
              groupValue: 'name_asc',
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
            RadioListTile<String>(
              title: const Text('Tanggal Terbaru'),
              value: 'date_desc',
              groupValue: 'name_asc',
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengurutan berhasil diterapkan'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
            child: const Text('Terapkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.download, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Export Data'),
          ],
        ),
        content: const Text('Pilih format export data warga:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil diexport ke PDF'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('PDF', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil diexport ke Excel'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Excel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen Data',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Notification Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => _showNotifications(context),
                tooltip: 'Notifikasi',
              ),
              // Notification Badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          
          // Dropdown Menu (Three Dots)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            tooltip: 'Menu',
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Refresh Data', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(Icons.filter_list, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Filter Data', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Urutkan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Export Data', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Pengaturan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Bantuan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Tentang', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            icon: Icons.people_outlined,
            title: 'Data Warga',
            subtitle: 'Lihat dan kelola data warga',
            color: const Color(0xFF3B82F6),
            route: '/residents/list',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.person_add_outlined,
            title: 'Tambah Warga',
            subtitle: 'Daftarkan warga baru',
            color: const Color(0xFF10B981),
            route: '/residents/add',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.family_restroom_outlined,
            title: 'Data Keluarga',
            subtitle: 'Kelola data keluarga',
            color: const Color(0xFF8B5CF6),
            route: '/families',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.home_outlined,
            title: 'Data Rumah',
            subtitle: 'Kelola data rumah warga',
            color: const Color(0xFFF59E0B),
            route: '/houses/list',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.swap_horiz_outlined,
            title: 'Mutasi Keluarga',
            subtitle: 'Proses mutasi keluarga',
            color: const Color(0xFFEC4899),
            route: '/mutations/list',
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.how_to_reg_outlined,
            title: 'Penerimaan Warga',
            subtitle: 'Verifikasi warga baru',
            color: const Color(0xFF14B8A6),
            route: '/resident-approvals',
          ),
        ],
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SekretarisPesanPage extends StatefulWidget {
  const SekretarisPesanPage({super.key});

  @override
  State<SekretarisPesanPage> createState() => _SekretarisPesanPageState();
}

class _SekretarisPesanPageState extends State<SekretarisPesanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Komunikasi & Pesan'),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMessageCard(
              context,
              'Notifikasi & Pesan',
              Icons.notifications,
              const Color(0xFF14B8A6),
              '/notifications',
            ),
            _buildMessageCard(
              context,
              'Broadcast',
              Icons.campaign,
              const Color(0xFFF59E0B),
              '/broadcast/list',
            ),
            _buildMessageCard(
              context,
              'Buat Broadcast',
              Icons.add_circle,
              const Color(0xFF10B981),
              '/broadcast/add',
            ),
            _buildMessageCard(
              context,
              'Notifikasi',
              Icons.notifications,
              const Color(0xFFEC4899),
              '/notifications',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SekretarisProfilPage extends StatefulWidget {
  const SekretarisProfilPage({super.key});

  @override
  State<SekretarisProfilPage> createState() => _SekretarisProfilPageState();
}

class _SekretarisProfilPageState extends State<SekretarisProfilPage> {
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
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
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
                              user?.name ?? 'Sekretaris',
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
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _MenuItem(
                    icon: Icons.lock_outline,
                    label: 'Ganti Password',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
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
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal keluar: ${e.toString()}')),
        );
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
