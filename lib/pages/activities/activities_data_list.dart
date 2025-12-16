import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class ActivitiesDataListPage extends StatefulWidget {
  const ActivitiesDataListPage({super.key});

  @override
  State<ActivitiesDataListPage> createState() => _ActivitiesDataListPageState();
}

class _ActivitiesDataListPageState extends State<ActivitiesDataListPage> {
  bool _isLocaleInitialized = false;

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifikasi Kegiatan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              'Kegiatan Diperbarui',
              'Gotong royong bulanan telah diperbarui',
              '1 jam yang lalu',
              Icons.update,
              Colors.blue,
            ),
            _buildNotificationItem(
              'Kegiatan Baru',
              'Senam pagi minggu depan telah ditambahkan',
              '3 jam yang lalu',
              Icons.event_available,
              Colors.green,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'search':
        _showSearchDialog(context);
        break;
      case 'filter':
        _showFilterDialog(context);
        break;
      case 'sort':
        _showSortDialog(context);
        break;
      case 'add':
        Navigator.pushNamed(context, '/activities/add');
        break;
      case 'export':
        _showExportDialog(context);
        break;
    }
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.search, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Cari Kegiatan'),
          ],
        ),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Masukkan nama kegiatan...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pencarian berhasil dilakukan'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
            child: const Text('Cari', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.filter_list, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Filter Kegiatan'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Kegiatan Aktif'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
            CheckboxListTile(
              title: const Text('Kegiatan Terjadwal'),
              value: false,
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter berhasil diterapkan'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
            child: const Text('Terapkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.sort, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Urutkan Kegiatan'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Tanggal Terbaru'),
              value: 'date_desc',
              groupValue: 'date_desc',
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
            RadioListTile<String>(
              title: const Text('Nama A-Z'),
              value: 'name_asc',
              groupValue: 'date_desc',
              onChanged: (value) {},
              activeColor: const Color(0xFF0891B2),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengurutan berhasil diterapkan'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2)),
            child: const Text('Terapkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.download, color: Color(0xFF0891B2)),
            SizedBox(width: 8),
            Text('Export Data'),
          ],
        ),
        content: const Text('Pilih format export data kegiatan:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil diexport ke PDF'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('PDF', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil diexport ke Excel'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Excel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _activities = [
    {
      'no': 1,
      'nama': 'Gotong Royong Bulanan',
      'kategori': 'Komunitas & Sosial',
      'penanggung_jawab': 'Pak Budi',
      'tanggal': DateTime(2025, 10, 12),
      'status': 'Aktif',
    },
    {
      'no': 2,
      'nama': 'Rapat RT Bulanan',
      'kategori': 'Administrasi',
      'penanggung_jawab': 'Pak Ketua RT',
      'tanggal': DateTime(2025, 10, 15),
      'status': 'Terjadwal',
    },
    {
      'no': 3,
      'nama': 'Senam Pagi Warga',
      'kategori': 'Kesehatan',
      'penanggung_jawab': 'Bu Sari',
      'tanggal': DateTime(2025, 10, 20),
      'status': 'Aktif',
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

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;
    if (status.toLowerCase() == 'aktif') {
      chipColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else if (status.toLowerCase() == 'terjadwal') {
      chipColor = Colors.blue.shade100;
      textColor = Colors.blue.shade800;
    } else {
      chipColor = Colors.grey.shade100;
      textColor = Colors.grey.shade800;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Kegiatan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF0891B2),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            // Notification Icon
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () => _showNotifications(context),
                  tooltip: 'Notifikasi',
                ),
                // Notification Badge
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            
            // Dropdown Menu (Three Dots)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              tooltip: 'Menu',
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) => _handleMenuSelection(context, value),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'search',
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFF0891B2), size: 20),
                      SizedBox(width: 12),
                      Text('Cari Kegiatan', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'filter',
                  child: Row(
                    children: [
                      Icon(Icons.filter_list, color: Color(0xFF0891B2), size: 20),
                      SizedBox(width: 12),
                      Text('Filter', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'sort',
                  child: Row(
                    children: [
                      Icon(Icons.sort, color: Color(0xFF0891B2), size: 20),
                      SizedBox(width: 12),
                      Text('Urutkan', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'add',
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Color(0xFF10B981), size: 20),
                      SizedBox(width: 12),
                      Text('Tambah Kegiatan', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download, color: Color(0xFF0891B2), size: 20),
                      SizedBox(width: 12),
                      Text('Export Data', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kegiatan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Notification Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => _showNotifications(context),
                tooltip: 'Notifikasi',
              ),
              // Notification Badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          
          // Dropdown Menu (Three Dots)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            tooltip: 'Menu',
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Cari Kegiatan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(Icons.filter_list, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Filter', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Urutkan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Tambah Kegiatan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Export Data', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kegiatan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to activity detail page
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                            child: const Icon(
                              Icons.event,
                              color: Color(0xFF6366F1),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activity['kategori'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'PJ: ${activity['penanggung_jawab']} • ${dateFormatter.format(activity['tanggal'])}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildStatusChip(activity['status']),
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
        onPressed: () {
          Navigator.pushNamed(context, '/activities/add');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Kegiatan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}