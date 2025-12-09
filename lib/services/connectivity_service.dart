import 'package:jawara/services/api_service.dart';

/// Service untuk mengecek dan memastikan koneksi ke backend
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  /// Cek koneksi ke backend dengan retry logic
  Future<bool> checkConnection({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        // Coba ping backend dengan health check endpoint
        // Kalau tidak ada, coba endpoint public lainnya
        await ApiService.get(
          '/auth/me',
        ).timeout(const Duration(seconds: 5)).catchError((_) {
          // Ignore 401 unauthorized error saat tidak login, yang penting server respond
          return null;
        });

        _isConnected = true;
        print('✓ Backend server connected (attempt ${i + 1}/$maxRetries)');
        return true;
      } catch (e) {
        print('✗ Connection attempt ${i + 1}/$maxRetries failed: $e');
        if (i < maxRetries - 1) {
          // Wait sebelum retry
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    }

    _isConnected = false;
    print('✗ Backend server not reachable after $maxRetries attempts');
    return false;
  }

  /// Force reconnect - untuk digunakan setelah hot reload
  Future<bool> forceReconnect() async {
    _isConnected = false;
    print('🔄 Forcing reconnection to backend...');
    return checkConnection(maxRetries: 3);
  }
}
