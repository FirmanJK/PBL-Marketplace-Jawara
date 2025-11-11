import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart';
import 'package:jawara/shared/theme.dart';

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
      return const BaseLayout(
        title: 'Laporan Pemasukan',
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final headers = [
      'NO',
      'NAMA',
      'JENIS PEMASUKAN',
      'TANGGAL',
      'NOMINAL',
      'AKSI',
    ];
    // Define sortable columns
    final sortable = ['NAMA', 'JENIS PEMASUKAN', 'TANGGAL', 'NOMINAL'];

    // Prepare table rows with formatting
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    final dateTimeFormatter = DateFormat('d MMM yyyy HH:mm', 'id_ID');

    final rows = _incomeItems.map((item) {
      return <Widget>[
        Text(item.no.toString()),
        Text(item.nama),
        Text(item.jenisPemasukan),
        Text(dateTimeFormatter.format(item.tanggal)),
        Text(currencyFormatter.format(item.nominal)), // Format nominal
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          tooltip: 'Opsi Lain',
        ),
      ];
    }).toList();

    return BaseLayout(
      title: 'Semua Pemasukan', // AppBar title
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
