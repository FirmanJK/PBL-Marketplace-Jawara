import 'package:flutter/material.dart';
import 'package:jawara/shared/standard_app_bar.dart';
import 'package:jawara/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final notifications = await _notificationService.getAllNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(int id) async {
    await _notificationService.markAsRead(id);
    await _loadNotifications();
  }

  Future<void> _markAllAsRead() async {
    await _notificationService.markAllAsRead();
    await _loadNotifications();
  }

  Future<void> _deleteNotification(int id) async {
    await _notificationService.deleteNotification(id);
    await _loadNotifications();
  }

  Color _getNotificationColor(String? type) {
    switch (type) {
      case 'NotificationType.payment':
        return Colors.orange;
      case 'NotificationType.announcement':
        return Colors.blue;
      case 'NotificationType.marketplace':
        return Colors.green;
      case 'NotificationType.activity':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'NotificationType.payment':
        return Icons.payment;
      case 'NotificationType.announcement':
        return Icons.campaign;
      case 'NotificationType.marketplace':
        return Icons.shopping_bag;
      case 'NotificationType.activity':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Notifikasi',
        actions: [
          if (_notifications.any((n) => n['is_read'] == 0))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Tandai Semua Dibaca',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada notifikasi',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      final isRead = notification['is_read'] == 1;
                      final createdAt = DateTime.parse(notification['created_at']);
                      final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

                      return Dismissible(
                        key: Key(notification['id'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          _deleteNotification(notification['id']);
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: isRead ? 1 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: isRead ? Colors.white : Colors.blue.shade50,
                          child: InkWell(
                            onTap: () {
                              if (!isRead) {
                                _markAsRead(notification['id']);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: _getNotificationColor(
                                      notification['type'],
                                    ).withOpacity(0.1),
                                    child: Icon(
                                      _getNotificationIcon(notification['type']),
                                      color: _getNotificationColor(notification['type']),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notification['title'],
                                                style: TextStyle(
                                                  fontWeight: isRead
                                                      ? FontWeight.normal
                                                      : FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if (!isRead)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification['message'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          dateFormat.format(createdAt),
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
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
                    },
                  ),
                ),
    );
  }
}
