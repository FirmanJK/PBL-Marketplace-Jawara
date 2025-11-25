import 'package:jawara/services/database_service.dart';
import 'dart:convert';

// Notification service without flutter_local_notifications dependency
// This is a simplified version that stores notifications in database only
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final DatabaseService _db = DatabaseService();
  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      // Simple initialization without native notifications
      _isInitialized = true;
      print('✅ Notification service initialized (database only)');
    } catch (e) {
      print('⚠️ Notification initialization error: $e');
    }
  }

  // Show notification (stores in database only)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.general,
  }) async {
    try {
      // Save to database
      await _saveNotificationToDb(title, body, type, payload);
      print('📬 Notification saved: $title');
    } catch (e) {
      print('⚠️ Error saving notification: $e');
    }
  }

  // Show payment reminder
  Future<void> showPaymentReminder({
    required String familyName,
    required double amount,
    required DateTime dueDate,
  }) async {
    final title = 'Pengingat Pembayaran Iuran';
    final body = 'Iuran untuk $familyName sebesar Rp ${amount.toStringAsFixed(0)} jatuh tempo pada ${dueDate.day}/${dueDate.month}/${dueDate.year}';
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      type: NotificationType.payment,
      payload: jsonEncode({
        'type': 'payment_reminder',
        'family_name': familyName,
        'amount': amount,
        'due_date': dueDate.toIso8601String(),
      }),
    );
  }

  // Show announcement
  Future<void> showAnnouncement({
    required String title,
    required String message,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: message,
      type: NotificationType.announcement,
      payload: jsonEncode({
        'type': 'announcement',
        'title': title,
        'message': message,
      }),
    );
  }

  // Show marketplace update
  Future<void> showMarketplaceUpdate({
    required String productName,
    required String message,
    int? productId,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Update Marketplace',
      body: '$productName: $message',
      type: NotificationType.marketplace,
      payload: jsonEncode({
        'type': 'marketplace',
        'product_id': productId,
        'product_name': productName,
        'message': message,
      }),
    );
  }

  // Save notification to database
  Future<void> _saveNotificationToDb(
    String title,
    String message,
    NotificationType type,
    String? data,
  ) async {
    try {
      await _db.insert('notifications', {
        'title': title,
        'message': message,
        'type': type.toString(),
        'is_read': 0,
        'data': data,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('⚠️ Error saving to database: $e');
    }
  }

  // Get all notifications
  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    try {
      return await _db.query(
        'notifications',
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print('⚠️ Error getting notifications: $e');
      return [];
    }
  }

  // Get unread notifications count
  Future<int> getUnreadCount() async {
    try {
      final results = await _db.query(
        'notifications',
        where: 'is_read = ?',
        whereArgs: [0],
      );
      return results.length;
    } catch (e) {
      print('⚠️ Error getting unread count: $e');
      return 0;
    }
  }

  // Mark notification as read
  Future<void> markAsRead(int id) async {
    try {
      await _db.update(
        'notifications',
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('⚠️ Error marking as read: $e');
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      final db = await _db.database;
      await db.update('notifications', {'is_read': 1});
    } catch (e) {
      print('⚠️ Error marking all as read: $e');
    }
  }

  // Delete notification
  Future<void> deleteNotification(int id) async {
    try {
      await _db.delete(
        'notifications',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('⚠️ Error deleting notification: $e');
    }
  }

  // Clear all notifications
  Future<void> clearAll() async {
    try {
      final db = await _db.database;
      await db.delete('notifications');
    } catch (e) {
      print('⚠️ Error clearing notifications: $e');
    }
  }

  // Schedule notification (simplified - just saves to database)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // For now, just save to database
    // In production, you would implement actual scheduling
    await showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  // Cancel notification (no-op in this simplified version)
  Future<void> cancelNotification(int id) async {
    // No-op since we're not using native notifications
    print('📭 Notification $id cancelled');
  }

  // Cancel all notifications (no-op in this simplified version)
  Future<void> cancelAll() async {
    // No-op since we're not using native notifications
    print('📭 All notifications cancelled');
  }
}

enum NotificationType {
  general,
  payment,
  announcement,
  marketplace,
  activity,
}
