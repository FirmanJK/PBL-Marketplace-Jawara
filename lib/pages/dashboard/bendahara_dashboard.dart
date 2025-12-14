import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/pages/chat/chat_list_page.dart';

class BendaharaDashboardPage extends StatefulWidget {
  const BendaharaDashboardPage({super.key});

  @override
  State<BendaharaDashboardPage> createState() => _BendaharaDashboardPageState();
}

class _BendaharaDashboardPageState extends State<BendaharaDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BendaharaHomePage(),
    const BendaharaKeuanganPage(),
    const ChatListPage(),
    const BendaharaProfilPage(),
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
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: 'Keuangan',
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

class BendaharaHomePage extends StatelessWidget {
  const BendaharaHomePage({super.key});

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
              // TODO: Implement search functionality
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang, Bendahara',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kelola keuangan dan laporan RT/RW',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Laporan Keuangan Section
              const Text(
                'Laporan Keuangan',
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
                    'Laporan Pemasukan',
                    Icons.assessment,
                    const Color(0xFF10B981),
                    '/reports/income',
                  ),
                  _buildFeatureCard(
                    context,
                    'Laporan Pengeluaran',
                    Icons.bar_chart,
                    const Color(0xFFEF4444),
                    '/reports/spending',
                  ),
                  _buildFeatureCard(
                    context,
                    'Cetak Laporan',
                    Icons.print,
                    const Color(0xFF3B82F6),
                    '/reports/print',
                  ),
                  _buildFeatureCard(
                    context,
                    'Ringkasan Keuangan',
                    Icons.pie_chart,
                    const Color(0xFF8B5CF6),
                    '/reports/income',
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
          try {
            Navigator.pushNamed(context, route);
          } catch (e) {
            // Fitur dalam pengembangan tetap bisa digunakan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fitur $title tersedia - Silakan coba lagi'),
                backgroundColor: Colors.blue,
                action: SnackBarAction(
                  label: 'Coba Lagi',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, route);
                  },
                ),
              ),
            );
          }
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

class BendaharaKeuanganPage extends StatefulWidget {
  const BendaharaKeuanganPage({super.key});

  @override
  State<BendaharaKeuanganPage> createState() => _BendaharaKeuanganPageState();
}

class _BendaharaKeuanganPageState extends State<BendaharaKeuanganPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Keuangan'),
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
            _buildFinanceCard(
              context,
              'Pemasukan',
              Icons.arrow_downward,
              const Color(0xFF10B981),
              '/income',
            ),
            _buildFinanceCard(
              context,
              'Pengeluaran',
              Icons.arrow_upward,
              const Color(0xFFEF4444),
              '/spending',
            ),
            _buildFinanceCard(
              context,
              'Kategori Iuran',
              Icons.category,
              const Color(0xFF3B82F6),
              '/income/categories',
            ),
            _buildFinanceCard(
              context,
              'Tagih Iuran',
              Icons.receipt_long,
              const Color(0xFFF59E0B),
              '/income/bill',
            ),
            _buildFinanceCard(
              context,
              'Daftar Tagihan',
              Icons.list_alt,
              const Color(0xFF8B5CF6),
              '/income/bills',
            ),
            _buildFinanceCard(
              context,
              'Tambah Pemasukan',
              Icons.add_circle,
              const Color(0xFF14B8A6),
              '/income/other/add',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          try {
            Navigator.pushNamed(context, route);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fitur sedang dalam pengembangan')),
            );
          }
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

class BendaharaLaporanPage extends StatefulWidget {
  const BendaharaLaporanPage({super.key});

  @override
  State<BendaharaLaporanPage> createState() => _BendaharaLaporanPageState();
}

class _BendaharaLaporanPageState extends State<BendaharaLaporanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
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
            _buildReportCard(
              context,
              'Laporan Pemasukan',
              Icons.trending_up,
              const Color(0xFF10B981),
              '/reports/income',
            ),
            _buildReportCard(
              context,
              'Laporan Pengeluaran',
              Icons.trending_down,
              const Color(0xFFEF4444),
              '/reports/spending',
            ),
            _buildReportCard(
              context,
              'Cetak Laporan',
              Icons.print,
              const Color(0xFF3B82F6),
              '/reports/print',
            ),
            _buildReportCard(
              context,
              'Ringkasan Keuangan',
              Icons.assessment,
              const Color(0xFF8B5CF6),
              '/reports/income',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          try {
            Navigator.pushNamed(context, route);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fitur sedang dalam pengembangan')),
            );
          }
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

class BendaharaProfilPage extends StatefulWidget {
  const BendaharaProfilPage({super.key});

  @override
  State<BendaharaProfilPage> createState() => _BendaharaProfilPageState();
}

class _BendaharaProfilPageState extends State<BendaharaProfilPage> {
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
                            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
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
                              user?.name ?? 'Bendahara',
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

class BendaharaPesanPage extends StatefulWidget {
  const BendaharaPesanPage({super.key});

  @override
  State<BendaharaPesanPage> createState() => _BendaharaPesanPageState();
}

class _BendaharaPesanPageState extends State<BendaharaPesanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan & Komunikasi'),
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
              'Pesan Warga',
              Icons.message,
              const Color(0xFF14B8A6),
              '/messages',
            ),
            _buildMessageCard(
              context,
              'Laporan Keuangan',
              Icons.assessment,
              const Color(0xFF8B5CF6),
              '/reports/income',
            ),
            _buildMessageCard(
              context,
              'Notifikasi',
              Icons.notifications,
              const Color(0xFFEC4899),
              '/notifications',
            ),
            _buildMessageCard(
              context,
              'Broadcast',
              Icons.campaign,
              const Color(0xFFF59E0B),
              '/announcements',
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
          try {
            Navigator.pushNamed(context, route);
          } catch (e) {
            // Fitur dalam pengembangan tetap bisa digunakan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fitur $title tersedia - Silakan coba lagi'),
                backgroundColor: Colors.blue,
                action: SnackBarAction(
                  label: 'Coba Lagi',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, route);
                  },
                ),
              ),
            );
          }
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
