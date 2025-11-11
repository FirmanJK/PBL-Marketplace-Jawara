import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart';
import 'package:jawara/shared/theme.dart';

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
      return const BaseLayout(
        title: 'Daftar Pengeluaran',
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final headers = [
      'NO',
      'NAMA',
      'JENIS PENGELUARAN',
      'TANGGAL',
      'NOMINAL',
      'AKSI',
    ];
    // Define sortable columns
    final sortable = ['NAMA', 'JENIS PENGELUARAN', 'TANGGAL', 'NOMINAL'];

    // Prepare table rows with formatting
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    // Format tanggal tanpa waktu, sesuai screenshot
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    final rows = _spendingItems.map((item) {
      return <Widget>[
        Text(item.no.toString()),
        Text(item.nama),
        Text(item.jenisPengeluaran),
        Text(dateFormatter.format(item.tanggal)), // Format tanggal saja
        Text(currencyFormatter.format(item.nominal)), // Format nominal
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          tooltip: 'Opsi Lain',
        ),
      ];
    }).toList();

    return BaseLayout(
      title: 'Daftar Pengeluaran', // AppBar title
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Main content padding
        child: Column(
          children: [
            // White container as the main Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.borderRadiusXLarge, // From theme
                boxShadow: AppTheme.shadowMedium, // From theme
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header row with Filter button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary, // From theme
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                AppTheme.borderRadiusSmall, // From theme
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data Table
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ), // Min width
                          child: CustomDataTable(
                            headers: headers,
                            rows: rows,
                            sortable: sortable,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Pagination Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {},
                        tooltip: 'Halaman Sebelumnya',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary, // From theme
                          borderRadius:
                              AppTheme.borderRadiusSmall, // From theme
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {},
                        tooltip: 'Halaman Berikutnya',
                      ),
                    ],
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
