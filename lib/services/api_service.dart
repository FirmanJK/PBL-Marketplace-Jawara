import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base API Service untuk semua HTTP requests
class ApiService {
  // Base URL - ganti dengan URL backend Anda
  // Untuk Android Emulator gunakan: http://10.0.2.2:3000/api
  // Untuk iOS Simulator gunakan: http://localhost:3000/api
  // Untuk Physical Device gunakan: http://YOUR_IP:3000/api
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
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
      final response = await http
          .put(
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

  /// DELETE request
  static Future<dynamic> delete(
    String endpoint, {
    String? token,
  }) async {
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
    } else if (statusCode == 401) {
      throw ApiException('Unauthorized', statusCode);
    } else if (statusCode == 403) {
      throw ApiException('Forbidden', statusCode);
    } else if (statusCode == 404) {
      throw ApiException('Not Found', statusCode);
    } else if (statusCode >= 500) {
      throw ApiException('Server Error', statusCode);
    } else {
      final errorMessage = _extractErrorMessage(body);
      throw ApiException(errorMessage, statusCode);
    }
  }

  /// Extract error message from response body
  static String _extractErrorMessage(String body) {
    try {
      final decoded = json.decode(body);
      return decoded['message'] ?? decoded['error'] ?? 'Unknown error';
    } catch (e) {
      return 'Unknown error';
    }
  }

  /// Handle errors
  static Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error is http.ClientException) {
      return ApiException('Network error: ${error.message}', 0);
    } else {
      return ApiException('Unexpected error: $error', 0);
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
