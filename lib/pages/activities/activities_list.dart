import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/table.dart';

class ActivitiesListPage extends StatefulWidget {
  const ActivitiesListPage({super.key});

  @override
  State<ActivitiesListPage> createState() => _ActivitiesListPageState();
}

class _ActivitiesListPageState extends State<ActivitiesListPage> {
  bool _isLocaleInitialized = false;

  final List<Map<String, dynamic>> _activities = [
    {
      'no': 1,
      'nama': 'Musy',
      'kategori': 'Komunitas & Sosial',
      'penanggung_jawab': 'Pak',
      'tanggal': DateTime(2025, 10, 12),
    },
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
        title: 'Daftar Kegiatan',
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final headers = [
      'NO',
      'NAMA KEGIATAN',
      'KATEGORI',
      'PENANGGUNG JAWAB',
      'TANGGAL PELAKSANAAN',
      'AKSI',
    ];
    // Tentukan kolom mana yang bisa di-sort
    final sortable = [
      'NAMA KEGIATAN',
      'KATEGORI',
      'PENANGGUNG JAWAB',
      'TANGGAL PELAKSANAAN',
    ];

    // Siapkan data baris untuk tabel
    final rows = _activities.map((activity) {
      return <Widget>[
        Text(activity['no'].toString()),
        Text(activity['nama']),
        Text(activity['kategori']),
        Text(activity['penanggung_jawab']),
        Text(DateFormat('d MMMM yyyy', 'id_ID').format(activity['tanggal'])),
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
      title: 'Daftar Kegiatan', // Judul AppBar
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
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
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
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                  // Gunakan LayoutBuilder untuk mendapatkan lebar parent
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ), // Pastikan tabel minimal selebar parent
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
                        onPressed: () {
                          // Aksi halaman sebelumnya
                        },
                        tooltip: 'Halaman Sebelumnya',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
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
                        onPressed: () {
                          // Aksi halaman berikutnya
                        },
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
