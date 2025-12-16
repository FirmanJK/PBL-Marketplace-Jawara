import 'package:flutter/material.dart';
import 'package:jawara/services/mutations_service.dart';

import 'package:jawara/shared/standard_app_bar.dart';
import 'family_mutations_detail.dart';

class FamilyMutationsListPage extends StatefulWidget {
  const FamilyMutationsListPage({super.key});

  @override
  State<FamilyMutationsListPage> createState() =>
      _FamilyMutationsListPageState();
}

class _FamilyMutationsListPageState extends State<FamilyMutationsListPage> {
  List mutationList = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMutations();
  }

  Future<void> _loadMutations() async {
    setState(() => _isLoading = true);
    try {
      final muts = await MutationsService.getMutations();
      setState(() {
        mutationList = muts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStatusChip(String jenisMutasi) {
    final raw = jenisMutasi ?? '';
    final key = raw.toLowerCase();

    // Normalize label: convert snake_case or lowercase codes to Title Case
    String _formatLabel(String s) {
      if (s.trim().isEmpty) return 'Unknown';
      final replaced = s.replaceAll('_', ' ').trim();
      return replaced
          .split(RegExp(r"\s+"))
          .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
    }

    final label = _formatLabel(raw);

    Color background;
    Color textColor;

    if (key.contains('keluar')) {
      background = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFEF4444);
    } else if (key.contains('pindah') || key.contains('masuk')) {
      background = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF047857);
    } else {
      background = const Color(0xFFE5E7EB);
      textColor = const Color(0xFF4B5563);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
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
              onChanged: (v) {
                setState(() {
                  _searchQuery = v.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Builder(
                    builder: (context) {
                      // Build filtered list once so itemCount matches
                      final filtered = mutationList.where((m) {
                        final jm = (m.jenisMutasi ?? '')
                            .toString()
                            .toLowerCase();
                        final keluarga = (m.keluarga ?? '')
                            .toString()
                            .toLowerCase();
                        final alamatLama = (m.alamatLama ?? '')
                            .toString()
                            .toLowerCase();
                        final alamatBaru = (m.alamatBaru ?? '')
                            .toString()
                            .toLowerCase();
                        final tanggal = (m.tanggal ?? '')
                            .toString()
                            .toLowerCase();
                        final q = _searchQuery;
                        if (q.isEmpty) return true;
                   // If the query is purely numeric, treat it as a family id search only
                   final numeric = RegExp(r'^\d+$').hasMatch(q);
                   if (numeric) {
                   // extract digits from keluarga label (e.g. 'Keluarga #12' -> '12')
                   final famDigitsMatch = RegExp(r"\d+").firstMatch(keluarga);
                   final famDigits = famDigitsMatch?.group(0) ?? '';
                   return famDigits.contains(q);
                   }
                   return jm.contains(q) || keluarga.contains(q) || alamatLama.contains(q) || alamatBaru.contains(q) || tanggal.contains(q);
                      }).toList();

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada mutasi yang cocok'),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final mutation = filtered[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor:
                                    (mutation.jenisMutasi ?? '')
                                        .toString()
                                        .toLowerCase()
                                        .contains('keluar')
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                child: Icon(
                                  (mutation.jenisMutasi ?? '')
                                          .toString()
                                          .toLowerCase()
                                          .contains('keluar')
                                      ? Icons.exit_to_app
                                      : Icons.swap_horiz,
                                  color:
                                      (mutation.jenisMutasi ?? '')
                                          .toString()
                                          .toLowerCase()
                                          .contains('keluar')
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                              title: Text(
                                mutation.keluarga,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FamilyMutationsDetailPage(
                                            mutation: mutation,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FamilyMutationsDetailPage(
                                          mutation: mutation,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pushNamed(context, '/family-mutations/add');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Mutasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
