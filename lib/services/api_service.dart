import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base API Service untuk semua HTTP requests
class ApiService {
  // Base URL - Backend FastAPI berjalan di port 8000
  // Untuk Android Emulator gunakan: http://10.0.2.2:8000
  // Untuk iOS Simulator gunakan: http://localhost:8000
  // Untuk Physical Device gunakan: http://YOUR_IP:8000
  // static const String baseUrl = 'http://10.0.2.2:8000';
  static const String baseUrl = 'http://localhost:8000';

  // Timeout duration
  static const Duration timeout = Duration(seconds: 30);

  // Headers default
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers dengan auth token6T5CC
  static Map<String, String> _headersWithAuth(String? token) {
    final headers = Map<String, String>.from(_headers);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// GET request
  static Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http
          .get(uri, headers: _headersWithAuth(token))
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: _headersWithAuth(token),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print(
        '[DEBUG] ApiService.put: endpoint=$endpoint, uri=$uri, body=$body, hasToken=${token != null}',
      );
      final response = await http
          .put(
            uri,
            headers: _headersWithAuth(token),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      print('[DEBUG] ApiService.put response: status=${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      print('[DEBUG] ApiService.put error: $e');
      throw _handleError(e);
    }
  }

  /// DELETE request
  static Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .delete(uri, headers: _headersWithAuth(token))
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Multipart request (for file upload)
  static Future<dynamic> multipart(
    String endpoint,
    String method, {
    Map<String, String>? fields,
    Map<String, String>? files,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest(method, uri);

      // Add headers
      request.headers.addAll(_headersWithAuth(token));

      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value),
          );
        }
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle HTTP response
  static dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return null;
      return json.decode(body);
    } else {
      // Extract error message from response body
      final errorMessage = _extractErrorMessage(body);
      throw ApiException(errorMessage, statusCode);
    }
  }

  /// Extract error message from response body (from FastAPI error response)
  static String _extractErrorMessage(String body) {
    try {
      final decoded = json.decode(body);
      // FastAPI returns 'detail' field for error messages
      if (decoded is Map) {
        return decoded['detail'] ??
            decoded['message'] ??
            decoded['error'] ??
            'Terjadi kesalahan';
      }
      return 'Terjadi kesalahan';
    } catch (e) {
      return 'Terjadi kesalahan';
    }
  }

  /// Handle errors
  static Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error is http.ClientException) {
      return ApiException('Kesalahan jaringan: ${error.message}', 0);
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused')) {
      return ApiException(
        'Tidak dapat terhubung ke server. Pastikan:\n'
        '1. Backend server sudah berjalan\n'
        '2. URL server sudah benar\n'
        '3. Perangkat terhubung ke jaringan yang sama',
        0,
      );
    } else if (error.toString().contains('TimeoutException')) {
      return ApiException('Koneksi timeout. Server tidak merespons.', 0);
    } else {
      return ApiException('Terjadi kesalahan: $error', 0);
    }
  }
}

/// Custom API Exception
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
