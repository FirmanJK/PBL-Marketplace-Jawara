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

      String? uploadedImageFilename;

      // Step 1: Upload image jika ada gambar baru
      if (imageFile != null && imageFile.isNotEmpty) {
        try {
          uploadedImageFilename = await ApiService.uploadProductImage(
            imageFile,
            token: token,
          );
          print('[DEBUG] Image uploaded: $uploadedImageFilename');
        } catch (e) {
          throw Exception('Gagal upload gambar: $e');
        }
      }

      // Step 2: Update produk dengan query parameters
      final queryParams = <String, dynamic>{
        'name': name,
        'description': description,
        'price': price.toString(),
      };

      if (uploadedImageFilename != null) {
        queryParams['imagePath'] = uploadedImageFilename;
      }

      final uri = Uri.parse(
        '${ApiService.baseUrl}/marketplace/products/$id',
      ).replace(queryParameters: queryParams);

      print('[DEBUG] Update URL: $uri');

      final response = await ApiService.put(
        '/marketplace/products/$id?name=${Uri.encodeComponent(name)}&description=${Uri.encodeComponent(description)}&price=$price${uploadedImageFilename != null ? '&imagePath=${Uri.encodeComponent(uploadedImageFilename)}' : ''}',
        token: token,
      );

      print('[DEBUG] Product updated: ID=$id, Name=$name');

      // Return dummy product untuk sementara
      return MarketplaceProduct(
        id: id,
        residentId: 0,
        name: name,
        price: price,
        description: description,
        quantity: 0,
        unit: 'pcs',
        imagePath: uploadedImageFilename ?? '',
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
