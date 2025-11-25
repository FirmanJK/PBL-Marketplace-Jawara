import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class IncomeReportItem {
  final int no;
  final String nama;
  final String jenisPemasukan;
  final DateTime tanggal;
  final double nominal;

  IncomeReportItem({
    required this.no,
    required this.nama,
    required this.jenisPemasukan,
    required this.tanggal,
    required this.nominal,
  });
}

class ReportsIncomePage extends StatefulWidget {
  const ReportsIncomePage({super.key});

  @override
  State<ReportsIncomePage> createState() => _ReportsIncomePageState();
}

class _ReportsIncomePageState extends State<ReportsIncomePage> {
  bool _isLocaleInitialized = false;

  final List<IncomeReportItem> _incomeItems = [
    IncomeReportItem(
      no: 1,
      nama: 'aaaaa',
      jenisPemasukan: 'Dana Bantuan Pemerintah',
      tanggal: DateTime(2025, 10, 15, 14, 23),
      nominal: 11000,
    ),
    IncomeReportItem(
      no: 2,
      nama: 'Joki by firman',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 10, 13, 0, 55),
      nominal: 4999999700,
    ),
    IncomeReportItem(
      no: 3,
      nama: 'tes',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 8, 12, 13, 26),
      nominal: 1000000,
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
        appBar: StandardAppBar(title: 'Laporan Pemasukan'),
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
    final dateTimeFormatter = DateFormat('d MMM yyyy HH:mm', 'id_ID');

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Laporan Pemasukan',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {},
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {},
            tooltip: 'Cetak PDF',
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
                hintText: 'Cari laporan pemasukan...',
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
                        Icons.trending_up,
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
                          dateTimeFormatter.format(item.tanggal),
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
    );
  }
}
