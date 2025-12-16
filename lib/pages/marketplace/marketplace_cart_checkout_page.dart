import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/services/cart_service.dart';
import 'package:jawara/models/cart_item.dart';

class MarketplaceCartCheckoutPage extends StatefulWidget {
  const MarketplaceCartCheckoutPage({super.key});

  @override
  State<MarketplaceCartCheckoutPage> createState() => _MarketplaceCartCheckoutPageState();
}

class _MarketplaceCartCheckoutPageState extends State<MarketplaceCartCheckoutPage> {
  final CartService _cartService = CartService();
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _shippingMethod = 'Reguler'; // Reguler atau Instan
  String _paymentMethod = 'Transfer Bank'; // Transfer Bank atau QRIS
  String? _selectedBank; // BCA, Mandiri, BNI, BRI
  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _shippingCost {
    return _shippingMethod == 'Instan' ? 15000 : 5000;
  }

  double get _totalAmount {
    return _cartService.totalPrice + _shippingCost;
  }

  Future<void> _processCheckout() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_cartService.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang kosong')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Clear cart after successful checkout
      _cartService.clearCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to transactions page
        Navigator.pushReplacementNamed(context, '/marketplace/transactions');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
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
                  Icons.shopping_cart_checkout,
                  color: Color(0xFF0891B2),
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: _cartService,
        builder: (context, child) {
          if (_cartService.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan produk ke keranjang terlebih dahulu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, 
                      '/marketplace/catalog', 
                      (route) => route.settings.name == '/warga-dashboard'
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0891B2),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Belanja Sekarang'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  _buildOrderSummary(currencyFormat),
                  const SizedBox(height: 24),
                  
                  // Shipping Address
                  _buildShippingAddress(),
                  const SizedBox(height: 24),
                  
                  // Shipping Method
                  _buildShippingMethod(currencyFormat),
                  const SizedBox(height: 24),
                  
                  // Payment Method
                  _buildPaymentMethod(),
                  const SizedBox(height: 24),
                  
                  // Order Notes
                  _buildOrderNotes(),
                  const SizedBox(height: 32),
                  
                  // Total Summary
                  _buildTotalSummary(currencyFormat),
                  const SizedBox(height: 24),
                  
                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _processCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0891B2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Buat Pesanan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(NumberFormat currencyFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cartService.items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final cartItem = _cartService.items[index];
                final product = cartItem.product;
                
                return Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.shopping_bag, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${cartItem.quantity}x ${currencyFormat.format(product.price)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      currencyFormat.format(product.price * cartItem.quantity),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0891B2),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingAddress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Masukkan alamat lengkap pengiriman',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Alamat pengiriman wajib diisi';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingMethod(NumberFormat currencyFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Metode Pengiriman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('Reguler (2-3 hari)'),
              subtitle: Text(currencyFormat.format(5000)),
              value: 'Reguler',
              groupValue: _shippingMethod,
              onChanged: (value) {
                setState(() => _shippingMethod = value!);
              },
            ),
            RadioListTile<String>(
              title: const Text('Instan (1 hari)'),
              subtitle: Text(currencyFormat.format(15000)),
              value: 'Instan',
              groupValue: _shippingMethod,
              onChanged: (value) {
                setState(() => _shippingMethod = value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('Transfer Bank'),
              value: 'Transfer Bank',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() => _paymentMethod = value!);
              },
            ),
            if (_paymentMethod == 'Transfer Bank') ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('BCA'),
                      value: 'BCA',
                      groupValue: _selectedBank,
                      onChanged: (value) {
                        setState(() => _selectedBank = value);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Mandiri'),
                      value: 'Mandiri',
                      groupValue: _selectedBank,
                      onChanged: (value) {
                        setState(() => _selectedBank = value);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('BNI'),
                      value: 'BNI',
                      groupValue: _selectedBank,
                      onChanged: (value) {
                        setState(() => _selectedBank = value);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('BRI'),
                      value: 'BRI',
                      groupValue: _selectedBank,
                      onChanged: (value) {
                        setState(() => _selectedBank = value);
                      },
                    ),
                  ],
                ),
              ),
            ],
            RadioListTile<String>(
              title: const Text('QRIS'),
              value: 'QRIS',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() => _paymentMethod = value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderNotes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catatan Pesanan (Opsional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Tambahkan catatan untuk penjual',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSummary(NumberFormat currencyFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text(currencyFormat.format(_cartService.totalPrice)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ongkir ($_shippingMethod)'),
                Text(currencyFormat.format(_shippingCost)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currencyFormat.format(_totalAmount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0891B2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}