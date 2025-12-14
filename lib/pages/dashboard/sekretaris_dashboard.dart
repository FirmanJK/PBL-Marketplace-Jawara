import 'package:flutter/material.dart';
import 'package:jawara/widgets/user_info_widget.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/pages/chat/chat_list_page.dart';

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
    const ChatListPage(),
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
              const Color(0xFF0891B2).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
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
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
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
              
              // Administrasi & Laporan Section
              const Text(
                'Administrasi & Laporan Data',
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
                    'Penerimaan Warga',
                    Icons.person_add_alt,
                    const Color(0xFF3B82F6),
                    '/resident-approvals',
                  ),
                  _buildFeatureCard(
                    context,
                    'Laporan Data',
                    Icons.assessment,
                    const Color(0xFFEC4899),
                    '/reports/income',
                  ),
                  _buildFeatureCard(
                    context,
                    'Mutasi Keluarga',
                    Icons.swap_horiz,
                    const Color(0xFF6366F1),
                    '/family-mutations/list',
                  ),
                  _buildFeatureCard(
                    context,
                    'Administrasi',
                    Icons.folder_open,
                    const Color(0xFFF59E0B),
                    '/administration',
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Pesan & Notifikasi Section
              const Text(
                'Pesan & Notifikasi',
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
                    'Pesan Warga',
                    Icons.message,
                    const Color(0xFF14B8A6),
                    '/messages',
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
                    'Buat Broadcast',
                    Icons.add_circle,
                    const Color(0xFFF59E0B),
                    '/broadcast/add',
                  ),
                  _buildFeatureCard(
                    context,
                    'Notifikasi',
                    Icons.notifications,
                    const Color(0xFFEC4899),
                    '/notifications',
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

class SekretarisDataPage extends StatefulWidget {
  const SekretarisDataPage({super.key});

  @override
  State<SekretarisDataPage> createState() => _SekretarisDataPageState();
}

class _SekretarisDataPageState extends State<SekretarisDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Data'),
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
            _buildDataCard(
              context,
              'Data Warga',
              Icons.people,
              const Color(0xFF3B82F6),
              '/residents/list',
            ),
            _buildDataCard(
              context,
              'Tambah Warga',
              Icons.person_add,
              const Color(0xFF10B981),
              '/residents/add',
            ),
            _buildDataCard(
              context,
              'Data Keluarga',
              Icons.family_restroom,
              const Color(0xFF8B5CF6),
              '/families',
            ),
            _buildDataCard(
              context,
              'Data Rumah',
              Icons.home,
              const Color(0xFFF59E0B),
              '/houses/list',
            ),
            _buildDataCard(
              context,
              'Mutasi Keluarga',
              Icons.swap_horiz,
              const Color(0xFFEC4899),
              '/family-mutations/list',
            ),
            _buildDataCard(
              context,
              'Penerimaan Warga',
              Icons.how_to_reg,
              const Color(0xFF14B8A6),
              '/resident-approvals',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(BuildContext context, String title, IconData icon, Color color, String route) {
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
              'Pesan Warga',
              Icons.message,
              const Color(0xFF14B8A6),
              '/messages',
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
