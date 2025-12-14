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
  
  // Daftar role yang bisa diajak chat
  final List<Map<String, dynamic>> _chatRoles = [
    {
      'name': 'Admin Sistem',
      'role': 'admin',
      'avatar': Icons.admin_panel_settings,
      'color': const Color(0xFF6366F1),
      'lastMessage': 'Selamat datang di Jawara',
      'time': '10:30',
      'unreadCount': 0,
      'isOnline': true,
    },
    {
      'name': 'Ketua RT/RW',
      'role': 'ketua_rt',
      'avatar': Icons.account_balance,
      'color': const Color(0xFF0891B2),
      'lastMessage': 'Rapat koordinasi besok jam 19:00',
      'time': '09:15',
      'unreadCount': 2,
      'isOnline': true,
    },
    {
      'name': 'Sekretaris',
      'role': 'sekretaris',
      'avatar': Icons.description,
      'color': const Color(0xFF10B981),
      'lastMessage': 'Data warga sudah diupdate',
      'time': '08:45',
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'name': 'Bendahara',
      'role': 'bendahara',
      'avatar': Icons.account_balance_wallet,
      'color': const Color(0xFF8B5CF6),
      'lastMessage': 'Laporan keuangan bulan ini',
      'time': '07:30',
      'unreadCount': 1,
      'isOnline': true,
    },
    {
      'name': 'Grup Warga',
      'role': 'warga_group',
      'avatar': Icons.groups,
      'color': const Color(0xFFF59E0B),
      'lastMessage': 'Pak RT: Jangan lupa bayar iuran',
      'time': 'Kemarin',
      'unreadCount': 5,
      'isOnline': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;
    
    // Filter chat roles berdasarkan role user saat ini
    final availableChats = _chatRoles.where((chat) {
      if (currentUser?.role == 'admin') return true; // Admin bisa chat dengan semua
      return chat['role'] != currentUser?.role; // User tidak bisa chat dengan role yang sama
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan'),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'new_group':
                  // TODO: Implement new group
                  break;
                case 'broadcast':
                  // TODO: Implement broadcast
                  break;
                case 'settings':
                  Navigator.pushNamed(context, '/settings');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Row(
                  children: [
                    Icon(Icons.group_add, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Grup Baru'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'broadcast',
                child: Row(
                  children: [
                    Icon(Icons.campaign, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Broadcast'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Pengaturan'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Status/Stories section (opsional)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildStatusItem('Status Saya', Icons.add_circle, true),
                _buildStatusItem('Admin', Icons.admin_panel_settings, false),
                _buildStatusItem('Ketua RT', Icons.account_balance, false),
                _buildStatusItem('Sekretaris', Icons.description, false),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Chat list
          Expanded(
            child: ListView.builder(
              itemCount: availableChats.length,
              itemBuilder: (context, index) {
                final chat = availableChats[index];
                return _buildChatItem(chat);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new chat
          _showNewChatDialog();
        },
        backgroundColor: const Color(0xFF0891B2),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusItem(String name, IconData icon, bool isMyStatus) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isMyStatus ? Colors.grey : const Color(0xFF0891B2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isMyStatus ? Colors.grey : const Color(0xFF0891B2),
                  size: 24,
                ),
              ),
              if (isMyStatus)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0891B2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return ListTile(
      leading: Stack(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: chat['color'].withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              chat['avatar'],
              color: chat['color'],
              size: 24,
            ),
          ),
          if (chat['isOnline'])
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat['name'],
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        chat['lastMessage'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat['time'],
            style: TextStyle(
              color: chat['unreadCount'] > 0 ? const Color(0xFF0891B2) : Colors.grey,
              fontSize: 12,
              fontWeight: chat['unreadCount'] > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (chat['unreadCount'] > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: Color(0xFF0891B2),
                shape: BoxShape.circle,
              ),
              child: Text(
                chat['unreadCount'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              chatName: chat['name'],
              chatRole: chat['role'],
              chatColor: chat['color'],
              chatIcon: chat['avatar'],
              isOnline: chat['isOnline'],
            ),
          ),
        );
      },
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