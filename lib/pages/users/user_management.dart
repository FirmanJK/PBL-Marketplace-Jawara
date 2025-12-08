import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _users = [
    {'name': 'Andi Saputra', 'role': 'Admin', 'email': 'andi@mail.com'},
    {'name': 'Siti Aminah', 'role': 'Operator', 'email': 'siti@mail.com'},
    {'name': 'Budi Santoso', 'role': 'Viewer', 'email': 'budi@mail.com'},
  ];

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'operator':
        return Colors.blue;
      case 'viewer':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _users.where((u) {
      final q = _query.toLowerCase();
      return u['name']!.toLowerCase().contains(q) ||
          u['email']!.toLowerCase().contains(q) ||
          u['role']!.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Manajemen Pengguna',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari pengguna...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final user = filtered[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: _getRoleColor(user['role']!).withOpacity(0.1),
                      child: Text(
                        user['name']!.substring(0, 1),
                        style: TextStyle(
                          color: _getRoleColor(user['role']!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(user['email']!),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user['role']!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['role']!,
                            style: TextStyle(
                              color: _getRoleColor(user['role']!),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Color(0xFF0891B2)),
                          onPressed: () {
                            // Show edit dialog
                            _showEditDialog(context, user);
                          },
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            // Show delete confirmation
                            _showDeleteDialog(context, user['name']!);
                          },
                          tooltip: 'Hapus',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/users/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pengguna'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Pengguna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit data untuk: ${user['name']}'),
            const SizedBox(height: 16),
            const Text('Fitur edit akan segera tersedia.'),
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

  void _showDeleteDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: Text('Apakah Anda yakin ingin menghapus $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$userName berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
