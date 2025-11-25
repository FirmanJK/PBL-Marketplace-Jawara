import 'package:flutter/material.dart';
import 'package:jawara/data/residents.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class ResidentApprovalsPage extends StatefulWidget {
  const ResidentApprovalsPage({super.key});

  @override
  State<ResidentApprovalsPage> createState() => _ResidentApprovalsPageState();
}

class _ResidentApprovalsPageState extends State<ResidentApprovalsPage> {
  Widget _buildStatusChip(RegistrationStatus status) {
    Color color;
    String label;
    switch (status) {
      case RegistrationStatus.accepted:
        color = Colors.green;
        label = 'Diterima';
        break;
      case RegistrationStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        break;
      case RegistrationStatus.inactive:
        color = Colors.grey;
        label = 'Nonaktif';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Penerimaan Warga',
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari permohonan...',
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
              itemCount: dummyResidents.length,
              itemBuilder: (context, index) {
                final resident = dummyResidents[index];
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
                      child: Icon(Icons.person_add, color: const Color(0xFF0891B2)),
                    ),
                    title: Text(
                      resident.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('NIK: ${resident.nik}'),
                        const SizedBox(height: 4),
                        Text('Email: ${resident.email}'),
                        const SizedBox(height: 8),
                        _buildStatusChip(resident.registrationStatus),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {},
                          tooltip: 'Terima',
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {},
                          tooltip: 'Tolak',
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
