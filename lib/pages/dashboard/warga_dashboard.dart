import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/pages/chat/chat_list_page.dart';

class WargaDashboardPage extends StatefulWidget {
  const WargaDashboardPage({super.key});

  @override
  State<WargaDashboardPage> createState() => _WargaDashboardPageState();
}

class _WargaDashboardPageState extends State<WargaDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const WargaHomePage(),
    const WargaMarketplacePage(),
    const ChatListPage(),
    const WargaProfilPage(),
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
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Marketplace',
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

class WargaHomePage extends StatelessWidget {
  const WargaHomePage({super.key});

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
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/marketplace/cart');
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
                      'Selamat Datang, Warga',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Akses layanan RT/RW dengan mudah',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Layanan Utama Section
              const Text(
                'Layanan Utama',
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
                    'Tagihan Aktif',
                    Icons.notifications_active,
                    const Color(0xFFEF4444),
                    '/income/bills',
                  ),
                  _buildFeatureCard(
                    context,
                    'Riwayat Iuran',
                    Icons.payment,
                    const Color(0xFF10B981),
                    '/income/bills',
                  ),
                  _buildFeatureCard(
                    context,
                    'Pesan Warga',
                    Icons.message,
                    const Color(0xFF14B8A6),
                    '/messages',
                  ),
                  _buildFeatureCard(
                    context,
                    'Pengumuman',
                    Icons.campaign,
                    const Color(0xFF3B82F6),
                    '/announcements',
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
                    'Notifikasi',
                    Icons.notifications,
                    const Color(0xFFEC4899),
                    '/notifications',
                  ),
                  _buildFeatureCard(
                    context,
                    'Broadcast',
                    Icons.campaign,
                    const Color(0xFF6366F1),
                    '/announcements',
                  ),
                  _buildFeatureCard(
                    context,
                    'Marketplace',
                    Icons.shopping_bag,
                    const Color(0xFFF59E0B),
                    '/marketplace',
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

class WargaMarketplacePage extends StatefulWidget {
  const WargaMarketplacePage({super.key});

  @override
  State<WargaMarketplacePage> createState() => _WargaMarketplacePageState();
}

class _WargaMarketplacePageState extends State<WargaMarketplacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
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
            _buildMarketplaceCard(
              context,
              'Katalog Produk',
              Icons.shopping_bag,
              const Color(0xFFF59E0B),
              '/marketplace/catalog',
            ),
            _buildMarketplaceCard(
              context,
              'Jual Produk',
              Icons.add_business,
              const Color(0xFF10B981),
              '/marketplace/upload',
            ),
            _buildMarketplaceCard(
              context,
              'Keranjang',
              Icons.shopping_cart,
              const Color(0xFF3B82F6),
              '/marketplace',
            ),
            _buildMarketplaceCard(
              context,
              'Riwayat Pesanan',
              Icons.history,
              const Color(0xFF8B5CF6),
              '/marketplace',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketplaceCard(BuildContext context, String title, IconData icon, Color color, String route) {
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

class WargaPesanPage extends StatefulWidget {
  const WargaPesanPage({super.key});

  @override
  State<WargaPesanPage> createState() => _WargaPesanPageState();
}

class _WargaPesanPageState extends State<WargaPesanPage> {
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
              'Pengumuman',
              Icons.campaign,
              const Color(0xFFF59E0B),
              '/announcements',
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
              'Riwayat Iuran',
              Icons.payment,
              const Color(0xFF10B981),
              '/income/bills',
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

class WargaProfilPage extends StatefulWidget {
  const WargaProfilPage({super.key});

  @override
  State<WargaProfilPage> createState() => _WargaProfilPageState();
}

class _WargaProfilPageState extends State<WargaProfilPage> {
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
                              user?.name ?? 'Warga',
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