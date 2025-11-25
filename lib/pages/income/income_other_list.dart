import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class OtherIncomeItem {
  final int no;
  final String nama;
  final String jenisPemasukan;
  final DateTime tanggal;
  final double nominal;

  OtherIncomeItem({
    required this.no,
    required this.nama,
    required this.jenisPemasukan,
    required this.tanggal,
    required this.nominal,
  });
}

class IncomeOtherListPage extends StatefulWidget {
  const IncomeOtherListPage({super.key});

  @override
  State<IncomeOtherListPage> createState() => _IncomeOtherListPageState();
}

class _IncomeOtherListPageState extends State<IncomeOtherListPage> {
  bool _isLocaleInitialized = false;

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

  final List<OtherIncomeItem> _incomeItems = [
    OtherIncomeItem(
      no: 1,
      nama: 'aaaaa',
      jenisPemasukan: 'Dana Bantuan Pemerintah',
      tanggal: DateTime(2025, 10, 15),
      nominal: 11000,
    ),
    OtherIncomeItem(
      no: 2,
      nama: 'Joki by firman',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 10, 13),
      nominal: 4999999700,
    ),
    OtherIncomeItem(
      no: 3,
      nama: 'tes',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 8, 12),
      nominal: 1000000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: StandardAppBar(title: 'Pemasukan Lain'),
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
        title: 'Pemasukan Lain',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari pemasukan...',
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
              itemCount: _incomeItems.length,
              itemBuilder: (context, index) {
                final item = _incomeItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      item.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(item.jenisPemasukan),
                        const SizedBox(height: 4),
                        Text(
                          dateFormatter.format(item.tanggal),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(item.nominal),
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/income/other/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pemasukan'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
