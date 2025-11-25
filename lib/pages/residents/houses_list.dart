import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/shared/theme.dart';

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
    // Tambahkan data lain untuk halaman 2 dst.
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

  int _currentPage = 1;
  final int _rowsPerPage = 10; // Jumlah item per halaman

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

  Widget _buildHouseCard(HouseItem house) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan icon, nama, dan status
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  child: const Icon(
                    Icons.home,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        house.alamat,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rumah #${house.no}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(house.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    house.status,
                    style: TextStyle(
                      color: _getStatusColor(house.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Detail alamat
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Alamat',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Text(
                house.alamat,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Detail status
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: _getStatusColor(house.status),
                ),
                const SizedBox(width: 8),
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Text(
                house.status,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(house.status),
                ),
              ),
            ),
            // Menu button
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {
                  _showOptionsMenu(house);
                },
                tooltip: 'Opsi',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(HouseItem house) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Lihat Detail'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to detail
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  // Show delete confirmation
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Daftar Rumah',
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _houses.length,
                itemBuilder: (context, index) {
                  final house = _houses[index];
                  return _buildHouseCard(house);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/residents/houses/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Rumah'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
