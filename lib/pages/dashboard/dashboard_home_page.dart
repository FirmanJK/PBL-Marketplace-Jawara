import 'package:flutter/material.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  static final List<Map<String, dynamic>> _dummyProducts = [
    {
      'name': 'Sayur Organik',
      'price': 'Rp 15.000',
      'rating': '4.8',
      'sold': '120',
      'icon': Icons.eco,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Telur Kampung',
      'price': 'Rp 35.000',
      'rating': '4.9',
      'sold': '85',
      'icon': Icons.egg,
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'Ikan Segar',
      'price': 'Rp 45.000',
      'rating': '4.7',
      'sold': '65',
      'icon': Icons.set_meal,
      'color': const Color(0xFF06B6D4),
    },
    {
      'name': 'Buah Segar',
      'price': 'Rp 25.000',
      'rating': '4.8',
      'sold': '95',
      'icon': Icons.apple,
      'color': const Color(0xFFEF4444),
    },
    {
      'name': 'Roti Tawar',
      'price': 'Rp 18.000',
      'rating': '4.9',
      'sold': '150',
      'icon': Icons.bakery_dining,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Susu Murni',
      'price': 'Rp 12.000',
      'rating': '4.8',
      'sold': '200',
      'icon': Icons.local_drink,
      'color': const Color(0xFF3B82F6),
    },
    {
      'name': 'Kue Kering',
      'price': 'Rp 55.000',
      'rating': '4.9',
      'sold': '45',
      'icon': Icons.cookie,
      'color': const Color(0xFFF97316),
    },
    {
      'name': 'Madu Murni',
      'price': 'Rp 75.000',
      'rating': '5.0',
      'sold': '30',
      'icon': Icons.water_drop,
      'color': const Color(0xFFEAB308),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFF0891B2),
          elevation: 0,
          title: const Text(
            'JAWARA',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(context: context, delegate: _SearchDelegate());
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/marketplace');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          // Header Card with Overview
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // System Overview
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildOverviewItem(
                                  'Server',
                                  'Online',
                                  Icons.cloud_done,
                                ),
                                _buildOverviewItem(
                                  'Users',
                                  '1,234',
                                  Icons.people,
                                ),
                                _buildOverviewItem(
                                  'Traffic',
                                  'High',
                                  Icons.trending_up,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quick Stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Warga',
                              '1,234',
                              Icons.people,
                              const Color(0xFF06B6D4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Keuangan',
                              'Rp 50M',
                              Icons.account_balance_wallet,
                              const Color(0xFF0EA5E9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Features Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Layanan Utama',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildMainFeaturesGrid(context),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Marketplace Products Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Marketplace',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/marketplace');
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dummyProducts.length,
                    itemBuilder: (context, index) {
                      final product = _dummyProducts[index];
                      return _buildProductCard(context, product);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/marketplace');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: product['color'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(product['icon'], size: 40, color: Colors.white),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product['price'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0891B2),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 10,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '${product['rating']} • ${product['sold']}',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeaturesGrid(BuildContext context) {
    final features = [
      FeatureItem(
        'Warga',
        Icons.people,
        const Color(0xFF3B82F6),
        '/residents/list',
      ),
      FeatureItem(
        'Keuangan',
        Icons.account_balance_wallet,
        const Color(0xFF10B981),
        '/dashboard/finance',
      ),
      FeatureItem(
        'Kegiatan',
        Icons.event,
        const Color(0xFF6366F1),
        '/dashboard/activities',
      ),
      FeatureItem(
        'Kependudukan',
        Icons.family_restroom,
        const Color(0xFF8B5CF6),
        '/dashboard/population',
      ),
      FeatureItem(
        'Marketplace',
        Icons.shopping_bag,
        const Color(0xFFF59E0B),
        '/marketplace',
      ),
      FeatureItem(
        'Laporan',
        Icons.assessment,
        const Color(0xFFEC4899),
        '/reports/income',
      ),
      FeatureItem('Pesan', Icons.message, const Color(0xFF14B8A6), '/messages'),
      FeatureItem(
        'Lainnya',
        Icons.apps,
        const Color(0xFF64748B),
        'all_features',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(context, feature);
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context, FeatureItem feature) {
    return InkWell(
      onTap: () {
        if (feature.route != null) {
          if (feature.route == 'all_features') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllFeaturesPage()),
            );
          } else {
            Navigator.pushNamed(context, feature.route!);
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: feature.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(feature.icon, color: feature.color, size: 24),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  feature.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Feature Item Model
class FeatureItem {
  final String name;
  final IconData icon;
  final Color color;
  final String? route;

  FeatureItem(this.name, this.icon, this.color, this.route);
}

// Search Delegate
class _SearchDelegate extends SearchDelegate<String> {
  final List<Map<String, String>> _searchItems = [
    {'title': 'Data Warga', 'route': '/residents/list'},
    {'title': 'Keuangan', 'route': '/dashboard/finance'},
    {'title': 'Pemasukan', 'route': '/income'},
    {'title': 'Pengeluaran', 'route': '/spending'},
    {'title': 'Laporan', 'route': '/reports/income'},
    {'title': 'Kegiatan', 'route': '/activities/list'},
    {'title': 'Marketplace', 'route': '/marketplace'},
    {'title': 'Pesan', 'route': '/messages'},
    {'title': 'Pengaturan', 'route': '/settings'},
  ];

  @override
  String get searchFieldLabel => 'Cari fitur...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0891B2),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? _searchItems
        : _searchItems
              .where(
                (item) =>
                    item['title']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Color(0xFF0891B2)),
          title: Text(item['title']!),
          onTap: () {
            Navigator.pushNamed(context, item['route']!);
            close(context, item['title']!);
          },
        );
      },
    );
  }
}

// All Features Page
class AllFeaturesPage extends StatelessWidget {
  const AllFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Semua Fitur', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0891B2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Keuangan Section
          _buildCategorySection(
            context,
            'Keuangan',
            Icons.account_balance_wallet,
            const Color(0xFF10B981),
            [
              FeatureItem(
                'Pemasukan',
                Icons.arrow_downward,
                const Color(0xFF10B981),
                '/income',
              ),
              FeatureItem(
                'Pengeluaran',
                Icons.arrow_upward,
                const Color(0xFFEF4444),
                '/spending',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Kependudukan Section
          _buildCategorySection(
            context,
            'Kependudukan',
            Icons.people,
            const Color(0xFF0891B2),
            [
              FeatureItem(
                'Data Warga',
                Icons.people,
                const Color(0xFF0891B2),
                '/residents/list',
              ),
              FeatureItem(
                'Keluarga',
                Icons.family_restroom,
                const Color(0xFF8B5CF6),
                '/families',
              ),
              FeatureItem(
                'Rumah',
                Icons.home,
                const Color(0xFF14B8A6),
                '/houses/list',
              ),
              FeatureItem(
                'Mutasi',
                Icons.swap_horiz,
                const Color(0xFFF59E0B),
                '/family-mutations/list',
              ),
              FeatureItem(
                'Persetujuan',
                Icons.check_circle,
                const Color(0xFF06B6D4),
                '/resident-approvals',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Aktivitas & Komunikasi Section
          _buildCategorySection(
            context,
            'Aktivitas & Komunikasi',
            Icons.event,
            const Color(0xFF6366F1),
            [
              FeatureItem(
                'Kegiatan',
                Icons.event,
                const Color(0xFF6366F1),
                '/activities/list',
              ),
              FeatureItem(
                'Broadcast',
                Icons.campaign,
                const Color(0xFFEF4444),
                '/broadcast/list',
              ),
              FeatureItem(
                'Pesan',
                Icons.message,
                const Color(0xFF0891B2),
                '/messages',
              ),
              FeatureItem(
                'Notifikasi',
                Icons.notifications,
                const Color(0xFFF59E0B),
                '/notifications',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Fitur Lainnya Section
          _buildCategorySection(
            context,
            'Fitur Lainnya',
            Icons.apps,
            const Color(0xFF64748B),
            [
              FeatureItem(
                'Marketplace',
                Icons.shopping_bag,
                const Color(0xFF10B981),
                '/marketplace',
              ),
              FeatureItem(
                'Log Aktivitas',
                Icons.history,
                const Color(0xFF64748B),
                '/activity-logs',
              ),
              FeatureItem(
                'Manajemen User',
                Icons.admin_panel_settings,
                const Color(0xFFEF4444),
                '/users',
              ),
              FeatureItem(
                'Pengaturan',
                Icons.settings,
                const Color(0xFF475569),
                '/settings',
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    IconData categoryIcon,
    Color categoryColor,
    List<FeatureItem> features,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  categoryColor.withOpacity(0.1),
                  categoryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ],
            ),
          ),

          // Features Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return _buildFeatureCard(context, feature);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, FeatureItem feature) {
    return InkWell(
      onTap: () {
        if (feature.route != null) {
          Navigator.pushNamed(context, feature.route!);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: feature.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(feature.icon, color: feature.color, size: 24),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  feature.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
