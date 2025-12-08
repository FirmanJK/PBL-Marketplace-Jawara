import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';

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
      return Scaffold(
        appBar: StandardAppBar(title: 'Daftar Kegiatan'),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Daftar Kegiatan',
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                      child: Icon(Icons.event, color: const Color(0xFF0891B2)),
                    ),
                    title: Text(
                      activity['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(activity['kategori']),
                        const SizedBox(height: 4),
                        Text(
                          'PJ: ${activity['penanggung_jawab']}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormatter.format(activity['tanggal']),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navigate to activity detail page
                    },
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
