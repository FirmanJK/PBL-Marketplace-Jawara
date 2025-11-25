import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/shared/responsive_grid_view.dart';

class FamilyItem {
  final int no;
  final String namaKeluarga;
  final String kepalaKeluarga;
  final String alamatRumah;
  final String statusKepemilikan;
  final String status;

  FamilyItem({
    required this.no,
    required this.namaKeluarga,
    required this.kepalaKeluarga,
    required this.alamatRumah,
    required this.statusKepemilikan,
    required this.status,
  });
}

class FamiliesPage extends StatefulWidget {
  const FamiliesPage({super.key});

  @override
  State<FamiliesPage> createState() => _FamiliesPageState();
}

class _FamiliesPageState extends State<FamiliesPage> {
  final List<FamilyItem> _families = [
    FamilyItem(no: 1, namaKeluarga: 'Keluarga Varizky Naldiba Rimra', kepalaKeluarga: 'Varizky Naldiba Rimra', alamatRumah: 'i', statusKepemilikan: 'Pemilik', status: 'Aktif'),
    FamilyItem(no: 2, namaKeluarga: 'Keluarga Tes', kepalaKeluarga: 'Tes', alamatRumah: 'tes', statusKepemilikan: 'Penyewa', status: 'Aktif'),
    FamilyItem(no: 3, namaKeluarga: 'Keluarga Farhan', kepalaKeluarga: 'Farhan', alamatRumah: 'Griyashanta L203', statusKepemilikan: 'Pemilik', status: 'Aktif'),
    FamilyItem(no: 4, namaKeluarga: 'Keluarga Rendha Putra Rahmadya', kepalaKeluarga: 'Rendha Putra Rahmadya', alamatRumah: 'Malang', statusKepemilikan: 'Pemilik', status: 'Aktif'),
    FamilyItem(no: 5, namaKeluarga: 'Keluarga Anti Micin', kepalaKeluarga: 'Anti Micin', alamatRumah: 'malang', statusKepemilikan: 'Penyewa', status: 'Aktif'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Data Keluarga',
        actions: [IconButton(icon: const Icon(Icons.filter_alt), onPressed: () {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari keluarga...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ResponsiveListView<FamilyItem>(
              items: _families,
              itemBuilder: (context, family, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                      child: const Icon(Icons.family_restroom, color: Color(0xFF0891B2)),
                    ),
                    title: Text(family.namaKeluarga, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${family.kepalaKeluarga}\n${family.alamatRumah}'),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(family.status, style: const TextStyle(fontSize: 11)),
                      backgroundColor: family.status == 'Aktif' ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
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
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Tambah Keluarga'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
