import 'package:flutter/material.dart';
import 'package:jawara/shared/base_layout.dart';
import 'package:jawara/shared/button.dart';
import 'package:jawara/shared/card.dart';
import 'package:jawara/shared/input.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy users for UI
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

  @override
  Widget build(BuildContext context) {
    final filtered = _users.where((u) {
      final q = _query.toLowerCase();
      return u['name']!.toLowerCase().contains(q) ||
          u['email']!.toLowerCase().contains(q) ||
          u['role']!.toLowerCase().contains(q);
    }).toList();

    return BaseLayout(
      title: 'Manajemen Pengguna',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Daftar Pengguna',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: 'Tambah Pengguna',
                            onPressed: () {},
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Daftar Pengguna',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: CustomButton(
                              text: 'Tambah Pengguna',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Cari Pengguna',
                  hintText: 'Nama, email, atau role',
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Ketik untuk mencari...',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => setState(() => _query = ''),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.search, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SharedCard(
                  title: 'Pengguna',
                  icon: Icons.manage_accounts_outlined,
                  color: const Color(0xFF06B6D4),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final user = filtered[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF06B6D4),
                                child: Text(
                                  user['name']!.substring(0, 1),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                user['name']!,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${user['role']} • ${user['email']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () {},
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {},
                                    tooltip: 'Hapus',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Pagination placeholder
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              'Menampilkan 1–3 dari 3 pengguna',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
