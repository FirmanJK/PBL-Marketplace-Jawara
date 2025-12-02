import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/shared/theme.dart';
import 'package:jawara/pages/residents/house_detail.dart';

// Dummy data model
class HouseItem {
  final int no;
  final String alamat;
  final String status; // Ditempati, Tersedia

  HouseItem({required this.no, required this.alamat, required this.status});
}

class HousesListPage extends StatefulWidget {
  const HousesListPage({super.key});

  @override
  State<HousesListPage> createState() => _HousesListPageState();
}

class _HousesListPageState extends State<HousesListPage> {
  // Dummy data sesuai screenshot
  final List<HouseItem> _houses = [
    HouseItem(no: 1, alamat: 'aaaaa', status: 'Ditempati'),
    HouseItem(no: 2, alamat: 'jalan sehat', status: 'Ditempati'),
    HouseItem(no: 3, alamat: 'i', status: 'Ditempati'),
    HouseItem(no: 4, alamat: 'Tes', status: 'Ditempati'),
    HouseItem(no: 5, alamat: 'Jl. Merbabu', status: 'Tersedia'),
    HouseItem(no: 6, alamat: 'Malang', status: 'Ditempati'),
    HouseItem(no: 7, alamat: 'Griyashanta L203', status: 'Ditempati'),
    HouseItem(no: 8, alamat: 'wwrwr', status: 'Tersedia'),
    HouseItem(no: 9, alamat: 'Jl Baru bangun', status: 'Ditempati'),
    HouseItem(no: 10, alamat: 'fasde', status: 'Tersedia'),
    HouseItem(no: 11, alamat: 'Alamat 11', status: 'Ditempati'),
    HouseItem(no: 12, alamat: 'Alamat 12', status: 'Tersedia'),
    HouseItem(no: 13, alamat: 'Alamat 13', status: 'Ditempati'),
    HouseItem(no: 14, alamat: 'Alamat 14', status: 'Ditempati'),
    HouseItem(no: 15, alamat: 'Alamat 15', status: 'Tersedia'),
    HouseItem(no: 16, alamat: 'Alamat 16', status: 'Ditempati'),
    HouseItem(no: 17, alamat: 'Alamat 17', status: 'Ditempati'),
    HouseItem(no: 18, alamat: 'Alamat 18', status: 'Tersedia'),
    HouseItem(no: 19, alamat: 'Alamat 19', status: 'Ditempati'),
    HouseItem(no: 20, alamat: 'Alamat 20', status: 'Ditempati'),
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ditempati':
        return Colors.blue;
      case 'tersedia':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Daftar Rumah',
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari alamat rumah...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Implement search
              },
            ),
          ),

          // List View
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Reload data
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _houses.length,
                itemBuilder: (context, index) {
                  final house = _houses[index];
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
                            builder: (context) => HouseDetailPage(house: house),
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
                              backgroundColor: AppTheme.primary.withOpacity(0.1),
                              child: const Icon(
                                Icons.home,
                                color: AppTheme.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    house.alamat,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rumah #${house.no}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(house.status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      house.status,
                                      style: TextStyle(
                                        color: _getStatusColor(house.status),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/houses/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Rumah'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
