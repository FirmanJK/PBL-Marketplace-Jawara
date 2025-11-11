import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart';
import 'package:jawara/shared/theme.dart';

class BroadcastMessage {
  final int no;
  final String pengirim;
  final String judul;
  final DateTime tanggal;

  BroadcastMessage({
    required this.no,
    required this.pengirim,
    required this.judul,
    required this.tanggal,
  });
}

class BroadcastListPage extends StatefulWidget {
  const BroadcastListPage({super.key});

  @override
  State<BroadcastListPage> createState() => _BroadcastListPageState();
}

class _BroadcastListPageState extends State<BroadcastListPage> {
  bool _isLocaleInitialized = false;

  final List<BroadcastMessage> _broadcasts = [
    BroadcastMessage(
      no: 1,
      pengirim: 'Admin Jawara',
      judul: 'Pengumuman',
      tanggal: DateTime(2025, 10, 21),
    ),
    BroadcastMessage(
      no: 2,
      pengirim: 'Admin Jawara',
      judul: 'DJ BAWS',
      tanggal: DateTime(2025, 10, 17),
    ),
    BroadcastMessage(
      no: 3,
      pengirim: 'Admin Jawara',
      judul: 'gotong royong',
      tanggal: DateTime(2025, 10, 14),
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
        title: 'Daftar Broadcast',
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final headers = ['NO', 'PENGIRIM', 'JUDUL', 'TANGGAL', 'AKSI'];
    final sortable = ['PENGIRIM', 'JUDUL', 'TANGGAL'];

    // Siapkan data baris untuk tabel
    final rows = _broadcasts.map((broadcast) {
      return <Widget>[
        Text(broadcast.no.toString()),
        Text(broadcast.pengirim),
        Text(broadcast.judul),
        Text(DateFormat('d MMMM yyyy', 'id_ID').format(broadcast.tanggal)),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            // Aksi detail/edit/hapus
          },
          tooltip: 'Opsi Lain',
        ),
      ];
    }).toList();

    return BaseLayout(
      title: 'Daftar Broadcast', // Judul AppBar
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Padding utama konten
        child: Column(
          children: [
            // Container putih sebagai Card utama
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    AppTheme.borderRadiusXLarge, // Menggunakan dari tema
                boxShadow: AppTheme.shadowMedium, // Menggunakan dari tema
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Baris Header dengan tombol Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Aksi filter
                        },
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
                          backgroundColor: AppTheme.primary, // Dari tema
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                AppTheme.borderRadiusSmall, // Dari tema
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

                  // Tabel Data
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ), // Lebar minimal
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

                  // Kontrol Pagination
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
                          color: AppTheme.primary, // Dari tema
                          borderRadius: AppTheme.borderRadiusSmall, // Dari tema
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
