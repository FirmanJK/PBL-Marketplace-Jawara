import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:jawara/models/cart_item.dart';
import 'package:jawara/models/marketplace_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal() {
    loadCart(); // Auto-load cart saat service dibuat
  }

  final List<CartItem> _items = [];
  static const String _cartKey = 'shopping_cart';

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(MarketplaceProduct product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    _saveCart(); // Simpan setiap ada perubahan
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart(); // Simpan setiap ada perubahan
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      _saveCart(); // Simpan setiap ada perubahan
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart(); // Simpan setiap ada perubahan
    notifyListeners();
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getQuantity(int productId) {
    try {
      final item = _items.firstWhere((item) => item.product.id == productId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  // Simpan cart ke SharedPreferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = _items.map((item) {
        return {'product': item.product.toJson(), 'quantity': item.quantity};
      }).toList();
      await prefs.setString(_cartKey, jsonEncode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Load cart dari SharedPreferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      if (cartString != null) {
        final List<dynamic> cartData = jsonDecode(cartString);
        _items.clear();

        for (var item in cartData) {
          final product = MarketplaceProduct.fromJson(item['product']);
          final quantity = item['quantity'] as int;
          _items.add(CartItem(product: product, quantity: quantity));
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }
}
