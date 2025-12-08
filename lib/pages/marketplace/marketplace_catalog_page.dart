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
    _products.addAll(dummyProducts);
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
        _products.addAll(dummyProducts);
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
