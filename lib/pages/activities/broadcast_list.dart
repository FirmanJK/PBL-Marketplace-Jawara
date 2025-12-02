import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';

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
      return Scaffold(
        appBar: StandardAppBar(title: 'Daftar Broadcast'),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Daftar Broadcast',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari broadcast...',
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
              itemCount: _broadcasts.length,
              itemBuilder: (context, index) {
                final broadcast = _broadcasts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.withOpacity(0.1),
                      child: Icon(Icons.campaign, color: Colors.purple),
                    ),
                    title: Text(
                      broadcast.judul,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Pengirim: ${broadcast.pengirim}'),
                        const SizedBox(height: 4),
                        Text(
                          dateFormatter.format(broadcast.tanggal),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navigate to broadcast detail page
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
          Navigator.pushNamed(context, '/activities/broadcast/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Broadcast'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
