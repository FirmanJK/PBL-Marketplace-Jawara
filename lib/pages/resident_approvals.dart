import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/data/residents.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/shared/table.dart';

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

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headers = [
      'NO',
      'NAMA',
      'NIK',
      'EMAIL',
      'JENIS KELAMIN',
      'FOTO IDENTITAS',
      'STATUS REGISTRASI',
      'AKSI',
    ];
    final sortable = ['NAMA', 'EMAIL', 'STATUS REGISTRASI'];

    final rows = dummyResidents.map((resident) {
      return <Widget>[
        Text(resident.id.toString()),
        Text(resident.name, overflow: TextOverflow.ellipsis),
        Text(resident.nik, overflow: TextOverflow.ellipsis),
        Text(resident.email, overflow: TextOverflow.ellipsis),
        Text(resident.gender, overflow: TextOverflow.ellipsis),
        TextButton(onPressed: () {}, child: const Text('Lihat')),
        _buildStatusChip(resident.status),
        Row(
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
      ];
    }).toList();

    return BaseLayout(
      title: 'Penerimaan Warga',
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F7FC),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CustomDataTable(
                      headers: headers,
                      rows: rows,
                      sortable: sortable,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
