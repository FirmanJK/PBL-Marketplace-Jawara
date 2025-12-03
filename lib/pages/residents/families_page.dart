import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/pages/residents/family_detail.dart';
import 'package:jawara/utils/toast_helper.dart';
import 'package:jawara/models/family.dart';
import 'package:jawara/services/families_service.dart';

class FamiliesPage extends StatefulWidget {
  const FamiliesPage({super.key});

  @override
  State<FamiliesPage> createState() => _FamiliesPageState();
}

class _FamiliesPageState extends State<FamiliesPage> {
  List<Family> _families = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Data Keluarga'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari keluarga...',
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadFamilies,
                    child: _getFilteredFamilies().isEmpty
                        ? ListView(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    _searchQuery.isEmpty
                                        ? 'Tidak ada data keluarga'
                                        : 'Tidak ada hasil pencarian',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _getFilteredFamilies().length,
                            itemBuilder: (context, index) {
                              final family = _getFilteredFamilies()[index];
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
                                        builder: (context) => FamilyDetailPage(family: family),
                                      ),
                                    );
                                    if (result == true) {
                                      if (!mounted) return;
                                      await _loadFamilies();
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Color.fromRGBO(8, 145, 178, 0.1),
                                          child: const Icon(
                                            Icons.family_restroom,
                                            color: Color(0xFF0891B2),
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                family.namaKeluarga,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                family.headResidentName != null
                                                    ? family.headResidentName!
                                                    : (family.headResidentId != null ? 'Kepala: #${family.headResidentId}' : 'Kepala: -'),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.people,
                                                    size: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    '${family.residentCount} anggota',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    family.createdAt != null ? family.createdAt!.toLocal().toString().split(' ').first : '-',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(33, 150, 243, 0.1),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      '${family.residentCount} anggota',
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  if (family.updatedAt != null) ...[
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(158, 158, 158, 0.1),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        'Terakhir: ${family.updatedAt!.toLocal().toString().split(' ').first}',
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ]
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
        onPressed: () => _showAddFamilyForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Keluarga'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFamilies();
  }

  Future<void> _loadFamilies() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final families = await FamiliesService.getFamilies(skip: 0, limit: 200);
      if (!mounted) return;
      setState(() {
        _families = families;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading families: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ToastHelper.showError(context, 'Gagal memuat keluarga: $e');
      }
    }
  }

  List<Family> _getFilteredFamilies() {
    if (_searchQuery.isEmpty) return _families;
    return _families.where((f) {
      final q = _searchQuery.toLowerCase();
      final headIdStr = f.headResidentId?.toString() ?? '';
      return f.namaKeluarga.toLowerCase().contains(q) || headIdStr.contains(q);
    }).toList();
  }

  void _showAddFamilyForm(BuildContext context) {
    final parentContext = context;
    final namaKeluargaController = TextEditingController();
    final kepalaKeluargaController = TextEditingController();
    final alamatController = TextEditingController();
    String? selectedStatus = 'Pemilik';

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SizedBox(
          width: MediaQuery.of(parentContext).size.width - 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                                  const Color(0xFF0891B2),
                          Color.fromRGBO(8, 145, 178, 0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.family_restroom,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tambah Keluarga',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: namaKeluargaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Keluarga',
                          hintText: 'Masukkan nama keluarga',
                          prefixIcon: const Icon(
                            Icons.people,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: kepalaKeluargaController,
                        decoration: InputDecoration(
                          labelText: 'Kepala Keluarga',
                          hintText: 'Masukkan nama kepala keluarga',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: alamatController,
                        decoration: InputDecoration(
                          labelText: 'Alamat Rumah',
                          hintText: 'Masukkan alamat lengkap',
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status Kepemilikan',
                          prefixIcon: const Icon(
                            Icons.home,
                            color: Color(0xFF0891B2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0891B2),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: ['Pemilik', 'Penyewa'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          selectedStatus = newValue;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                                  onPressed: () => Navigator.of(parentContext).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                      ElevatedButton(
                      onPressed: () async {
                        final familyNumber = namaKeluargaController.text.trim();
                        if (familyNumber.isEmpty) {
                          ToastHelper.showWarning(
                            parentContext,
                            'Mohon lengkapi data keluarga',
                          );
                          return;
                        }

                        // Call API to create family. Use public endpoint when no token.
                        try {
                          await FamiliesService.createFamily({
                            'family_number': familyNumber,
                          });
                          if (!mounted) return;
                                     Navigator.of(parentContext).pop();
                          ToastHelper.showSuccess(
                            parentContext,
                            'Keluarga berhasil ditambahkan',
                          );
                          // Refresh list
                          if (!mounted) return;
                          await _loadFamilies();
                        } catch (e) {
                          if (!mounted) return;
                          ToastHelper.showError(parentContext, 'Gagal menambahkan keluarga: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0891B2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  void _showFamilyDetail(BuildContext context, Family family) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(family.namaKeluarga),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Kepala Keluarga', family.headResidentId != null ? '#${family.headResidentId}' : '-'),
            const SizedBox(height: 8),
            _buildDetailRow('Jumlah Anggota', '${family.residentCount}'),
            const SizedBox(height: 8),
            _buildDetailRow('Dibuat', family.createdAt != null ? family.createdAt!.toLocal().toString().split(' ').first : '-'),
            const SizedBox(height: 8),
            _buildDetailRow('Terakhir diperbarui', family.updatedAt != null ? family.updatedAt!.toLocal().toString().split(' ').first : '-'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Text(': '),
        Expanded(child: Text(value)),
      ],
    );
  }

  // ignore: unused_element
  void _showEditFamilyForm(BuildContext context, Family family) {
    final parentContext = context;
    final namaKeluargaController = TextEditingController(
      text: family.namaKeluarga,
    );
    final kepalaKeluargaController = TextEditingController(
      text: family.headResidentId != null ? '${family.headResidentId}' : '',
    );
    final alamatController = TextEditingController(text: '');
    String? selectedStatus = 'Pemilik';

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Keluarga'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaKeluargaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Keluarga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: kepalaKeluargaController,
                decoration: const InputDecoration(
                  labelText: 'Kepala Keluarga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Rumah',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Kepemilikan',
                  border: OutlineInputBorder(),
                ),
                items: ['Pemilik', 'Penyewa'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedStatus = newValue;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
                        onPressed: () => Navigator.of(parentContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newNumber = namaKeluargaController.text.trim();
              if (newNumber.isEmpty) {
                ToastHelper.showWarning(parentContext, 'Nomor keluarga tidak boleh kosong');
                return;
              }

                          try {
                            await FamiliesService.updateFamily(family.id, {'family_number': newNumber});
                            if (!mounted) return;
                            Navigator.of(parentContext).pop();
                            ToastHelper.showSuccess(parentContext, 'Keluarga berhasil diperbarui');
                            if (!mounted) return;
                            await _loadFamilies();
                          } catch (e) {
                            if (!mounted) return;
                            ToastHelper.showError(parentContext, 'Gagal memperbarui keluarga: $e');
                          }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0891B2),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showDeleteConfirmation(BuildContext context, Family family) {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Keluarga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${family.namaKeluarga}?',
        ),
        actions: [
          TextButton(
                        onPressed: () => Navigator.of(parentContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
                            try {
                              await FamiliesService.deleteFamily(family.id);
                              if (!mounted) return;
                              Navigator.of(parentContext).pop();
                              ToastHelper.showSuccess(
                                parentContext,
                                '${family.namaKeluarga} berhasil dihapus',
                              );
                              if (!mounted) return;
                              await _loadFamilies();
                            } catch (e) {
                              if (!mounted) return;
                              Navigator.of(parentContext).pop();
                              ToastHelper.showError(parentContext, 'Gagal menghapus keluarga: $e');
                            }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}