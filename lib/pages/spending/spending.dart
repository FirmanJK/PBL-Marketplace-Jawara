import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/pages/spending/spending_list.dart';
import 'package:jawara/pages/spending/spending_detail.dart';

class SpendingPage extends StatefulWidget {
  const SpendingPage({super.key});

  @override
  State<SpendingPage> createState() => _SpendingPageState();
}

class _SpendingPageState extends State<SpendingPage> {
  bool _isLocaleInitialized = false;
  bool _isLoading = false;
  String _searchQuery = '';

  final List<SpendingItem> _spendingItems = [
    SpendingItem(
      no: 1,
      nama: 'Pembelian Lampu Jalan',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 11, 20),
      nominal: 2500000,
    ),
    SpendingItem(
      no: 2,
      nama: 'Kerja Bakti Lingkungan',
      jenisPengeluaran: 'Kegiatan Warga',
      tanggal: DateTime(2025, 10, 19),
      nominal: 1500000,
    ),
    SpendingItem(
      no: 3,
      nama: 'Perbaikan Pos Ronda',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 10, 15),
      nominal: 3000000,
    ),
    SpendingItem(
      no: 4,
      nama: 'Gaji Satpam',
      jenisPengeluaran: 'Operasional RT/RW',
      tanggal: DateTime(2025, 10, 1),
      nominal: 4000000,
    ),
    SpendingItem(
      no: 5,
      nama: 'Perayaan 17 Agustus',
      jenisPengeluaran: 'Kegiatan Warga',
      tanggal: DateTime(2025, 8, 17),
      nominal: 5000000,
    ),
    SpendingItem(
      no: 6,
      nama: 'Pembelian Alat Kebersihan',
      jenisPengeluaran: 'Operasional RT/RW',
      tanggal: DateTime(2025, 9, 10),
      nominal: 800000,
    ),
    SpendingItem(
      no: 7,
      nama: 'Perbaikan Saluran Air',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 9, 5),
      nominal: 3500000,
    ),
    SpendingItem(
      no: 8,
      nama: 'ATK dan Administrasi',
      jenisPengeluaran: 'Operasional RT/RW',
      tanggal: DateTime(2025, 8, 25),
      nominal: 500000,
    ),
  ];

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

  List<SpendingItem> _getFilteredItems() {
    if (_searchQuery.isEmpty) {
      return _spendingItems;
    }
    return _spendingItems.where((item) {
      return item.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.jenisPengeluaran.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: StandardAppBar(title: 'Pengeluaran'),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0891B2),
          ),
        ),
      );
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');
    final filteredItems = _getFilteredItems();

    // Calculate total
    final total = filteredItems.fold<double>(
      0,
      (sum, item) => sum + item.nominal,
    );

    return Scaffold(
      appBar: StandardAppBar(title: 'Pengeluaran'),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEF4444).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.trending_down,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Total Pengeluaran',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  currencyFormatter.format(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${filteredItems.length} transaksi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Belum ada data pengeluaran'
                              : 'Tidak ada hasil pencarian',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SpendingDetailPage(item: item),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.money_off,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.jenisPengeluaran,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            dateFormatter.format(item.tanggal),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currencyFormatter.format(item.nominal),
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/spending/add');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Pengeluaran', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
