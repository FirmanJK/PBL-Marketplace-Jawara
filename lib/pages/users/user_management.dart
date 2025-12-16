import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/services/users_service.dart';
import 'package:jawara/utils/toast_helper.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  String _query = '';
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await UsersService.getUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat pengguna: $e';
        _isLoading = false;
      });
    }
  }

  void _filterUsers() {
    setState(() {
      if (_query.isEmpty) {
        _filteredUsers = _users;
      } else {
        final q = _query.toLowerCase();
        _filteredUsers = _users
            .where(
              (u) =>
                  u.name.toLowerCase().contains(q) ||
                  u.email.toLowerCase().contains(q) ||
                  u.role.toLowerCase().contains(q),
            )
            .toList();
      }
    });
  }

  Color _getRoleColor(String role) {
    // Sesuai dengan 6 roles di BUSINESS_FLOW.md
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'ketua_rw':
        return Colors.purple;
      case 'ketua_rt':
        return Colors.orange;
      case 'sekretaris':
        return Colors.blue;
      case 'bendahara':
        return Colors.teal;
      case 'warga':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper method untuk role label display
  String _getRoleLabel(String role) {
    const Map<String, String> roleLabels = {
      'admin': 'Admin Sistem',
      'ketua_rw': 'Ketua RW',
      'ketua_rt': 'Ketua RT',
      'sekretaris': 'Sekretaris',
      'bendahara': 'Bendahara',
      'warga': 'Warga',
    };
    return roleLabels[role] ?? role;
  }

  Future<void> _deleteUser(UserModel user) async {
    try {
      await UsersService.deleteUser(user.id);
      await _loadUsers();
      if (mounted) {
        ToastHelper.showSuccess(context, '${user.name} berhasil dihapus');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Gagal menghapus pengguna: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Manajemen Pengguna'),
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
              onChanged: (v) {
                setState(() => _query = v);
                _filterUsers();
              },
            ),
          ),
          if (_error != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() => _error = null);
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _query.isEmpty
                              ? 'Tidak ada pengguna'
                              : 'Tidak ada hasil pencarian',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadUsers,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Dismissible(
                          key: ValueKey(user.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteUser(user);
                          },
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: _getRoleColor(
                                  user.role,
                                ).withOpacity(0.1),
                                child: Text(
                                  user.name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: _getRoleColor(user.role),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(user.email),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(
                                        user.role,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      user.role,
                                      style: TextStyle(
                                        color: _getRoleColor(user.role),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF0891B2),
                                ),
                                onPressed: () {
                                  _showEditDialog(context, user);
                                },
                                tooltip: 'Edit',
                              ),
                              onTap: () {},
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
        onPressed: () {
          Navigator.pushNamed(context, '/users/add').then((_) {
            _loadUsers();
          });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Pengguna',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone ?? '');
    String selectedRole = user.role;
    bool _isUpdating = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Edit Pengguna',
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
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
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
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(
                              Icons.email,
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
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Nomor HP',
                            prefixIcon: const Icon(
                              Icons.phone,
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
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Role',
                            prefixIcon: const Icon(
                              Icons.badge,
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
                          ),
                          items:
                              [
                                'admin',
                                'ketua_rw',
                                'ketua_rt',
                                'sekretaris',
                                'bendahara',
                                'warga',
                              ].map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(_getRoleLabel(role)),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedRole = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ), // Actions
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
                        onPressed: _isUpdating
                            ? null
                            : () => Navigator.pop(dialogContext),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isUpdating
                            ? null
                            : () async {
                                setState(() => _isUpdating = true);
                                try {
                                  await UsersService.updateUser(
                                    user.id,
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    role: selectedRole,
                                  );
                                  if (mounted) {
                                    Navigator.pop(dialogContext);
                                    await _loadUsers();
                                    ToastHelper.showSuccess(
                                      context,
                                      'Pengguna berhasil diperbarui',
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ToastHelper.showError(
                                      context,
                                      'Gagal memperbarui: $e',
                                    );
                                  }
                                } finally {
                                  setState(() => _isUpdating = false);
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
                        child: _isUpdating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserModel user) {
    bool _isDeleting = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Hapus Pengguna'),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${user.name}? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: _isDeleting
                  ? null
                  : () => Navigator.pop(dialogContext),
              child: const Text('Batal', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: _isDeleting
                  ? null
                  : () async {
                      setState(() => _isDeleting = true);
                      try {
                        await _deleteUser(user);
                        if (mounted) {
                          Navigator.pop(dialogContext);
                        }
                      } catch (e) {
                        if (mounted) {
                          ToastHelper.showError(context, 'Gagal menghapus: $e');
                        }
                      } finally {
                        setState(() => _isDeleting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
