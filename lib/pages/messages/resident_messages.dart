import 'package:flutter/material.dart';

class CitizenMessagesPage extends StatefulWidget {
  const CitizenMessagesPage({super.key});

  @override
  State<CitizenMessagesPage> createState() => _CitizenMessagesPageState();
}

class _CitizenMessagesPageState extends State<CitizenMessagesPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _chatContacts = [
    {
      'name': 'Admin Sistem',
      'lastMessage': 'Selamat datang di Jawara',
      'time': '10:30',
      'unread': 0,
      'avatar': Icons.admin_panel_settings,
      'color': const Color(0xFF0891B2),
    },
    {
      'name': 'Ketua RT/RW',
      'lastMessage': 'Rapat koordinasi besok ja...',
      'time': '09:15',
      'unread': 2,
      'avatar': Icons.account_balance,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Sekretaris',
      'lastMessage': 'Data warga sudah diupdate',
      'time': '08:45',
      'unread': 0,
      'avatar': Icons.description,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Bendahara',
      'lastMessage': 'Laporan keuangan bulan ini',
      'time': '07:30',
      'unread': 1,
      'avatar': Icons.account_balance_wallet,
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'Grup Warga',
      'lastMessage': 'Pak RT: Jangan lupa baya...',
      'time': 'Kemarin',
      'unread': 5,
      'avatar': Icons.groups,
      'color': const Color(0xFFEC4899),
    },
  ];

  final List<Map<String, dynamic>> _groupChats = [
    {
      'name': 'Grup RT 01',
      'description': 'Grup komunikasi warga RT 01',
      'members': 45,
      'avatar': Icons.home,
      'color': const Color(0xFF3B82F6),
    },
    {
      'name': 'Grup Ibu-Ibu PKK',
      'description': 'Koordinasi kegiatan PKK',
      'members': 23,
      'avatar': Icons.groups_2,
      'color': const Color(0xFFEC4899),
    },
    {
      'name': 'Grup Karang Taruna',
      'description': 'Pemuda RT 01',
      'members': 18,
      'avatar': Icons.sports_soccer,
      'color': const Color(0xFF10B981),
    },
  ];

  final List<Map<String, dynamic>> _broadcasts = [
    {
      'title': 'Pengumuman Iuran Bulanan',
      'content': 'Pembayaran iuran bulan Oktober telah dibuka...',
      'date': '15 Okt 2024',
      'sender': 'Bendahara RT',
      'priority': 'high',
    },
    {
      'title': 'Gotong Royong Minggu Depan',
      'content': 'Akan diadakan gotong royong membersihkan...',
      'date': '14 Okt 2024',
      'sender': 'Ketua RT',
      'priority': 'medium',
    },
    {
      'title': 'Rapat Warga Bulanan',
      'content': 'Mengundang seluruh warga untuk hadir...',
      'date': '13 Okt 2024',
      'sender': 'Sekretaris RT',
      'priority': 'low',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pesan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Notification Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => _showNotifications(context),
                tooltip: 'Notifikasi',
              ),
              // Notification Badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          
          // Dropdown Menu (Three Dots)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            tooltip: 'Menu',
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Cari Pesan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'new_group',
                child: Row(
                  children: [
                    Icon(Icons.group_add, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Grup Baru', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'broadcast',
                child: Row(
                  children: [
                    Icon(Icons.campaign, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Broadcast', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Pengaturan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Bantuan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF0891B2), size: 20),
                    SizedBox(width: 12),
                    Text('Tentang', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: const Color(0xFF0891B2),
            child: Row(
              children: [
                _buildTabButton('Chat', 0),
                _buildTabButton('Grup', 1),
                _buildTabButton('Broadcast', 2),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildChatList(),
                _buildGroupList(),
                _buildBroadcastList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 0) {
            _showQuickActionDialog();
          } else if (_selectedIndex == 1) {
            _showCreateGroupDialog();
          } else {
            _showCreateBroadcastDialog();
          }
        },
        backgroundColor: const Color(0xFF0891B2),
        child: Icon(
          _selectedIndex == 0 ? Icons.add : 
          _selectedIndex == 1 ? Icons.group_add : Icons.campaign,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _chatContacts.length,
      itemBuilder: (context, index) {
        final contact = _chatContacts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: contact['color'],
              child: Icon(contact['avatar'], color: Colors.white, size: 20),
            ),
            title: Text(
              contact['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              contact['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact['time'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (contact['unread'] > 0) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: const Color(0xFF0891B2),
                    child: Text(
                      '${contact['unread']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () => _openChat(contact['name']),
          ),
        );
      },
    );
  }

  Widget _buildGroupList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _groupChats.length,
      itemBuilder: (context, index) {
        final group = _groupChats[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: group['color'],
              child: Icon(group['avatar'], color: Colors.white, size: 20),
            ),
            title: Text(
              group['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${group['members']} anggota'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _openGroupChat(group['name']),
          ),
        );
      },
    );
  }

  Widget _buildBroadcastList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _broadcasts.length,
      itemBuilder: (context, index) {
        final broadcast = _broadcasts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPriorityColor(broadcast['priority']),
              child: const Icon(Icons.campaign, color: Colors.white, size: 20),
            ),
            title: Text(
              broadcast['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              broadcast['content'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _openBroadcast(broadcast),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifikasi Pesan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              'Pesan Baru',
              'Anda memiliki 2 pesan baru dari Ketua RT',
              '5 menit yang lalu',
              Icons.message,
              Colors.blue,
            ),
            _buildNotificationItem(
              'Grup Chat',
              'Ada pesan baru di Grup RT 01',
              '15 menit yang lalu',
              Icons.group,
              Colors.green,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'search':
        _showSearchDialog();
        break;
      case 'new_group':
        _showCreateGroupDialog();
        break;
      case 'broadcast':
        _showCreateBroadcastDialog();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
      case 'help':
        Navigator.pushNamed(context, '/help');
        break;
      case 'about':
        Navigator.pushNamed(context, '/about');
        break;
    }
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: _ContactSearchDelegate(_chatContacts, _openChat),
    );
  }

  void _showContactList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Pilih Kontak untuk Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _chatContacts.length,
                itemBuilder: (context, index) {
                  final contact = _chatContacts[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: contact['color'],
                        child: Icon(contact['avatar'], color: Colors.white),
                      ),
                      title: Text(contact['name']),
                      subtitle: const Text('Online'),
                      trailing: const Icon(Icons.chat_bubble_outline),
                      onTap: () {
                        Navigator.pop(context);
                        _openChat(contact['name']);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateGroupDialog() {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0891B2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Buat Grup Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.folder, color: Color(0xFF0891B2)),
                        hintText: 'Nama Grup',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF0891B2)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.trim().isNotEmpty) {
                                Navigator.pop(context);
                                setState(() {
                                  _groupChats.add({
                                    'name': nameController.text.trim(),
                                    'description': 'Grup baru',
                                    'members': 1,
                                    'avatar': Icons.group,
                                    'color': const Color(0xFF0891B2),
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Grup "${nameController.text.trim()}" berhasil dibuat'),
                                    backgroundColor: const Color(0xFF10B981),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0891B2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Buat Grup',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
  }

  void _showCreateBroadcastDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _BroadcastFormPage(
          onBroadcastCreated: (Map<String, dynamic> broadcast) {
            setState(() {
              _broadcasts.insert(0, broadcast);
            });
          },
        ),
      ),
    );
  }

  Widget _buildPriorityOption(
    String value,
    String title,
    String description,
    Color color,
    IconData icon,
    String selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    final isSelected = selectedValue == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? color : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedValue,
        onChanged: onChanged,
        activeColor: color,
        title: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? color : const Color(0xFF374151),
              ),
            ),
          ],
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? color.withOpacity(0.8) : const Color(0xFF6B7280),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month];
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan Pesan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi Pesan'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}')),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Suara Notifikasi'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Suara notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}')),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Backup Chat'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur backup chat akan segera tersedia')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Kontak Diblokir'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _showBlockedContactsDialog();
              },
            ),
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

  void _showBlockedContactsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kontak Diblokir'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.block),
              title: Text('Tidak ada kontak yang diblokir'),
              subtitle: Text('Kontak yang Anda blokir akan muncul di sini'),
            ),
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

  void _showQuickActionDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Aksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  icon: Icons.chat,
                  label: 'Chat Baru',
                  color: const Color(0xFF0891B2),
                  onTap: () {
                    Navigator.pop(context);
                    _showContactList();
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.group_add,
                  label: 'Buat Grup',
                  color: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.pop(context);
                    _showCreateGroupDialog();
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.campaign,
                  label: 'Broadcast',
                  color: const Color(0xFFF59E0B),
                  onTap: () {
                    Navigator.pop(context);
                    _showCreateBroadcastDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(String contactName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(contactName: contactName),
      ),
    );
  }

  void _openGroupChat(String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(contactName: groupName),
      ),
    );
  }

  void _openBroadcast(Map<String, dynamic> broadcast) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(broadcast['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(broadcast['content']),
            const SizedBox(height: 16),
            Text(
              'Dari: ${broadcast['sender']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Tanggal: ${broadcast['date']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
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
}

class _ContactSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> contacts;
  final Function(String) onContactSelected;

  _ContactSearchDelegate(this.contacts, this.onContactSelected);

  @override
  String get searchFieldLabel => 'Cari nama kontak untuk chat...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0891B2),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? contacts
        : contacts
              .where(
                (contact) =>
                    contact['name'].toLowerCase().contains(query.toLowerCase()) ||
                    contact['lastMessage'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final contact = results[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: contact['color'],
                child: Icon(contact['avatar'], color: Colors.white, size: 20),
              ),
              title: Text(
                contact['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      contact['lastMessage'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    contact['time'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chat_bubble_outline, size: 16),
                ],
              ),
              onTap: () {
                onContactSelected(contact['name']);
                close(context, contact['name']);
              },
            ),
          );
        },
      ),
    );
  }
}

class ChatDetailPage extends StatefulWidget {
  final String contactName;

  const ChatDetailPage({super.key, required this.contactName});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Halo, selamat datang di sistem Jawara!',
      'isMe': false,
      'time': '10:30',
    },
    {
      'text': 'Terima kasih, sistem ini sangat membantu',
      'isMe': true,
      'time': '10:32',
    },
    {
      'text': 'Jika ada pertanyaan, jangan ragu untuk bertanya',
      'isMe': false,
      'time': '10:33',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contactName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0891B2),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur panggilan akan segera tersedia')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF0891B2) : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message['time'],
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF0891B2),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true,
          'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        });
      });
      _messageController.clear();
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Info Kontak'),
              onTap: () {
                Navigator.pop(context);
                _showContactInfo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Blokir Kontak'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kontak diblokir')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Hapus Chat'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContactInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Info ${widget.contactName}'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: Online'),
            SizedBox(height: 8),
            Text('Terakhir dilihat: Hari ini 10:30'),
            SizedBox(height: 8),
            Text('Nomor: +62 812 3456 7890'),
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Chat'),
        content: const Text('Apakah Anda yakin ingin menghapus chat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class _BroadcastFormPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onBroadcastCreated;

  const _BroadcastFormPage({required this.onBroadcastCreated});

  @override
  State<_BroadcastFormPage> createState() => _BroadcastFormPageState();
}

class _BroadcastFormPageState extends State<_BroadcastFormPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedPriority = 'medium';

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month];
  }

  void _saveBroadcast() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      final broadcast = {
        'title': title,
        'content': content,
        'date': '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
        'sender': 'Admin RT',
        'priority': _selectedPriority,
      };

      widget.onBroadcastCreated(broadcast);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Broadcast "$title" berhasil dikirim')),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Mohon lengkapi semua field'),
            ],
          ),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Buat Broadcast Baru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0891B2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Broadcast
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.folder_outlined, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text('Judul Broadcast', style: TextStyle(fontSize: 14, color: Color(0xFF0891B2), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0891B2), width: 2),
              ),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: 'Masukkan judul broadcast',
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Prioritas
            const Text('Prioritas', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0891B2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.priority_high, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPriority,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0891B2)),
                        items: const [
                          DropdownMenuItem(value: 'high', child: Text('Tinggi')),
                          DropdownMenuItem(value: 'medium', child: Text('Sedang')),
                          DropdownMenuItem(value: 'low', child: Text('Rendah')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPriority = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Isi Pesan
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.message, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text('Isi Pesan', style: TextStyle(fontSize: 14, color: Color(0xFF0891B2), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: 'Masukkan isi pesan broadcast',
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Batal', style: TextStyle(color: Color(0xFF6B7280), fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveBroadcast,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0891B2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}