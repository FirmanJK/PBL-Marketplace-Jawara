import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/pages/income/category_detail.dart';

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
      ),
      body: Column(
        children: [
          // Info Box
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF0891B2).withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF0891B2), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Iuran Bulanan: Dibayar setiap bulan. Iuran Khusus: Dibayar sesuai kebutuhan tertentu.',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailPage(category: category),
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
                            backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                            child: const Icon(
                              Icons.category,
                              color: Color(0xFF0891B2),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category.jenis,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currencyFormatter.format(category.nominal),
                                  style: const TextStyle(
                                    color: Color(0xFF0891B2),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
        onPressed: () => _showAddCategoryForm(context),
<<<<<<< HEAD
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kategori'),
=======
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Kategori', style: TextStyle(color: Colors.white)),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }

  void _showAddCategoryForm(BuildContext context) {
    final namaController = TextEditingController();
    final nominalController = TextEditingController();
    String? selectedJenis = 'Iuran Bulanan';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
                maxWidth: 500,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0891B2),
                          const Color(0xFF0891B2).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Tambah Kategori',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: namaController,
                            decoration: InputDecoration(
                              labelText: 'Nama Kategori',
                              prefixIcon: const Icon(Icons.label, color: Color(0xFF0891B2)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF0891B2), width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedJenis,
                            decoration: InputDecoration(
                              labelText: 'Jenis',
                              prefixIcon: const Icon(Icons.category, color: Color(0xFF0891B2)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF0891B2), width: 2),
                              ),
                            ),
                            items: ['Iuran Bulanan', 'Iuran Khusus'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              selectedJenis = newValue;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: nominalController,
                            decoration: InputDecoration(
                              labelText: 'Nominal',
                              prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF0891B2)),
                              prefixText: 'Rp ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF0891B2), width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Actions
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Batal',
<<<<<<< HEAD
                            style: TextStyle(fontSize: 16, color: Colors.grey),
=======
                            style: TextStyle(fontSize: 16, color: Colors.black),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (namaController.text.isNotEmpty && nominalController.text.isNotEmpty) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kategori berhasil ditambahkan'),
                                  backgroundColor: Color(0xFF0891B2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0891B2),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
<<<<<<< HEAD
                          child: const Text('Simpan', style: TextStyle(fontSize: 16)),
=======
                          child: const Text('Simpan', style: TextStyle(fontSize: 16, color: Colors.white)),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
