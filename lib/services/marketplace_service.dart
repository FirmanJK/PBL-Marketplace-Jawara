import 'package:jawara/models/verification_result.dart';
import 'package:jawara/models/marketplace_product.dart';
import 'package:jawara/models/marketplace_order.dart';
import 'package:jawara/services/api_service.dart';

/// Business logic service untuk marketplace & verifikasi sayur
class MarketplaceService {
  /// Verifikasi keutuhan sayur
  static Future<VerificationResult> verifyVegetable(
    String imagePath, {
    required String token,
  }) async {
    try {
      final response = await ApiService.verifyVegetable(
        imagePath,
        token: token,
      );

      return VerificationResult.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Dapatkan hasil verifikasi
  static Future<VerificationResult> getVerificationResult(
    int id, {
    required String token,
  }) async {
    try {
      final response = await ApiService.getVerificationResult(id, token: token);
      return VerificationResult.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Dapatkan semua hasil verifikasi
  static Future<List<VerificationResult>> getVerificationResults({
    required String token,
    bool? isValid,
  }) async {
    try {
      final response = await ApiService.getVerificationResults(
        token: token,
        isValid: isValid,
      );

      return response
          .map(
            (item) =>
                VerificationResult.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Buat produk marketplace
  static Future<MarketplaceProduct> createProduct({
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
      final response = await ApiService.createMarketplaceProduct(
        verificationResultId: verificationResultId,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        unit: unit,
        imagePath: imagePath,
        token: token,
      );
      return MarketplaceProduct.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Dapatkan semua produk
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
            (item) =>
                MarketplaceProduct.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Dapatkan produk single
  static Future<MarketplaceProduct> getProduct(int id, {String? token}) async {
    try {
      final response = await ApiService.getMarketplaceProduct(id, token: token);
      return MarketplaceProduct.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Update produk
  static Future<MarketplaceProduct> updateProduct(
    int id, {
    required String token,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? status,
  }) async {
    try {
      final response = await ApiService.updateMarketplaceProduct(
        id,
        token: token,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        status: status,
      );
      return MarketplaceProduct.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Buat order
  static Future<MarketplaceOrder> createOrder({
    required int productId,
    required int quantity,
    required String paymentMethod,
    required String token,
  }) async {
    try {
      final response = await ApiService.createMarketplaceOrder(
        productId: productId,
        quantity: quantity,
        paymentMethod: paymentMethod,
        token: token,
      );
      return MarketplaceOrder.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Dapatkan semua order
  static Future<List<MarketplaceOrder>> getOrders({
    String? status,
    required String token,
  }) async {
    try {
      final response = await ApiService.getMarketplaceOrders(
        status: status,
        token: token,
      );

      return response
          .map(
            (item) => MarketplaceOrder.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Dapatkan order single
  static Future<MarketplaceOrder> getOrder(
    int id, {
    required String token,
  }) async {
    try {
      final response = await ApiService.getMarketplaceOrder(id, token: token);
      return MarketplaceOrder.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Update order
  static Future<MarketplaceOrder> updateOrder(
    int id, {
    required String token,
    String? status,
    String? paymentMethod,
  }) async {
    try {
      final response = await ApiService.updateMarketplaceOrder(
        id,
        token: token,
        status: status,
        paymentMethod: paymentMethod,
      );
      return MarketplaceOrder.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
