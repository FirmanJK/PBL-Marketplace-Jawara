import 'package:flutter/material.dart';
import 'package:jawara/data/products.dart';
import 'package:jawara/models/product.dart';
import 'package:jawara/pages/marketplace/marketplace_detail_page.dart';
import 'package:intl/intl.dart';

class MarketplaceCatalogPage extends StatefulWidget {
  const MarketplaceCatalogPage({super.key});

  @override
  State<MarketplaceCatalogPage> createState() => _MarketplaceCatalogPageState();
}

class _MarketplaceCatalogPageState extends State<MarketplaceCatalogPage> {
  final List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    // Langsung load data dummy tanpa loading
    _products.addAll(ProductService.dummyProducts);
    _isLoading = false;
    _hasMore = false;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _hasMore) {
        _loadProducts();
      }
    }
  }

  Future<void> _loadProducts() async {
    // Langsung gunakan data dummy
    if (mounted) {
      setState(() {
        _products.clear();
        _products.addAll(ProductService.dummyProducts);
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _products.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadProducts();
  }

  void _viewDetail(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketplaceDetailPage(product: product),
      ),
    );

    if (result == true) {
      _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0891B2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.inventory_2, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            const Text('Marketplace', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
          ],
        ),
        actions: [
          // Tab Katalog/Unggah
          PopupMenuButton<String>(
            icon: const Icon(Icons.apps, color: Color(0xFF0891B2)),
            onSelected: (value) {
              if (value == 'catalog') {
                // Already on catalog
              } else if (value == 'upload') {
                Navigator.pushNamed(context, '/marketplace/upload');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'catalog',
                child: Row(
                  children: [
                    Icon(Icons.grid_view, color: Color(0xFF0891B2)),
                    SizedBox(width: 12),
                    Text('Katalog Produk'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'upload',
                child: Row(
                  children: [
                    Icon(Icons.upload, color: Color(0xFF0891B2)),
                    SizedBox(width: 12),
                    Text('Unggah Produk'),
                  ],
                ),
              ),
            ],
          ),
          // Profile Menu
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF0891B2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.pushNamed(context, '/profile');
              } else if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF0891B2)),
                    SizedBox(width: 12),
                    Text('Profil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF0891B2)),
                    SizedBox(width: 12),
                    Text('Pengaturan'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Keluar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_products.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada produk',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _refreshProducts,
              child: const Text('Muat Ulang'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final product = _products[index];
          return _ProductCard(
            product: product,
            onTap: () => _viewDetail(product),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0891B2).withOpacity(0.7),
                      const Color(0xFF06B6D4).withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  size: 64,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(product.price),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
