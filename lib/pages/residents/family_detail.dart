import 'package:flutter/material.dart';
import 'package:jawara/models/family.dart';
<<<<<<< HEAD
import 'package:jawara/utils/toast_helper.dart';

class FamilyDetailPage extends StatelessWidget {
=======
import 'package:jawara/models/resident.dart';
import 'package:jawara/services/residents_service.dart';
import 'package:jawara/services/families_service.dart';
import 'dart:async';
import 'package:jawara/pages/residents/residents_add.dart';
import 'package:jawara/pages/residents/residents_detail.dart';
import 'package:jawara/pages/residents/family_edit.dart';
import 'package:jawara/utils/toast_helper.dart';

class FamilyDetailPage extends StatefulWidget {
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
  final Family family;

  const FamilyDetailPage({super.key, required this.family});

<<<<<<< HEAD
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Keluarga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${family.namaKeluarga}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ToastHelper.showSuccess(
                context,
                '${family.namaKeluarga} berhasil dihapus',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
=======
  @override
  State<FamilyDetailPage> createState() => _FamilyDetailPageState();
}

class _FamilyDetailPageState extends State<FamilyDetailPage> {
  List<Resident> _residents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Langsung load data dummy tanpa loading
    _residents = [
      Resident(
        id: 1,
        name: 'Budi Santoso',
        nik: '3201234567890001',
        gender: 'Laki-laki',
        birthDate: DateTime(1980, 5, 15),
        birthPlace: 'Jakarta',
        religion: 'Islam',
        education: 'S1',
        occupation: 'Pegawai Swasta',
        status: 'aktif',
        familyId: widget.family.id,
        houseId: 1,
      ),
      Resident(
        id: 2,
        name: 'Siti Aminah',
        nik: '3201234567890002',
        gender: 'Perempuan',
        birthDate: DateTime(1985, 8, 20),
        birthPlace: 'Bandung',
        religion: 'Islam',
        education: 'SMA',
        occupation: 'Ibu Rumah Tangga',
        status: 'aktif',
        familyId: widget.family.id,
        houseId: 1,
      ),
    ];
    _isLoading = false;
  }

  Future<void> _loadResidents() async {
    // Langsung gunakan data dummy
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshFamily() async {
    try {
      await FamiliesService.getFamilyById(widget.family.id);
      if (!mounted) return;
      // no-op: we only trigger potential side-effects in the backend, reloads
      setState(() {});
    } catch (_) {}
  }

  Future<void> _deleteResident(Resident resident) async {
    // Perform deletion (assume caller already handled confirmation)
    try {
      await FamiliesService.removeResidentFromFamily(widget.family.id, resident.id);
      if (!mounted) return;
      // Remove locally to avoid refetching the whole list and prevent flashes
      setState(() {
        _residents.removeWhere((r) => r.id == resident.id);
      });
      ToastHelper.showSuccess(context, 'Anggota berhasil dihapus dari keluarga');
      await _refreshFamily();
    } catch (e) {
      if (!mounted) return;
      ToastHelper.showError(context, 'Gagal menghapus anggota: $e');
    }
  }

  void _onAddResident() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => ResidentsAddPage(initialFamilyId: widget.family.id)),
    );
    if (result == true) {
      await _loadResidents();
      await _refreshFamily();
      return;
    }

    // If the page returned a Resident object, append it locally for immediate UI update
    if (result is Resident) {
      setState(() {
        _residents.add(result);
      });
      await _refreshFamily();
    }
  }

  Future<void> _openExistingResidentPicker() async {
    if (!mounted) return;

    // Server-side search with pagination and debounce
    int skip = 0;
    const int pageSize = 25;
    String query = '';
    List<Resident> residents = [];
    bool loading = false;
    Timer? debounce;

    Future<void> fetch() async {
      loading = true;
      setState(() {});
      try {
        final res = await ResidentsService.getResidents(skip: skip, limit: pageSize, query: query.isEmpty ? null : query);
        residents = res.cast<Resident>();
      } catch (e) {
        if (!mounted) return;
        ToastHelper.showError(context, 'Gagal load daftar warga: $e');
      } finally {
        loading = false;
        if (mounted) setState(() {});
      }
    }

    await fetch();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          final filtered = residents;

          return AlertDialog(
            title: const Text('Pilih Warga Terdaftar'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Cari nama atau NIK'),
                    onChanged: (v) {
                      query = v;
                      skip = 0;
                      debounce?.cancel();
                      debounce = Timer(const Duration(milliseconds: 300), () async {
                        await fetch();
                        setStateDialog(() {});
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  if (loading) const Center(child: CircularProgressIndicator()),
                  if (!loading)
                    Flexible(
                      child: filtered.isEmpty
                          ? const Text('Tidak ada hasil')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              itemBuilder: (context, idx) {
                                final item = filtered[idx];
                                return ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(item.nik),
                                  trailing: TextButton(
                                    child: const Text('Tambah'),
                                    onPressed: () async {
                                      try {
                                        final added = await FamiliesService.addResidentToFamily(widget.family.id, item.id);
                                        if (!mounted) return;
                                        // update local list immediately
                                        setState(() {
                                          _residents.add(added);
                                        });
                                        ToastHelper.showSuccess(context, 'Warga berhasil ditambahkan ke keluarga');
                                        Navigator.of(context).pop();
                                        await _refreshFamily();
                                      } catch (e) {
                                        if (!mounted) return;
                                        ToastHelper.showError(context, 'Gagal menambahkan warga: $e');
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: skip - pageSize >= 0
                        ? () async {
                            skip = (skip - pageSize).clamp(0, skip);
                            await fetch();
                            setStateDialog(() {});
                          }
                        : null,
                    child: const Text('Prev'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      skip += pageSize;
                      await fetch();
                      setStateDialog(() {});
                    },
                    child: const Text('Next'),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
                ],
              ),
            ],
          );
        });
      },
    );
    debounce?.cancel();
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    final family = widget.family;
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Keluarga'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 50),
<<<<<<< HEAD
            onSelected: (value) {
              if (value == 'edit') {
                ToastHelper.showInfo(
                  context,
                  'Fitur edit akan segera tersedia',
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(context);
=======
            onSelected: (value) async {
              if (value == 'edit') {
                // Open dedicated edit page where head can be changed from members
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) =>
                        // Temporary placeholder until import resolved
                        FamilyEditPage(family: family, members: _residents),
                  ),
                );
                if (result == true) {
                  await _loadResidents();
                  await _refreshFamily();
                }
              } else if (value == 'delete') {
                // delegate to FamiliesService delete
                final confirm = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Keluarga'),
                    content: Text('Apakah Anda yakin ingin menghapus ${family.namaKeluarga}?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await FamiliesService.deleteFamily(family.id);
                    if (!mounted) return;
                    ToastHelper.showSuccess(context, '${family.namaKeluarga} berhasil dihapus');
                    Navigator.pop(context, true);
                  } catch (e) {
                    if (!mounted) return;
                    ToastHelper.showError(context, 'Gagal menghapus keluarga: $e');
                  }
                }
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
<<<<<<< HEAD
                decoration: BoxDecoration(
=======
              decoration: BoxDecoration(
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(8, 145, 178, 0.1),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
<<<<<<< HEAD
                      decoration: BoxDecoration(
=======
                    decoration: BoxDecoration(
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                      color: Color.fromRGBO(8, 145, 178, 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.family_restroom,
                      size: 60,
                      color: Color(0xFF0891B2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    family.namaKeluarga,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
<<<<<<< HEAD
                    Container(
=======
                  Container(
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(33, 150, 243, 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
<<<<<<< HEAD
                      '${family.residentCount} anggota',
=======
                      '${_residents.length} anggota',
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Detail Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Keluarga',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    icon: Icons.person,
                    label: 'Kepala Keluarga',
<<<<<<< HEAD
                    value: family.headResidentId != null ? '#${family.headResidentId}' : '-',
=======
                    value: (() {
                      if (family.headResidentName != null && family.headResidentName!.isNotEmpty) return family.headResidentName!;
                      if (family.headResidentId == null) return '-';
                      final head = _residents.firstWhere(
                        (r) => r.id == family.headResidentId,
                        orElse: () => Resident(id: -1, name: '', nik: '', gender: '', status: '', familyId: 0, houseId: 0),
                      );
                      return head.id == -1 ? '-' : head.name;
                    })(),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.home,
                    label: 'Dibuat',
                    value: family.createdAt != null ? family.createdAt!.toLocal().toString().split(' ').first : '-',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.update,
                    label: 'Terakhir diperbarui',
                    value: family.updatedAt != null ? family.updatedAt!.toLocal().toString().split(' ').first : '-',
                  ),
                  const SizedBox(height: 12),

<<<<<<< HEAD
                  _buildInfoCard(
                    icon: Icons.numbers,
                    label: 'No',
                    value: family.id.toString(),
                  ),
=======
                  // removed 'No' card per UI request
                  const SizedBox(height: 16),

                  const Text(
                    'Anggota Keluarga',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _residents.isEmpty
                          ? const Text('Belum ada anggota')
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _residents.length,
                              itemBuilder: (context, idx) {
                                final resident = _residents[idx];
                                return Dismissible(
                                  key: ValueKey(resident.id),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 8)),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                                                  child: const Icon(Icons.warning_rounded, color: Colors.red, size: 32),
                                                ),
                                                const SizedBox(height: 16),
                                                const Text('Hapus Anggota dari Keluarga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)), textAlign: TextAlign.center),
                                                const SizedBox(height: 8),
                                                const Text('Anggota akan dihapus dari keluarga. Data warga tidak akan dihapus permanen.', style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4), textAlign: TextAlign.center),
                                                const SizedBox(height: 16),
                                                Container(
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.withOpacity(0.2), width: 1)),
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    Row(children: [Icon(Icons.person_outline, color: Colors.red[500], size: 18), const SizedBox(width: 8), Expanded(child: Text(resident.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1F2937)), maxLines: 2, overflow: TextOverflow.ellipsis))]),
                                                    const SizedBox(height: 8),
                                                    Row(children: [Icon(Icons.badge_outlined, color: Colors.red[500], size: 16), const SizedBox(width: 8), Expanded(child: Text('NIK: ${resident.nik}', style: TextStyle(fontSize: 12, color: Colors.grey[600])))]),
                                                  ]),
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 44,
                                                        child: OutlinedButton(
                                                          onPressed: () => Navigator.pop(context, false),
                                                          style: OutlinedButton.styleFrom(
                                                            side: const BorderSide(
                                                              color: Color(0xFF0891B2),
                                                              width: 1,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Batal',
                                                            style: TextStyle(
                                                              color: Color(0xFF0891B2),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 44,
                                                        child: ElevatedButton(
                                                          onPressed: () => Navigator.pop(context, true),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.red,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            elevation: 0,
                                                            padding: EdgeInsets.zero,
                                                          ),
                                                          child: const Text(
                                                            'Hapus',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    return confirmed ?? false;
                                  },
                                  onDismissed: (direction) async {
                                    await _deleteResident(resident);
                                  },
                                  background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), color: Colors.red.withOpacity(0.08), child: const Icon(Icons.delete_outline, color: Colors.red, size: 20)),
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        final res = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (c) => ResidentsDetailPage(resident: resident),
                                          ),
                                        );
                                        if (res == true) {
                                          await _loadResidents();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                                              child: Text(
                                                resident.name.isNotEmpty ? resident.name[0].toUpperCase() : '?',
                                                style: const TextStyle(
                                                  color: Color(0xFF0891B2),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    resident.name,
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'NIK: ${resident.nik}',
                                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        resident.gender == 'Laki-laki' ? Icons.male : Icons.female,
                                                        size: 16,
                                                        color: resident.gender == 'Laki-laki' ? Colors.blue : Colors.pink,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        resident.gender,
                                                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: resident.status == 'aktif' ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          resident.status.toUpperCase(),
                                                          style: TextStyle(
                                                            color: resident.status == 'aktif' ? Colors.green : Colors.grey,
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
                                            const Icon(Icons.chevron_right),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0891B2), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
