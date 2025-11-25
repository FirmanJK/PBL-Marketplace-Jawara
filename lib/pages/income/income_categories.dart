import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/shared/standard_app_bar.dart';

// Dummy data model
class DuesCategory {
  final int no;
  final String nama;
  final String jenis;
  final double nominal;

  DuesCategory({
    required this.no,
    required this.nama,
    required this.jenis,
    required this.nominal,
  });
}

class IncomeCategoriesPage extends StatefulWidget {
  const IncomeCategoriesPage({super.key});

  @override
  State<IncomeCategoriesPage> createState() => _IncomeCategoriesPageState();
}

class _IncomeCategoriesPageState extends State<IncomeCategoriesPage> {
  // Dummy data
  final List<DuesCategory> _categories = [
    DuesCategory(no: 1, nama: 'aaad', jenis: 'Iuran Khusus', nominal: 3000),
    DuesCategory(no: 2, nama: 'yyy', jenis: 'Iuran Bulanan', nominal: 5000),
    DuesCategory(no: 3, nama: 'Harian', jenis: 'Iuran Khusus', nominal: 2),
    DuesCategory(no: 4, nama: 'Kerja Bakti', jenis: 'Iuran Khusus', nominal: 5),
    DuesCategory(
      no: 5,
      nama: 'Bersih Desa',
      jenis: 'Iuran Khusus',
      nominal: 200000,
    ),
    DuesCategory(no: 6, nama: 'Mingguan', jenis: 'Iuran Khusus', nominal: 12),
    DuesCategory(no: 7, nama: 'Agustusan', jenis: 'Iuran Khusus', nominal: 15),
  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Kategori Iuran',
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
          // Info Box
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF0891B2).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: const Color(0xFF0891B2)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Iuran Bulanan: Dibayar setiap bulan. Iuran Khusus: Dibayar sesuai kebutuhan tertentu.',
                    style: TextStyle(fontSize: 13),
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
                hintText: 'Cari kategori iuran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List View
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                      child: Icon(
                        Icons.category,
                        color: const Color(0xFF0891B2),
                      ),
                    ),
                    title: Text(
                      category.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(category.jenis),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(category.nominal),
                          style: TextStyle(
                            color: const Color(0xFF0891B2),
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
          Navigator.pushNamed(context, '/income/categories/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kategori'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
