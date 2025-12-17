import 'package:flutter/material.dart';
import 'package:jawara/models/marketplace_product.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/pages/marketplace/marketplace_detail_page.dart';
import 'package:jawara/pages/marketplace/marketplace_edit_page.dart';
import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/marketplace_service.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/utils/role_helper.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MarketplaceCatalogPage extends StatefulWidget {
  const MarketplaceCatalogPage({super.key});

  @override
  State<MarketplaceCatalogPage> createState() => _MarketplaceCatalogPageState();
}

class _MarketplaceCatalogPageState extends State<MarketplaceCatalogPage> {
  final List<MarketplaceProduct> _products = [];
  final ScrollController _scrollController = ScrollController();
  String? _token;
  bool _isAdmin = false;
  int? _currentUserId;

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _initializeAndLoadProducts();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _checkAdminStatus() async {
    final authService = AuthService();
    setState(() {
      _isAdmin = authService.currentRole == UserRole.adminSistem;
      _currentUserId = authService.currentUser?.id;
    });
  }

  Future<void> _initializeAndLoadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
    await _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _hasMore && _currentPage < _totalPages) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading) return;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await MarketplaceService.getProducts(token: _token);

      print('[DEBUG] Marketplace API Response: ${response.length} products');

      if (!mounted) return;

      setState(() {
        _products.clear();
        _products.addAll(response);
        _currentPage = 1;
        _hasMore = response.length >= 20;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      print('[DEBUG] Marketplace API Error: $e');

      if (!mounted) return;

      setState(() {
        _products.clear();
        _errorMessage = 'Gagal memuat produk: $e';
        _isLoading = false;
      });

      if (mounted) {
        ToastHelper.showError(context, 'Gagal memuat produk');
      }
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await MarketplaceService.getProducts(token: _token);

      if (!mounted) return;

      setState(() {
        _products.addAll(response);
        _currentPage++;
        _hasMore = response.length >= 20;
        _isLoading = false;
      });
    } catch (e) {
      print('[DEBUG] Load more error: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasMore = false;
      });

      if (mounted) {
        ToastHelper.showError(context, 'Gagal memuat lebih banyak produk');
      }
    }
  }

  Future<void> _refreshProducts() async {
    _currentPage = 1;
    await _loadProducts();
  }

  void _viewDetail(MarketplaceProduct product) async {
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
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
          onPressed: () {
            final authService = AuthService();
            final role = authService.currentRole;
            if (role != null) {
              final dashboardRoute = RoleHelper.getDashboardRoute(role);
              Navigator.pushReplacementNamed(context, dashboardRoute);
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0891B2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Color(0xFF0891B2),
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Marketplace',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          // Tab Katalog/Unggah
          PopupMenuButton<String>(
            icon: const Icon(Icons.apps, color: Color(0xFF0891B2)),
            onSelected: (value) {
              if (value == 'upload') {
                Navigator.pushNamed(context, '/marketplace/upload');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'catalog',
                enabled: false,
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
    // Show loading on initial load
    if (_products.isEmpty && _isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0891B2)),
            ),
            const SizedBox(height: 16),
            const Text('Memuat produk...'),
          ],
        ),
      );
    }

    // Show error state
    if (_products.isEmpty && _errorMessage != null && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Gagal memuat produk',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0891B2),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Show empty state
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
            Text(
              'Mulai dengan mengunggah produk Anda',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/marketplace/upload'),
              icon: const Icon(Icons.upload),
              label: const Text('Unggah Produk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0891B2),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Show product grid
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
        itemCount: _products.length + (_hasMore && _isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (index == _products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0891B2)),
                ),
              ),
            );
          }

          final product = _products[index];
          return _ProductCard(
            product: product,
            onTap: () => _viewDetail(product),
            isAdmin: _isAdmin,
            currentUserId: _currentUserId,
            onDelete: _refreshProducts,
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final MarketplaceProduct product;
  final VoidCallback onTap;
  final bool isAdmin;
  final int? currentUserId;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onTap,
    this.isAdmin = false,
    this.currentUserId,
    required this.onDelete,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isDeleting = false;

  bool get _isOwner => widget.currentUserId == widget.product.residentId;
  bool get _canManage => widget.isAdmin || _isOwner;

  Future<void> _deleteProduct() async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        if (mounted) {
          ToastHelper.showError(context, 'Token tidak ditemukan');
        }
        setState(() => _isDeleting = false);
        return;
      }

      final response = await ApiService.delete(
        '/marketplace/products/${widget.product.id}',
        token: token,
      );

      if (mounted) {
        ToastHelper.showSuccess(context, 'Produk berhasil dihapus');
        widget.onDelete();
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Gagal menghapus: $e');
      }
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  void _editProduct(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarketplaceEditPage(product: widget.product),
        ),
      );

      if (result == true) {
        widget.onDelete(); // Refresh the list
      }
    } catch (e) {
      print('[ERROR] Navigation error: $e');
      if (mounted) {
        ToastHelper.showError(context, 'Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InkWell(
            onTap: widget.onTap,
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
                    child: widget.product.getImageUrl().isNotEmpty
                        ? Image.network(
                            widget.product.getImageUrl(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.shopping_bag,
                                size: 64,
                                color: Colors.white.withOpacity(0.8),
                              );
                            },
                          )
                        : Icon(
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
                        widget.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(widget.product.price),
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
          // Management menu (subtle)
          if (_canManage)
            Positioned(
              top: 4,
              right: 4,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 20,
                  shadows: [
                    Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
                  ],
                ),
                offset: const Offset(0, 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 18, color: Color(0xFF0891B2)),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _editProduct(context);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Produk'),
        content: Text(
          'Apakah Anda yakin ingin menghapus produk "${widget.product.name}"?\n\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _isDeleting
                ? null
                : () {
                    Navigator.pop(dialogContext);
                    _deleteProduct();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: _isDeleting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
