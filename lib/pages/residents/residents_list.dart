import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/pages/residents/residents_detail.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/services/residents_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class ResidentsListPage extends StatefulWidget {
  const ResidentsListPage({super.key});

  @override
  State<ResidentsListPage> createState() => _ResidentsListPageState();
}

class _ResidentsListPageState extends State<ResidentsListPage> {
  List<Resident> _residents = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() => _isLoading = true);

    try {
      final residents = await ResidentsService.getResidents(
        skip: 0,
        limit: 100,
      );
      setState(() {
        _residents = residents;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading residents: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ToastHelper.showError(context, 'Gagal memuat warga: $e');
      }
    }
  }

  List<Resident> _getFilteredResidents() {
    if (_searchQuery.isEmpty) {
      return _residents;
    }
    return _residents.where((resident) {
      return resident.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resident.nik.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredResidents = _getFilteredResidents();

    return Scaffold(
      appBar: StandardAppBar(title: 'Daftar Warga'),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama, NIK...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredResidents.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'Tidak ada data warga'
                          : 'Tidak ada hasil pencarian',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadResidents,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredResidents.length,
                      itemBuilder: (context, index) {
                        final resident = filteredResidents[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ResidentsDetailPage(resident: resident),
                                ),
                              );
                              // Refresh jika ada perubahan di detail page
                              if (result == true) {
                                _loadResidents();
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: const Color(
                                      0xFF0891B2,
                                    ).withOpacity(0.1),
                                    child: Text(
                                      resident.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFF0891B2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Nama
                                        Text(
                                          resident.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        // NIK
                                        Text(
                                          'NIK: ${resident.nik}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // Status Row
                                        Row(
                                          children: [
                                            // Jenis Kelamin
                                            Icon(
                                              resident.gender == 'Laki-laki'
                                                  ? Icons.male
                                                  : Icons.female,
                                              size: 16,
                                              color:
                                                  resident.gender == 'Laki-laki'
                                                  ? Colors.blue
                                                  : Colors.pink,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              resident.gender,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(width: 16),

                                            // Status
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    resident.status == 'aktif'
                                                    ? Colors.green.withOpacity(
                                                        0.1,
                                                      )
                                                    : Colors.grey.withOpacity(
                                                        0.1,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                resident.status.toUpperCase(),
                                                style: TextStyle(
                                                  color:
                                                      resident.status == 'aktif'
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
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
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/residents/add');
          // Refresh list jika berhasil tambah data
          if (result == true) {
            _loadResidents();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Warga'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }
}
