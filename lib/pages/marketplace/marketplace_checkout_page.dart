import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/models/product.dart';
import 'package:jawara/pages/marketplace/marketplace_payment_page.dart';

class MarketplaceCheckoutPage extends StatefulWidget {
  final Product product;

  const MarketplaceCheckoutPage({super.key, required this.product});

  @override
  State<MarketplaceCheckoutPage> createState() =>
      _MarketplaceCheckoutPageState();
}

class _MarketplaceCheckoutPageState extends State<MarketplaceCheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  int _quantity = 1;
  String _shippingMethod = 'Reguler'; // Reguler atau Instan
  String _paymentMethod = 'Transfer Bank'; // Transfer Bank atau QRIS
  String? _selectedBank; // BCA, Mandiri, BNI, BRI

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _totalPrice => widget.product.price * _quantity;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _processCheckout() {
    if (_formKey.currentState!.validate()) {
      // Validasi metode pembayaran
      if (_paymentMethod == 'Transfer Bank' && _selectedBank == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih bank untuk transfer'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validasi alamat untuk pengiriman reguler
      if (_shippingMethod == 'Reguler' && _addressController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Alamat pengiriman harus diisi untuk pengiriman reguler',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _completeCheckout();
    }
  }

  void _completeCheckout() {
    // Generate order ID
    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

    // Navigate to payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketplacePaymentPage(
          orderId: orderId,
          totalAmount: _totalPrice,
          paymentMethod: _paymentMethod,
          selectedBank: _selectedBank,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.product.imageUrl.startsWith('http')
                                  ? Image.network(
                                      widget.product.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            );
                                          },
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currencyFormat.format(widget.product.price),
                                    style: const TextStyle(
                                      color: Color(0xFF0891B2),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quantity Selector
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jumlah',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _decrementQuantity,
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: const Color(0xFF0891B2),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _incrementQuantity,
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: const Color(0xFF0891B2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Shipping Method
                    const Text(
                      'Metode Pengiriman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Reguler (Diantar Penjual)'),
                            subtitle: const Text(
                              'Produk akan diantar ke alamat Anda',
                            ),
                            value: 'Reguler',
                            groupValue: _shippingMethod,
                            onChanged: (value) {
                              setState(() {
                                _shippingMethod = value!;
                              });
                            },
                            activeColor: const Color(0xFF0891B2),
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            title: const Text('Instan (Ambil di Tempat)'),
                            subtitle: const Text(
                              'Ambil langsung di lokasi penjual',
                            ),
                            value: 'Instan',
                            groupValue: _shippingMethod,
                            onChanged: (value) {
                              setState(() {
                                _shippingMethod = value!;
                              });
                            },
                            activeColor: const Color(0xFF0891B2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Shipping Address (only for Reguler)
                    if (_shippingMethod == 'Reguler') ...[
                      const Text(
                        'Alamat Pengiriman',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Masukkan alamat lengkap pengiriman',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (_shippingMethod == 'Reguler' &&
                              (value == null || value.isEmpty)) {
                            return 'Alamat pengiriman harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Payment Method
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Transfer Bank'),
                            subtitle: const Text('BCA, Mandiri, BNI, BRI'),
                            value: 'Transfer Bank',
                            groupValue: _paymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _paymentMethod = value!;
                              });
                            },
                            activeColor: const Color(0xFF0891B2),
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            title: const Text('QRIS'),
                            subtitle: const Text('Scan QR untuk membayar'),
                            value: 'QRIS',
                            groupValue: _paymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _paymentMethod = value!;
                                _selectedBank = null;
                              });
                            },
                            activeColor: const Color(0xFF0891B2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bank Selection (only for Transfer Bank)
                    if (_paymentMethod == 'Transfer Bank') ...[
                      const Text(
                        'Pilih Bank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            _buildBankOption('BCA'),
                            const Divider(height: 1),
                            _buildBankOption('Mandiri'),
                            const Divider(height: 1),
                            _buildBankOption('BNI'),
                            const Divider(height: 1),
                            _buildBankOption('BRI'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Notes
                    const Text(
                      'Catatan (Opsional)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Tambahkan catatan untuk penjual',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0891B2),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Summary
            Container(
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        currencyFormat.format(_totalPrice),
                        style: const TextStyle(
                          color: Color(0xFF0891B2),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0891B2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Buat Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildBankOption(String bankName) {
    return RadioListTile<String>(
      title: Text(bankName),
      value: bankName,
      groupValue: _selectedBank,
      onChanged: (value) {
        setState(() {
          _selectedBank = value;
        });
      },
      activeColor: const Color(0xFF0891B2),
    );
  }
}
