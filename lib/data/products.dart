import 'dart:io';
import 'package:jawara/models/marketplace_product.dart';
import 'package:jawara/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  // Update product
  static Future<MarketplaceProduct> updateProduct({
    required int id,
    required String name,
    required double price,
    required String description,
    String? imageFile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      // Call API dengan parameter yang benar
      await ApiService.updateMarketplaceProduct(
        id,
        token: token,
        name: name,
        price: price,
        description: description,
        imagePath: imageFile,
      );

      // Return dummy product untuk sementara
      return MarketplaceProduct(
        id: id,
        residentId: 0, // Akan di-update dari response API
        name: name,
        price: price,
        description: description,
        quantity: 0,
        unit: 'pcs',
        imagePath: imageFile ?? '',
        status: 'active',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Gagal mengupdate produk: $e');
    }
  }

  // Delete product
  static Future<void> deleteProduct(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      await ApiService.deleteMarketplaceProduct(id, token: token);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}
