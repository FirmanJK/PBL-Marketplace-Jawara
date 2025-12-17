import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base API Service untuk semua HTTP requests
class ApiService {
  // Base URL - Backend FastAPI berjalan di port 8000
  // Untuk Android Emulator gunakan: http://10.0.2.2:8000
  // Untuk iOS Simulator gunakan: http://localhost:8000
  // Untuk Physical Device gunakan: http://YOUR_IP:8000
  static const String baseUrl = 'http://10.0.2.2:8000';
  // static const String baseUrl = 'http://localhost:8000';

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
          // Determine content type from file extension
          String contentType = 'image/jpeg'; // default
          final filePath = entry.value.toLowerCase();
          if (filePath.endsWith('.png')) {
            contentType = 'image/png';
          } else if (filePath.endsWith('.bmp')) {
            contentType = 'image/bmp';
          } else if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
            contentType = 'image/jpeg';
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,
              entry.value,
              contentType: http.MediaType.parse(contentType),
            ),
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

  // ===== MARKETPLACE & VERIFICATION ENDPOINTS =====

  /// Verify vegetable image and get prediction
  /// POST /verify-vegetable
  static Future<Map<String, dynamic>> verifyVegetable(
    String imagePath, {
    required String token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/verify-vegetable');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(_headersWithAuth(token));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload product image
  /// POST /marketplace/upload-image
  static Future<String> uploadProductImage(
    String imagePath, {
    required String token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/marketplace/upload-image');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(_headersWithAuth(token));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      final result = _handleResponse(response);
      return result['image_url'] as String;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all verification results for current resident
  /// GET /verification-results
  static Future<List<dynamic>> getVerificationResults({
    required String token,
    bool? isValid,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (isValid != null) {
        queryParams['is_valid'] = isValid.toString();
      }

      final response = await get(
        '/verification-results',
        queryParams: queryParams,
        token: token,
      );

      if (response is List) {
        return response;
      } else if (response is Map && response['data'] is List) {
        return response['data'] as List;
      }
      return [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single verification result
  /// GET /verification-results/{id}
  static Future<Map<String, dynamic>> getVerificationResult(
    int id, {
    required String token,
  }) async {
    try {
      final response = await get('/verification-results/$id', token: token);
      if (response is Map && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return response as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create marketplace product
  /// POST /marketplace/products
  static Future<Map<String, dynamic>> createMarketplaceProduct({
    required int verificationResultId,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String unit,
    required String imagePath,
    required String token,
  }) async {
    try {
      final response = await post(
        '/marketplace/products',
        body: {
          'verification_result_id': verificationResultId,
          'name': name,
          'description': description,
          'price': price,
          'quantity': quantity,
          'unit': unit,
          'image_path': imagePath,
        },
        token: token,
      );

      if (response is Map && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return response as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all marketplace products
  /// GET /marketplace-products
  static Future<List<dynamic>> getMarketplaceProducts({
    String? status,
    String? token,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await get(
        '/marketplace/products',
        queryParams: queryParams,
        token: token,
      );

      if (response is List) {
        return response;
      } else if (response is Map && response['data'] is List) {
        return response['data'] as List;
      }
      return [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single marketplace product
  /// GET /marketplace/products/{id}
  static Future<Map<String, dynamic>> getMarketplaceProduct(
    int id, {
    String? token,
  }) async {
    try {
      final response = await get('/marketplace/products/$id', token: token);
      if (response is Map && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return response as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update marketplace product
  /// PUT /marketplace/products/{id}
  static Future<Map<String, dynamic>> updateMarketplaceProduct(
    int id, {
    required String token,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? status,
    String? imagePath, // Tambah parameter imagePath
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (price != null) body['price'] = price;
      if (quantity != null) body['quantity'] = quantity;
      if (status != null) body['status'] = status;
      if (imagePath != null) body['imagePath'] = imagePath; // Kirim imagePath

      final response = await put(
        '/marketplace/products/$id',
        body: body,
        token: token,
      );

      if (response is Map && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return response as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete marketplace product
  /// DELETE /marketplace/products/{id}
  static Future<void> deleteMarketplaceProduct(
    int id, {
    required String token,
  }) async {
    try {
      await delete('/marketplace/products/$id', token: token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create marketplace order
  /// POST /marketplace-orders
  static Future<Map<String, dynamic>> createMarketplaceOrder({
    required int productId,
    required int quantity,
    required String paymentMethod,
    required String token,
  }) async {
    try {
      final response = await post(
        '/marketplace-orders',
        body: {
          'product_id': productId,
          'quantity': quantity,
          'payment_method': paymentMethod,
        },
        token: token,
      );

      if (response is Map && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return response as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all marketplace orders
  /// GET /marketplace-orders
  static Future<List<dynamic>> getMarketplaceOrders({
    String? status,
    required String token,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await get(
        '/marketplace-orders',
        queryParams: queryParams,
        token: token,
      );

      if (response is List) {
        return response;
      } else if (response is Map && response['data'] is List) {
        return response['data'] as List;
      }
      return [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single marketplace order
  /// GET /marketplace-orders/{id}
  static Future<Map<String, dynamic>> getMarketplaceOrder(
    int id, {
    required String token,
  }) async {
    try {
      final response = await get('/marketplace-orders/$id', token: token);
      if (response is Map && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return response as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update marketplace order
  /// PUT /marketplace-orders/{id}
  static Future<Map<String, dynamic>> updateMarketplaceOrder(
    int id, {
    required String token,
    String? status,
    String? paymentMethod,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (status != null) body['status'] = status;
      if (paymentMethod != null) body['payment_method'] = paymentMethod;

      final response = await put(
        '/marketplace-orders/$id',
        body: body,
        token: token,
      );

      if (response is Map && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return response as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
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
