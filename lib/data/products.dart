import 'dart:io';
import 'package:jawara/models/product.dart';

class ProductService {
  // Base URL untuk API - sesuaikan dengan backend Anda
  static const String baseUrl = 'http://your-api-url.com/api';

  // Simulasi data dummy untuk development
  static List<Product> _dummyProducts = [
    Product(
      id: 1,
      name: 'Kursi Kayu Jati',
      price: 500000,
      description: 'Kursi kayu jati berkualitas tinggi, kondisi 90%',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      userId: 1,
      stock: 5,
      sellerName: 'Budi Santoso',
      sellerPhone: '081234567890',
    ),
    Product(
      id: 2,
      name: 'Meja Belajar',
      price: 350000,
      description: 'Meja belajar minimalis, cocok untuk anak sekolah',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      userId: 2,
      stock: 3,
      sellerName: 'Siti Aminah',
      sellerPhone: '081234567891',
    ),
    Product(
      id: 3,
      name: 'Lemari Pakaian',
      price: 750000,
      description: 'Lemari pakaian 2 pintu, kayu solid',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      userId: 1,
      stock: 2,
      sellerName: 'Budi Santoso',
      sellerPhone: '081234567890',
    ),
    Product(
      id: 4,
      name: 'Kasur Spring Bed',
      price: 1200000,
      description: 'Kasur spring bed ukuran 160x200, kondisi seperti baru',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      userId: 3,
      stock: 1,
      sellerName: 'Ahmad Yani',
      sellerPhone: '081234567892',
    ),
    Product(
      id: 5,
      name: 'Sepeda Gunung',
      price: 2500000,
      description: 'Sepeda gunung 21 speed, jarang dipakai',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      userId: 4,
      stock: 1,
      sellerName: 'Dewi Lestari',
      sellerPhone: '081234567893',
    ),
    Product(
      id: 6,
      name: 'Kulkas 2 Pintu',
      price: 1800000,
      description: 'Kulkas 2 pintu merk Samsung, masih dingin',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      userId: 2,
      stock: 1,
      sellerName: 'Siti Aminah',
      sellerPhone: '081234567891',
    ),
    Product(
      id: 7,
      name: 'TV LED 32 Inch',
      price: 1500000,
      description: 'TV LED 32 inch, kondisi mulus',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      userId: 5,
      stock: 2,
      sellerName: 'Eko Prasetyo',
      sellerPhone: '081234567894',
    ),
    Product(
      id: 8,
      name: 'Mesin Cuci',
      price: 1300000,
      description: 'Mesin cuci 1 tabung, hemat listrik',
      imageUrl: 'assets/placeholder.png',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      userId: 3,
      stock: 1,
      sellerName: 'Ahmad Yani',
      sellerPhone: '081234567892',
    ),
  ];

  // Fetch products dengan pagination
  static Future<List<Product>> fetchProducts({
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulasi network delay

    // TODO: Implementasi real API call
    // final response = await http.get(
    //   Uri.parse('$baseUrl/products?page=$page&limit=$limit'),
    // );
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   return data.map((json) => Product.fromJson(json)).toList();
    // }

    // Return dummy data untuk development
    final start = (page - 1) * limit;
    final end = start + limit;
    if (start >= _dummyProducts.length) return [];
    return _dummyProducts.sublist(
      start,
      end > _dummyProducts.length ? _dummyProducts.length : end,
    );
  }

  // Create product dengan image upload
  static Future<Product> createProduct({
    required String name,
    required double price,
    required String description,
    required File imageFile,
    required int userId,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi network delay

    // TODO: Implementasi real API call dengan multipart
    // var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/products'));
    // request.fields['name'] = name;
    // request.fields['price'] = price.toString();
    // request.fields['description'] = description;
    // request.fields['user_id'] = userId.toString();
    // request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    // var response = await request.send();
    // if (response.statusCode == 201) {
    //   final responseData = await response.stream.bytesToString();
    //   return Product.fromJson(json.decode(responseData));
    // }

    // Simulasi create untuk development
    final newProduct = Product(
      id: _dummyProducts.length + 1,
      name: name,
      price: price,
      description: description,
      imageUrl: imageFile.path,
      createdAt: DateTime.now(),
      userId: userId,
    );
    _dummyProducts.add(newProduct);
    return newProduct;
  }

  // Update product
  static Future<Product> updateProduct({
    required int id,
    required String name,
    required double price,
    required String description,
    File? imageFile,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Implementasi real API call
    // var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/products/$id'));
    // request.fields['name'] = name;
    // request.fields['price'] = price.toString();
    // request.fields['description'] = description;
    // if (imageFile != null) {
    //   request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    // }

    final index = _dummyProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final updated = _dummyProducts[index].copyWith(
        name: name,
        price: price,
        description: description,
        imageUrl: imageFile?.path ?? _dummyProducts[index].imageUrl,
      );
      _dummyProducts[index] = updated;
      return updated;
    }
    throw Exception('Product not found');
  }

  // Delete product
  static Future<void> deleteProduct(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Implementasi real API call
    // final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    // if (response.statusCode != 200) throw Exception('Failed to delete');

    _dummyProducts.removeWhere((p) => p.id == id);
  }

  // Get product by ID
  static Future<Product> getProductById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Implementasi real API call
    // final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    // if (response.statusCode == 200) {
    //   return Product.fromJson(json.decode(response.body));
    // }

    final product = _dummyProducts.firstWhere((p) => p.id == id);
    return product;
  }
  
  // Getter untuk mengakses dummy products dari luar
  static List<Product> get dummyProducts => _dummyProducts;
}
