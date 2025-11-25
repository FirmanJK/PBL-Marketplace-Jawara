import 'package:jawara/services/database_service.dart';
import 'package:jawara/services/api_service.dart';
import 'dart:convert';

class SyncService {
  final DatabaseService _db = DatabaseService();

  // Sync all data
  Future<SyncResult> syncAll() async {
    final result = SyncResult();

    try {
      // Sync residents
      final residentsResult = await syncResidents();
      result.residents = residentsResult;

      // Sync families
      final familiesResult = await syncFamilies();
      result.families = familiesResult;

      // Sync transactions
      final transactionsResult = await syncTransactions();
      result.transactions = transactionsResult;

      // Sync products
      final productsResult = await syncProducts();
      result.products = productsResult;

      // Sync orders
      final ordersResult = await syncOrders();
      result.orders = ordersResult;

      result.success = true;
      result.message = 'Sinkronisasi berhasil';
    } catch (e) {
      result.success = false;
      result.message = 'Sinkronisasi gagal: $e';
    }

    return result;
  }

  // Sync residents
  Future<TableSyncResult> syncResidents() async {
    final result = TableSyncResult();
    
    try {
      // Get unsynced local data
      final unsyncedRecords = await _db.getUnsyncedRecords('residents');
      
      // Upload to server
      for (var record in unsyncedRecords) {
        try {
          // Determine if insert or update
          if (record['id'] != null && record['id'] > 0) {
            // Update existing
            await ApiService.put('/residents/${record['id']}', body: record);
          } else {
            // Insert new
            final response = await ApiService.post('/residents', body: record);
            // Update local ID with server ID
            if (response['id'] != null) {
              await _db.update(
                'residents',
                {'id': response['id']},
                where: 'id = ?',
                whereArgs: [record['id']],
              );
            }
          }
          
          // Mark as synced
          await _db.markAsSynced('residents', record['id']);
          result.uploaded++;
        } catch (e) {
          result.failed++;
          // Add to sync queue for retry
          await _addToSyncQueue('residents', record['id'], 'upload', record);
        }
      }

      // Download from server
      final serverData = await ApiService.get('/residents');
      if (serverData is List) {
        for (var item in serverData) {
          await _db.insert('residents', {
            ...item,
            'synced': 1,
          });
          result.downloaded++;
        }
      }

      result.success = true;
    } catch (e) {
      result.success = false;
      result.error = e.toString();
    }

    return result;
  }

  // Sync families
  Future<TableSyncResult> syncFamilies() async {
    final result = TableSyncResult();
    
    try {
      final unsyncedRecords = await _db.getUnsyncedRecords('families');
      
      for (var record in unsyncedRecords) {
        try {
          if (record['id'] != null && record['id'] > 0) {
            await ApiService.put('/families/${record['id']}', body: record);
          } else {
            final response = await ApiService.post('/families', body: record);
            if (response['id'] != null) {
              await _db.update(
                'families',
                {'id': response['id']},
                where: 'id = ?',
                whereArgs: [record['id']],
              );
            }
          }
          
          await _db.markAsSynced('families', record['id']);
          result.uploaded++;
        } catch (e) {
          result.failed++;
          await _addToSyncQueue('families', record['id'], 'upload', record);
        }
      }

      final serverData = await ApiService.get('/families');
      if (serverData is List) {
        for (var item in serverData) {
          await _db.insert('families', {...item, 'synced': 1});
          result.downloaded++;
        }
      }

      result.success = true;
    } catch (e) {
      result.success = false;
      result.error = e.toString();
    }

    return result;
  }

  // Sync transactions
  Future<TableSyncResult> syncTransactions() async {
    final result = TableSyncResult();
    
    try {
      final unsyncedRecords = await _db.getUnsyncedRecords('transactions');
      
      for (var record in unsyncedRecords) {
        try {
          if (record['id'] != null && record['id'] > 0) {
            await ApiService.put('/transactions/${record['id']}', body: record);
          } else {
            final response = await ApiService.post('/transactions', body: record);
            if (response['id'] != null) {
              await _db.update(
                'transactions',
                {'id': response['id']},
                where: 'id = ?',
                whereArgs: [record['id']],
              );
            }
          }
          
          await _db.markAsSynced('transactions', record['id']);
          result.uploaded++;
        } catch (e) {
          result.failed++;
          await _addToSyncQueue('transactions', record['id'], 'upload', record);
        }
      }

      final serverData = await ApiService.get('/transactions');
      if (serverData is List) {
        for (var item in serverData) {
          await _db.insert('transactions', {...item, 'synced': 1});
          result.downloaded++;
        }
      }

      result.success = true;
    } catch (e) {
      result.success = false;
      result.error = e.toString();
    }

    return result;
  }

  // Sync products
  Future<TableSyncResult> syncProducts() async {
    final result = TableSyncResult();
    
    try {
      final unsyncedRecords = await _db.getUnsyncedRecords('products');
      
      for (var record in unsyncedRecords) {
        try {
          if (record['id'] != null && record['id'] > 0) {
            await ApiService.put('/products/${record['id']}', body: record);
          } else {
            final response = await ApiService.post('/products', body: record);
            if (response['id'] != null) {
              await _db.update(
                'products',
                {'id': response['id']},
                where: 'id = ?',
                whereArgs: [record['id']],
              );
            }
          }
          
          await _db.markAsSynced('products', record['id']);
          result.uploaded++;
        } catch (e) {
          result.failed++;
          await _addToSyncQueue('products', record['id'], 'upload', record);
        }
      }

      final serverData = await ApiService.get('/products');
      if (serverData is List) {
        for (var item in serverData) {
          await _db.insert('products', {...item, 'synced': 1});
          result.downloaded++;
        }
      }

      result.success = true;
    } catch (e) {
      result.success = false;
      result.error = e.toString();
    }

    return result;
  }

  // Sync orders
  Future<TableSyncResult> syncOrders() async {
    final result = TableSyncResult();
    
    try {
      final unsyncedRecords = await _db.getUnsyncedRecords('orders');
      
      for (var record in unsyncedRecords) {
        try {
          if (record['id'] != null && record['id'] > 0) {
            await ApiService.put('/orders/${record['id']}', body: record);
          } else {
            final response = await ApiService.post('/orders', body: record);
            if (response['id'] != null) {
              await _db.update(
                'orders',
                {'id': response['id']},
                where: 'id = ?',
                whereArgs: [record['id']],
              );
            }
          }
          
          await _db.markAsSynced('orders', record['id']);
          result.uploaded++;
        } catch (e) {
          result.failed++;
          await _addToSyncQueue('orders', record['id'], 'upload', record);
        }
      }

      final serverData = await ApiService.get('/orders');
      if (serverData is List) {
        for (var item in serverData) {
          await _db.insert('orders', {...item, 'synced': 1});
          result.downloaded++;
        }
      }

      result.success = true;
    } catch (e) {
      result.success = false;
      result.error = e.toString();
    }

    return result;
  }

  // Add to sync queue for retry
  Future<void> _addToSyncQueue(
    String tableName,
    int recordId,
    String action,
    Map<String, dynamic> data,
  ) async {
    await _db.insert('sync_queue', {
      'table_name': tableName,
      'record_id': recordId,
      'action': action,
      'data': jsonEncode(data),
      'created_at': DateTime.now().toIso8601String(),
      'retry_count': 0,
    });
  }

  // Process sync queue
  Future<void> processSyncQueue() async {
    final queue = await _db.query('sync_queue', orderBy: 'created_at ASC');
    
    for (var item in queue) {
      try {
        final data = jsonDecode(item['data']);
        final tableName = item['table_name'];
        final recordId = item['record_id'];

        // Retry sync
        if (item['action'] == 'upload') {
          await ApiService.post('/$tableName', body: data);
          await _db.markAsSynced(tableName, recordId);
        }

        // Remove from queue
        await _db.delete('sync_queue', where: 'id = ?', whereArgs: [item['id']]);
      } catch (e) {
        // Increment retry count
        final retryCount = (item['retry_count'] ?? 0) + 1;
        if (retryCount > 3) {
          // Max retries reached, remove from queue
          await _db.delete('sync_queue', where: 'id = ?', whereArgs: [item['id']]);
        } else {
          await _db.update(
            'sync_queue',
            {'retry_count': retryCount},
            where: 'id = ?',
            whereArgs: [item['id']],
          );
        }
      }
    }
  }

  // Check if sync is needed
  Future<bool> needsSync() async {
    final unsyncedResidents = await _db.getUnsyncedRecords('residents');
    final unsyncedFamilies = await _db.getUnsyncedRecords('families');
    final unsyncedTransactions = await _db.getUnsyncedRecords('transactions');
    final unsyncedProducts = await _db.getUnsyncedRecords('products');
    
    return unsyncedResidents.isNotEmpty ||
           unsyncedFamilies.isNotEmpty ||
           unsyncedTransactions.isNotEmpty ||
           unsyncedProducts.isNotEmpty;
  }
}

class SyncResult {
  bool success = false;
  String message = '';
  TableSyncResult? residents;
  TableSyncResult? families;
  TableSyncResult? transactions;
  TableSyncResult? products;
  TableSyncResult? orders;
}

class TableSyncResult {
  bool success = false;
  int uploaded = 0;
  int downloaded = 0;
  int failed = 0;
  String? error;
}
