import 'package:flutter/material.dart';
import 'package:jawara/data/residents.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/models/user_role.dart';
import 'package:jawara/shared/responsive_grid_view.dart';
import 'package:jawara/shared/role_guard.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class ResidentsGridPage extends StatefulWidget {
  const ResidentsGridPage({super.key});

  @override
  State<ResidentsGridPage> createState() => _ResidentsGridPageState();
}

class _ResidentsGridPageState extends State<ResidentsGridPage> {
  List<Resident> _residents = [];
  List<Resident> _filteredResidents = [];
  bool _isLoading = true;
  String _searchQuery = '';
  RegistrationStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() => _isLoading = true);

    // Simulasi loading dari API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _residents = dummyResidents;
      _filteredResidents = _residents;
      _isLoading = false;
    });
  }

  void _filterResidents() {
    setState(() {
      _filteredResidents = _residents.where((resident) {
        final matchesSearch =
            resident.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            resident.nik.contains(_searchQuery) ||
            resident.email.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesStatus =
            _filterStatus == null || resident.status == _filterStatus;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Color _getStatusColor(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.accepted:
        return Colors.green;
      case RegistrationStatus.pending:
        return Colors.orange;
      case RegistrationStatus.inactive:
        return Colors.grey;
    }
  }

  String _getStatusLabel(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.accepted:
        return 'Aktif';
      case RegistrationStatus.pending:
        return 'Pending';
      case RegistrationStatus.inactive:
        return 'Nonaktif';
    }
  }

  void _showResidentMenu(Resident resident) {
    // TODO: Implement permission checking in AuthService
    // final canEdit = authService.hasPermission(AppModule.dataWarga, edit: true);
    // final canDelete = authService.hasPermission(AppModule.dataWarga, delete: true);
    const bool canEdit = true;
    const bool canDelete = true;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility, color: Color(0xFF0891B2)),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                _viewDetail(resident);
              },
            ),
            if (canEdit)
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF0891B2)),
                title: const Text('Edit Data'),
                onTap: () {
                  Navigator.pop(context);
                  _editResident(resident);
                },
              ),
            if (canDelete)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Hapus Data',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(resident);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _viewDetail(Resident resident) {
    // TODO: Navigate to detail page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Detail: ${resident.name}')));
  }

  void _editResident(Resident resident) {
    // TODO: Navigate to edit page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit: ${resident.name}')));
  }

  void _confirmDelete(Resident resident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${resident.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteResident(resident);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteResident(Resident resident) {
    setState(() {
      _residents.removeWhere((r) => r.id == resident.id);
      _filterResidents();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data warga berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement permission checking in AuthService
    // final canAdd = authService.hasPermission(AppModule.dataWarga, create: true);

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Data Warga',
        actions: [
          // Filter button
          IconButton(
            icon: Icon(
              _filterStatus != null
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama, NIK, atau email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _filterResidents();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterResidents();
                });
              },
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredResidents.length} warga ditemukan',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                if (_filterStatus != null) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      _getStatusLabel(_filterStatus!),
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: _getStatusColor(
                      _filterStatus!,
                    ).withOpacity(0.1),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _filterStatus = null;
                        _filterResidents();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Grid View
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadResidents,
              child: ResponsiveGridView<Resident>(
                items: _filteredResidents,
                isLoading: _isLoading,
                minItemWidth: 300,
                childAspectRatio: 0.85,
                itemBuilder: (context, resident, index) {
                  return GridItemCard(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0891B2).withOpacity(0.1),
                      child: Text(
                        resident.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF0891B2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: resident.name,
                    subtitle: resident.email,
                    statusColor: _getStatusColor(resident.registrationStatus),
                    statusLabel: _getStatusLabel(resident.registrationStatus),
                    details: [
                      DetailRow(
                        icon: Icons.badge_outlined,
                        label: 'NIK',
                        value: resident.nik,
                      ),
                      DetailRow(
                        icon: resident.gender == 'L'
                            ? Icons.male
                            : Icons.female,
                        label: 'Jenis Kelamin',
                        value: resident.gender == 'L'
                            ? 'Laki-laki'
                            : 'Perempuan',
                        iconColor: resident.gender == 'L'
                            ? Colors.blue
                            : Colors.pink,
                      ),
                    ],
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () => _showResidentMenu(resident),
                        tooltip: 'Opsi',
                      ),
                    ],
                    onTap: () => _viewDetail(resident),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: RoleGuard(
        requiredModule: AppModule.dataWarga,
        requireCreate: true,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/residents/add');
          },
          icon: const Icon(Icons.add),
          label: const Text('Tambah Warga'),
          backgroundColor: const Color(0xFF0891B2),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<RegistrationStatus?>(
              title: const Text('Semua'),
              value: null,
              groupValue: _filterStatus,
              onChanged: (value) {
                Navigator.pop(context);
                setState(() {
                  _filterStatus = value;
                  _filterResidents();
                });
              },
            ),
            RadioListTile<RegistrationStatus?>(
              title: Row(
                children: [
                  const Text('Aktif'),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              value: RegistrationStatus.accepted,
              groupValue: _filterStatus,
              onChanged: (value) {
                Navigator.pop(context);
                setState(() {
                  _filterStatus = value;
                  _filterResidents();
                });
              },
            ),
            RadioListTile<RegistrationStatus?>(
              title: Row(
                children: [
                  const Text('Pending'),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              value: RegistrationStatus.pending,
              groupValue: _filterStatus,
              onChanged: (value) {
                Navigator.pop(context);
                setState(() {
                  _filterStatus = value;
                  _filterResidents();
                });
              },
            ),
            RadioListTile<RegistrationStatus?>(
              title: Row(
                children: [
                  const Text('Nonaktif'),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              value: RegistrationStatus.inactive,
              groupValue: _filterStatus,
              onChanged: (value) {
                Navigator.pop(context);
                setState(() {
                  _filterStatus = value;
                  _filterResidents();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
