import 'package:flutter/material.dart';
import 'package:jawara/models/product.dart';
import 'package:jawara/pages/marketplace/marketplace_checkout_page.dart';
import 'package:jawara/pages/marketplace/marketplace_edit_page.dart';
import 'package:jawara/pages/marketplace/marketplace_cart_page.dart';
import 'package:jawara/data/products.dart';
import 'package:jawara/services/cart_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MarketplaceDetailPage extends StatefulWidget {
  final Product product;

  const MarketplaceDetailPage({super.key, required this.product});

  @override
  State<MarketplaceDetailPage> createState() => _MarketplaceDetailPageState();
}

class _MarketplaceDetailPageState extends State<MarketplaceDetailPage> {
  final CartService _cartService = CartService();
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
    if (mounted) {
      setState(() {
        _isLocaleInitialized = true;
      });
    }
  }

  void _addToCart() {
    _cartService.addToCart(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} ditambahkan ke keranjang'),
        backgroundColor: const Color(0xFF10B981),
        action: SnackBarAction(
          label: 'Lihat',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MarketplaceCartPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _editProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketplaceEditPage(product: widget.product),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${widget.product.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct() async {
    try {
      await ProductService.deleteProduct(widget.product.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil dihapus'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus produk: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while locale is being initialized
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0891B2),
          ),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          // Cart Icon with Badge
          ListenableBuilder(
            listenable: _cartService,
            builder: (context, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarketplaceCartPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                  if (_cartService.itemCount > 0)
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
                        child: Text(
                          '${_cartService.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'edit') {
                _editProduct();
              } else if (value == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: widget.product.imageUrl.startsWith('http')
                  ? Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 64),
                        );
                      },
                    )
                  : const Center(child: Icon(Icons.image, size: 64)),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currencyFormat.format(widget.product.price),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description Label
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Created At
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Diunggah: ${dateFormat.format(widget.product.createdAt)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Button Keranjang - Hanya Icon
            IconButton(
              onPressed: _addToCart,
              icon: const Icon(Icons.shopping_cart),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF0891B2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              iconSize: 28,
              tooltip: 'Tambah ke Keranjang',
            ),
            const SizedBox(width: 12),
            // Button Beli Sekarang
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MarketplaceCheckoutPage(product: widget.product),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag, color: Colors.white),
                label: const Text(
                  'Beli Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0891B2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
