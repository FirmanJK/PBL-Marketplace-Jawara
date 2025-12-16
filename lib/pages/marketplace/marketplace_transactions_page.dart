import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/models/transaction.dart' as app_transaction;

class MarketplaceTransactionsPage extends StatefulWidget {
  const MarketplaceTransactionsPage({super.key});

  @override
  State<MarketplaceTransactionsPage> createState() => _MarketplaceTransactionsPageState();
}

class _MarketplaceTransactionsPageState extends State<MarketplaceTransactionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<app_transaction.Transaction> _allTransactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadTransactions();
  }

  void _loadTransactions() {
    try {
      // Simulate loading delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _allTransactions = [
            app_transaction.Transaction(
              id: 1,
              productId: 1,
              buyerId: 1,
              sellerId: 2,
              quantity: 2,
              totalPrice: 100000,
              status: 'pending',
              shippingAddress: 'Jl. Contoh No. 123, Jakarta',
              notes: 'Mohon kirim cepat',
              createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            app_transaction.Transaction(
              id: 2,
              productId: 2,
              buyerId: 1,
              sellerId: 3,
              quantity: 1,
              totalPrice: 250000,
              status: 'paid',
              shippingAddress: 'Jl. Contoh No. 456, Bandung',
              createdAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
            app_transaction.Transaction(
              id: 3,
              productId: 3,
              buyerId: 1,
              sellerId: 2,
              quantity: 3,
              totalPrice: 150000,
              status: 'shipped',
              shippingAddress: 'Jl. Contoh No. 789, Surabaya',
              createdAt: DateTime.now().subtract(const Duration(days: 2)),
            ),
            app_transaction.Transaction(
              id: 4,
              productId: 4,
              buyerId: 1,
              sellerId: 4,
              quantity: 1,
              totalPrice: 500000,
              status: 'completed',
              shippingAddress: 'Jl. Contoh No. 321, Yogyakarta',
              createdAt: DateTime.now().subtract(const Duration(days: 5)),
            ),
            app_transaction.Transaction(
              id: 5,
              productId: 5,
              buyerId: 1,
              sellerId: 3,
              quantity: 2,
              totalPrice: 300000,
              status: 'cancelled',
              shippingAddress: 'Jl. Contoh No. 999, Medan',
              notes: 'Dibatalkan karena stok habis',
              createdAt: DateTime.now().subtract(const Duration(days: 7)),
            ),
          ];
          _isLoading = false;
        });
      }
    });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading transactions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<app_transaction.Transaction> _getFilteredTransactions(String status) {
    if (status == 'all') return _allTransactions;
    return _allTransactions.where((t) => t.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                  Icons.receipt_long,
                  color: Color(0xFF0891B2),
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Transaksi Saya', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF0891B2),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF0891B2),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Pending'),
            Tab(text: 'Dibayar'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0891B2),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList('all'),
                _buildTransactionList('pending'),
                _buildTransactionList('paid'),
                _buildTransactionList('shipped'),
                _buildTransactionList('completed'),
              ],
            ),
    );
  }

  Widget _buildTransactionList(String status) {
    final transactions = _getFilteredTransactions(status);

    if (transactions.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          _loadTransactions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada transaksi',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tarik ke bawah untuk memuat ulang',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        _loadTransactions();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return _TransactionCard(transaction: transaction);
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final app_transaction.Transaction transaction;

  const _TransactionCard({required this.transaction});

  String _formatCurrency(double amount) {
    try {
      final formatter = NumberFormat.currency(
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    } catch (e) {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }

  String _formatDate(DateTime date) {
    try {
      final formatter = DateFormat('dd MMM yyyy, HH:mm');
      return formatter.format(date);
    } catch (e) {
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDetailDate(DateTime date) {
    try {
      final formatter = DateFormat('dd MMMM yyyy, HH:mm');
      return formatter.format(date);
    } catch (e) {
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showTransactionDetail(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: #${transaction.id.toString().padLeft(6, '0')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: transaction.getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      transaction.getStatusText(),
                      style: TextStyle(
                        color: transaction.getStatusColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(transaction.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${transaction.quantity} item',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatCurrency(transaction.totalPrice),
                    style: const TextStyle(
                      color: Color(0xFF0891B2),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetail(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Detail Transaksi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildDetailRow('ID Transaksi', '#${transaction.id.toString().padLeft(6, '0')}'),
                _buildDetailRow('Tanggal', _formatDetailDate(transaction.createdAt)),
                _buildDetailRow('Jumlah', '${transaction.quantity} item'),
                _buildDetailRow('Total', _formatCurrency(transaction.totalPrice)),
                _buildDetailRow('Status', transaction.getStatusText()),
                if (transaction.shippingAddress != null)
                  _buildDetailRow('Alamat Pengiriman', transaction.shippingAddress!),
                if (transaction.notes != null)
                  _buildDetailRow('Catatan', transaction.notes!),
                const SizedBox(height: 24),
                if (transaction.status == 'pending')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pembayaran berhasil diproses'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0891B2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Bayar Sekarang'),
                    ),
                  ),
                if (transaction.status == 'shipped')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pesanan telah diterima'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Pesanan Diterima'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
