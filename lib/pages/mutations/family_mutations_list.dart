import 'package:flutter/material.dart';
import 'package:jawara/data/mutations.dart';

import 'package:jawara/shared/standard_app_bar.dart';
import 'family_mutations_detail.dart';

class FamilyMutationsListPage extends StatefulWidget {
  const FamilyMutationsListPage({super.key});

  @override
  State<FamilyMutationsListPage> createState() =>
      _FamilyMutationsListPageState();
}

class _FamilyMutationsListPageState extends State<FamilyMutationsListPage> {
  Widget _buildStatusChip(String jenisMutasi) {
    Color color;
    Color textColor;

    if (jenisMutasi.contains('Keluar')) {
      color = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFEF4444);
    } else if (jenisMutasi.contains('Pindah')) {
      color = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF047857);
    } else {
      color = const Color(0xFFE5E7EB);
      textColor = const Color(0xFF4B5563);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        jenisMutasi,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Daftar Mutasi Keluarga'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari mutasi keluarga...',
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
              itemCount: mutationList.length,
              itemBuilder: (context, index) {
                final mutation = mutationList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: mutation.jenisMutasi == 'Keluar Wilayah'
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      child: Icon(
                        mutation.jenisMutasi == 'Keluar Wilayah'
                            ? Icons.exit_to_app
                            : Icons.swap_horiz,
                        color: mutation.jenisMutasi == 'Keluar Wilayah'
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    title: Text(
                      mutation.keluarga,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Tanggal: ${mutation.tanggal}'),
                        const SizedBox(height: 8),
                        _buildStatusChip(mutation.jenisMutasi),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FamilyMutationsDetailPage(mutation: mutation),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              FamilyMutationsDetailPage(mutation: mutation),
                        ),
                      );
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
          Navigator.pushNamed(context, '/family-mutations/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Mutasi'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
