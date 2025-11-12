import 'package:flutter/material.dart';
import 'package:jawara/data/products.dart';
import 'package:jawara/models/product.dart';
import 'package:jawara/pages/marketplace_detail_page.dart';
import 'package:jawara/pages/marketplace_edit_page.dart';
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
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _hasMore) {
        _loadProducts();
      }
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);

    try {
      final newProducts = await ProductService.fetchProducts(
        page: _currentPage,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          if (newProducts.isEmpty) {
            _hasMore = false;
          } else {
            _products.addAll(newProducts);
            _currentPage++;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat produk: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  void _showProductMenu(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                _viewDetail(product);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Data'),
              onTap: () {
                Navigator.pop(context);
                _editProduct(product);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus Data', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(product);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketplaceDetailPage(product: product),
      ),
    );
  }

  void _editProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketplaceEditPage(product: product),
      ),
    );
    
    if (result == true) {
      _refreshProducts();
    }
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(product);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await ProductService.deleteProduct(product.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus')),
        );
        _refreshProducts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus produk: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
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
            onMenuTap: () => _showProductMenu(context, product),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onMenuTap;

  const _ProductCard({
    required this.product,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: product.imageUrl.startsWith('http')
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 48);
                          },
                        )
                      : const Icon(Icons.image, size: 48),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onMenuTap,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.more_vert, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
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
    );
  }
}
