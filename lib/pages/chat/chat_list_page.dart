import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';
import 'chat_room_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final AuthService _authService = AuthService();
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
        Navigator.pushNamed(context, '/settings');
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
    Navigator.pushNamed(context, '/broadcast/add');
  }

  void _openChat(String contactName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(
          chatName: contactName,
          chatRole: 'user',
          chatColor: const Color(0xFF0891B2),
          chatIcon: Icons.person,
          isOnline: true,
        ),
      ),
    );
  }

  void _openGroupChat(String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(
          chatName: groupName,
          chatRole: 'group',
          chatColor: const Color(0xFF0891B2),
          chatIcon: Icons.group,
          isOnline: true,
        ),
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

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat Baru'),
        content: const Text('Pilih kontak dari daftar di atas untuk memulai percakapan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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