import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatName;
  final String chatRole;
  final Color chatColor;
  final IconData chatIcon;
  final bool isOnline;

  const ChatRoomPage({
    super.key,
    required this.chatName,
    required this.chatRole,
    required this.chatColor,
    required this.chatIcon,
    required this.isOnline,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AuthService _authService = AuthService();
  
  // Sample messages - dalam implementasi nyata, ini akan dari database
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadSampleMessages();
  }

  void _loadSampleMessages() {
    final currentUser = _authService.currentUser;
    
    // Sample messages berdasarkan role
    if (widget.chatRole == 'admin') {
      _messages = [
        {
          'id': '1',
          'text': 'Selamat datang di sistem Jawara! 👋',
          'sender': 'admin',
          'senderName': 'Admin Sistem',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isMe': false,
          'messageType': 'text',
        },
        {
          'id': '2',
          'text': 'Jika ada pertanyaan tentang sistem, silakan hubungi saya.',
          'sender': 'admin',
          'senderName': 'Admin Sistem',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 1)),
          'isMe': false,
          'messageType': 'text',
        },
      ];
    } else if (widget.chatRole == 'ketua_rt') {
      _messages = [
        {
          'id': '1',
          'text': 'Selamat pagi! Ada rapat koordinasi besok jam 19:00 di balai RT.',
          'sender': 'ketua_rt',
          'senderName': 'Ketua RT/RW',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          'isMe': false,
          'messageType': 'text',
        },
        {
          'id': '2',
          'text': 'Mohon kehadiran semua pengurus. Terima kasih.',
          'sender': 'ketua_rt',
          'senderName': 'Ketua RT/RW',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 59)),
          'isMe': false,
          'messageType': 'text',
        },
      ];
    } else if (widget.chatRole == 'warga_group') {
      _messages = [
        {
          'id': '1',
          'text': 'Selamat pagi warga RT 01! 🌅',
          'sender': 'ketua_rt',
          'senderName': 'Pak RT',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'isMe': false,
          'messageType': 'text',
        },
        {
          'id': '2',
          'text': 'Jangan lupa bayar iuran bulan ini ya. Batas waktu tanggal 25.',
          'sender': 'ketua_rt',
          'senderName': 'Pak RT',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3, minutes: 1)),
          'isMe': false,
          'messageType': 'text',
        },
        {
          'id': '3',
          'text': 'Siap Pak RT! 👍',
          'sender': 'warga1',
          'senderName': 'Budi',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          'isMe': false,
          'messageType': 'text',
        },
        {
          'id': '4',
          'text': 'Baik Pak, nanti saya bayar.',
          'sender': currentUser?.id ?? 'me',
          'senderName': currentUser?.name ?? 'Saya',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isMe': true,
          'messageType': 'text',
        },
      ];
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.chatIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (widget.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.isOnline ? 'online' : 'terakhir dilihat baru saja',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Memulai video call...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Memulai voice call...')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'info':
                  _showChatInfo();
                  break;
                case 'media':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka galeri media...')),
                  );
                  break;
                case 'clear':
                  _clearChat();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Info'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'media',
                child: Row(
                  children: [
                    Icon(Icons.photo, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Media'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Hapus Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/chat_bg.png'),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
                color: Color(0xFFF5F5F5),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          onPressed: () {
                            // TODO: Implement emoji picker
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Ketik pesan...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {
                            _showAttachmentOptions();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Membuka kamera...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: const Color(0xFF0891B2),
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    final timestamp = message['timestamp'] as DateTime;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: widget.chatColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.chatIcon,
                color: widget.chatColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF0891B2) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isMe ? 12 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe && widget.chatRole == 'warga_group')
                    Text(
                      message['senderName'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.chatColor,
                      ),
                    ),
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 14,
                          color: Colors.blue[200],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 38),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}h yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}j yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUser = _authService.currentUser;
    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text,
      'sender': currentUser?.id ?? 'me',
      'senderName': currentUser?.name ?? 'Saya',
      'timestamp': DateTime.now(),
      'isMe': true,
      'messageType': 'text',
    };

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
    
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate reply (dalam implementasi nyata, ini akan dari server)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final replyMessage = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': _getAutoReply(text),
          'sender': widget.chatRole,
          'senderName': widget.chatName,
          'timestamp': DateTime.now(),
          'isMe': false,
          'messageType': 'text',
        };

        setState(() {
          _messages.add(replyMessage);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  String _getAutoReply(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('halo') || lowerMessage.contains('hai')) {
      return 'Halo juga! Ada yang bisa saya bantu?';
    } else if (lowerMessage.contains('terima kasih')) {
      return 'Sama-sama! 😊';
    } else if (lowerMessage.contains('iuran')) {
      return 'Untuk informasi iuran, silakan cek di menu Tagihan Aktif ya.';
    } else if (lowerMessage.contains('rapat')) {
      return 'Baik, saya catat kehadiran Anda. Terima kasih.';
    } else {
      return 'Pesan Anda sudah saya terima. Terima kasih.';
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kirim File',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  Icons.photo,
                  'Foto',
                  Colors.pink,
                  () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  Icons.videocam,
                  'Video',
                  Colors.red,
                  () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  Icons.insert_drive_file,
                  'Dokumen',
                  Colors.blue,
                  () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  Icons.location_on,
                  'Lokasi',
                  Colors.green,
                  () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Info ${widget.chatName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.chatColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.chatIcon,
                    color: widget.chatColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: widget.isOnline ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Role: ${widget.chatRole}'),
            const SizedBox(height: 8),
            Text('Total pesan: ${_messages.length}'),
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

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Chat'),
        content: const Text('Apakah Anda yakin ingin menghapus semua pesan dalam chat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}