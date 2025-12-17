import 'dart:io';
import 'package:jawara/models/marketplace_product.dart';
import 'package:jawara/services/api_service.dart';

/// Service untuk manage marketplace products dengan backend API
class ProductService {
  /// Create product
  static Future<MarketplaceProduct> createProduct({
    required int verificationResultId,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String unit,
    required String token,
    File? imageFile,
  }) async {
    try {
      // If image is provided, upload via multipart
      if (imageFile != null) {
        final response = await ApiService.multipart(
          '/marketplace-products',
          'POST',
          fields: {
            'verification_result_id': verificationResultId.toString(),
            'name': name,
            'description': description,
            'price': price.toString(),
            'quantity': quantity.toString(),
            'unit': unit,
          },
          files: {'image': imageFile.path},
          token: token,
        );

        if (response is Map && response['data'] != null) {
          return MarketplaceProduct.fromJson(response['data']);
        }
        return MarketplaceProduct.fromJson(response);
      } else {
        // Create without image
        final response = await ApiService.post(
          '/marketplace-products',
          body: {
            'verification_result_id': verificationResultId,
            'name': name,
            'description': description,
            'price': price,
            'quantity': quantity,
            'unit': unit,
          },
          token: token,
        );

        if (response is Map && response['data'] != null) {
          return MarketplaceProduct.fromJson(response['data']);
        }
        return MarketplaceProduct.fromJson(response);
      }
    } catch (e) {
      throw Exception('Gagal membuat produk: $e');
    }
  }

  /// Update product
  static Future<MarketplaceProduct> updateProduct({
    required int id,
    required String name,
    required double price,
    required String description,
    required String token,
    File? imageFile,
  }) async {
    try {
      // If image is provided, upload via multipart
      if (imageFile != null) {
        final response = await ApiService.multipart(
          '/marketplace-products/$id',
          'PUT',
          fields: {
            'name': name,
            'description': description,
            'price': price.toString(),
          },
          files: {'image': imageFile.path},
          token: token,
        );

        if (response is Map && response['data'] != null) {
          return MarketplaceProduct.fromJson(response['data']);
        }
        return MarketplaceProduct.fromJson(response);
      } else {
        // Update without image
        final response = await ApiService.put(
          '/marketplace-products/$id',
          body: {'name': name, 'description': description, 'price': price},
          token: token,
        );

        if (response is Map && response['data'] != null) {
          return MarketplaceProduct.fromJson(response['data']);
        }
        return MarketplaceProduct.fromJson(response);
      }
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  /// Delete product
  static Future<void> deleteProduct(int id, {required String token}) async {
    try {
      await ApiService.delete('/marketplace-products/$id', token: token);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  /// Get product by ID
  static Future<MarketplaceProduct> getProduct(int id, {String? token}) async {
    try {
      final response = await ApiService.get(
        '/marketplace-products/$id',
        token: token,
      );

      if (response is Map && response['data'] != null) {
        return MarketplaceProduct.fromJson(response['data']);
      }
      return MarketplaceProduct.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }

  /// Get all products
  static Future<List<MarketplaceProduct>> getProducts({
    String? status,
    String? token,
  }) async {
    try {
      final response = await ApiService.getMarketplaceProducts(
        status: status,
        token: token,
      );

      return response
          .map(
            (item) => MarketplaceProduct.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar produk: $e');
    }
  }
}
