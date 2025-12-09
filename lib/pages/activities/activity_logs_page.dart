import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/data/activity_logs.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  bool _isLocaleInitialized = false;

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
        appBar: StandardAppBar(title: 'Log Aktivitas'),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0891B2)),
        ),
      );
    }

    final dateFormatter = DateFormat('d MMM yyyy HH:mm', 'id_ID');

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Log Aktivitas',
<<<<<<< HEAD
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
=======
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari log aktivitas...',
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
              itemCount: dummyActivityLogs.length,
              itemBuilder: (context, index) {
                final log = dummyActivityLogs[index];
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
                      child: Icon(Icons.history, color: const Color(0xFF0891B2)),
                    ),
                    title: Text(
                      log.description,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Aktor: ${log.actor}'),
                        const SizedBox(height: 4),
                        Text(
                          dateFormatter.format(log.timestamp),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
