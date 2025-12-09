import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/pages/spending/spending_detail.dart';

class SpendingItem {
  final int no;
  final String nama;
  final String jenisPengeluaran;
  final DateTime tanggal;
  final double nominal;

  SpendingItem({
    required this.no,
    required this.nama,
    required this.jenisPengeluaran,
    required this.tanggal,
    required this.nominal,
  });
}

class SpendingListPage extends StatefulWidget {
  const SpendingListPage({super.key});

  @override
  State<SpendingListPage> createState() => _SpendingListPageState();
}

class _SpendingListPageState extends State<SpendingListPage> {
  bool _isLocaleInitialized = false;

  final List<SpendingItem> _spendingItems = [
    SpendingItem(
      no: 1,
      nama: 'Kerja Bakti',
      jenisPengeluaran: 'Kegiatan Warga',
      tanggal: DateTime(2025, 10, 19),
      nominal: 100000,
    ),
    SpendingItem(
      no: 2,
      nama: 'Kerja Bakti',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 10, 19),
      nominal: 50000,
    ),
    SpendingItem(
      no: 3,
      nama: 'Arka',
      jenisPengeluaran: 'Operasional RT/RW',
      tanggal: DateTime(2025, 10, 17),
      nominal: 600,
    ),
    SpendingItem(
      no: 4,
      nama: 'adead',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 10, 2),
      nominal: 2112,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
    setState(() {
      _isLocaleInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: StandardAppBar(title: 'Daftar Pengeluaran'),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Daftar Pengeluaran',
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
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
            ),
          ),

          // List View
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _spendingItems.length,
              itemBuilder: (context, index) {
                final item = _spendingItems[index];
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
                          builder: (context) => SpendingDetailPage(item: item),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.red.withOpacity(0.1),
                            child: const Icon(
                              Icons.money_off,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.jenisPengeluaran,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateFormatter.format(item.tanggal),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currencyFormatter.format(item.nominal),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
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
<<<<<<< HEAD
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pengeluaran'),
=======
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Pengeluaran', style: TextStyle(color: Colors.white)),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
