class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final int userId;
  final int stock;
  final String? sellerName;
  final String? sellerPhone;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.userId,
    this.stock = 99,
    this.sellerName,
    this.sellerPhone,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as int,
      stock: json['stock'] as int? ?? 99,
      sellerName: json['seller_name'] as String?,
      sellerPhone: json['seller_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'stock': stock,
      'seller_name': sellerName,
      'seller_phone': sellerPhone,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    int? userId,
    int? stock,
    String? sellerName,
    String? sellerPhone,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      stock: stock ?? this.stock,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
    );
  }
}
