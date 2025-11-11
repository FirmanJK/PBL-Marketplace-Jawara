import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/data/users.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getRoleBadgeColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red.shade100;
      case 'bendahara':
        return Colors.purple.shade100;
      case 'sekretaris':
        return Colors.blue.shade100;
      case 'operator':
        return Colors.green.shade100;
      case 'viewer':
        return Colors.grey.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getRoleTextColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red.shade700;
      case 'bendahara':
        return Colors.purple.shade700;
      case 'sekretaris':
        return Colors.blue.shade700;
      case 'operator':
        return Colors.green.shade700;
      case 'viewer':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    final filtered = userList.where((u) {
      final q = _query.toLowerCase();
      return u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.role.toLowerCase().contains(q);
    }).toList();

    return BaseLayout(
      title: 'Manajemen Pengguna',
      actions: [
        Padding(
          padding: EdgeInsets.only(right: isMobile ? 8.0 : 16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/users/add');
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: isMobile ? 16 : 18,
            ),
            label: Text(
              isMobile ? 'Tambah' : 'Tambah Pengguna',
              style: const TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 12,
              ),
            ),
          ),
        ),
      ],
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F7FC),
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: Column(
          children: [
            // Search Bar
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan nama, email, atau role...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _query = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data Table
            Expanded(
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.shade100,
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'NO',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'NAMA',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'EMAIL',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ROLE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'TELEPON',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'AKSI',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: filtered.asMap().entries.map((entry) {
                        final index = entry.key;
                        final user = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRoleBadgeColor(user.role),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.role,
                                  style: TextStyle(
                                    color: _getRoleTextColor(user.role),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(user.phone ?? '-')),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    color: Colors.blue,
                                    onPressed: () {
                                      // Edit user
                                    },
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    color: Colors.red,
                                    onPressed: () {
                                      // Delete user
                                    },
                                    tooltip: 'Hapus',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
