import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/pages/residents/residents_detail.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/services/database_service.dart';

// Dummy data model untuk halaman ini
class ResidentListItem {
  final int no;
  final String nama;
  final String nik;
  final String keluarga;
  final String jenisKelamin;
  final String statusDomisili; // Aktif, Nonaktif
  final String statusHidup; // Hidup, Wafat

  ResidentListItem({
    required this.no,
    required this.nama,
    required this.nik,
    required this.keluarga,
    required this.jenisKelamin,
    required this.statusDomisili,
    required this.statusHidup,
  });
}

class ResidentsListPage extends StatefulWidget {
  const ResidentsListPage({super.key});

  @override
  State<ResidentsListPage> createState() => _ResidentsListPageState();
}

class _ResidentsListPageState extends State<ResidentsListPage> {
  List<ResidentListItem> _residents = [];
  bool _isLoading = true;
  final _dummyResidents = [
    ResidentListItem(
      no: 1,
      nama: 'yyyyy',
      nik: '1234567891234567',
      keluarga: 'Keluarga Mara Nunez',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 2,
      nama: 'Varizky Naldiba Rimra',
      nik: '1371111011030005',
      keluarga: 'Keluarga Varizky Naldiba Rimra',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 3,
      nama: 'Tes',
      nik: '2222222222222222',
      keluarga: 'Keluarga Tes',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Wafat',
    ),
    ResidentListItem(
      no: 4,
      nama: 'Farhan',
      nik: '456789086456456',
      keluarga: 'Keluarga Farhan',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 5,
      nama: 'Rendha Putra Rahmadya',
      nik: '3505111512040002',
      keluarga: 'Keluarga Rendha Putra Rahmadya',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 6,
      nama: 'Anti Micin',
      nik: '1234567890987654',
      keluarga: 'Keluarga Anti Micin',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 7,
      nama: 'varizky naldiba rimra',
      nik: '1234123412341234',
      keluarga: 'Keluarga varizky naldiba rimra',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 8,
      nama: 'lalalal',
      nik: '1234567890123456',
      keluarga: 'Keluarga Ijat',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Nonaktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 9,
      nama: 'Ijat',
      nik: '2025202520252025',
      keluarga: 'Keluarga Ijat',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Nonaktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 10,
      nama: 'Raudhil Firdaus Naufal',
      nik: '3201122501050002',
      keluarga: 'Keluarga Raudhil Firdaus Naufal',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    // Tambahkan data lain untuk halaman 2 dst.
    ResidentListItem(
      no: 11,
      nama: 'Warga 11',
      nik: '1111111111111111',
      keluarga: 'Keluarga 11',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
    ResidentListItem(
      no: 12,
      nama: 'Warga 12',
      nik: '1212121212121212',
      keluarga: 'Keluarga 12',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() => _isLoading = true);
    
    try {
      final dbService = DatabaseService();
      final results = await dbService.query('residents', orderBy: 'created_at DESC');
      
      setState(() {
        _residents = results.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return ResidentListItem(
            no: index + 1,
            nama: data['name'] as String? ?? '',
            nik: data['nik'] as String? ?? '',
            keluarga: 'Keluarga ${data['name']}',
            jenisKelamin: data['gender'] as String? ?? 'Laki-laki',
            statusDomisili: 'Aktif',
            statusHidup: 'Hidup',
          );
        }).toList();
        
        // Jika database kosong, gunakan dummy data
        if (_residents.isEmpty) {
          _residents = _dummyResidents;
        }
        
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading residents: $e');
      setState(() {
        _residents = _dummyResidents;
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'hidup':
        return Colors.green;
      case 'nonaktif':
      case 'wafat':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChip(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Daftar Warga',
      ),
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
                // Implement search
              },
            ),
          ),

          // List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadResidents,
                    child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _residents.length,
                itemBuilder: (context, index) {
                  final resident = _residents[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Convert ResidentListItem to Resident model
                        final residentModel = Resident(
                          id: resident.no,
                          name: resident.nama,
                          nik: resident.nik,
                          email: '${resident.nama.toLowerCase().replaceAll(' ', '')}@example.com',
                          gender: resident.jenisKelamin,
                          status: resident.statusDomisili,
                          registrationStatus: resident.statusDomisili == 'Aktif' 
                              ? RegistrationStatus.accepted 
                              : RegistrationStatus.inactive,
                          phone: null,
                          birthDate: null,
                          address: null,
                          familyId: null,
                          photoUrl: null,
                        );
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResidentsDetailPage(resident: residentModel),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                              child: Text(
                                resident.nama[0].toUpperCase(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nama
                                  Text(
                                    resident.nama,
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
                                  const SizedBox(height: 4),
                                  
                                  // Keluarga
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.family_restroom,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          resident.keluarga,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Status Row
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      // Jenis Kelamin
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            resident.jenisKelamin == 'Laki-laki'
                                                ? Icons.male
                                                : Icons.female,
                                            size: 16,
                                            color: resident.jenisKelamin == 'Laki-laki'
                                                ? Colors.blue
                                                : Colors.pink,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            resident.jenisKelamin,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      // Status Domisili
                                      _buildStatusChip(resident.statusDomisili),
                                      
                                      // Status Hidup
                                      _buildStatusChip(resident.statusHidup),
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
