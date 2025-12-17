class MarketplaceProduct {
  final int id;
  final int residentId;
  final int? verificationResultId; // FK to verification_results (bisa null)
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String unit; // kg, piece, bundle
  final String imagePath;
  final String status; // active, sold_out, inactive
  final DateTime createdAt;
  final String? sellerName;
  final String? sellerPhone;

  const MarketplaceProduct({
    required this.id,
    required this.residentId,
    this.verificationResultId, // Tidak wajib
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imagePath,
    required this.status,
    required this.createdAt,
    this.sellerName,
    this.sellerPhone,
  });

  factory MarketplaceProduct.fromJson(Map<String, dynamic> json) {
    return MarketplaceProduct(
      id: json['id'] as int,
      residentId: json['residentId'] ?? json['resident_id'] as int,
      verificationResultId:
          json['verificationResultId'] ??
          json['verification_result_id'] as int?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      unit: json['unit'] as String? ?? 'pcs',
      imagePath: json['imagePath'] ?? json['image_path'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.now()),
      sellerName: json['sellerName'] ?? json['seller_name'] as String?,
      sellerPhone: json['sellerPhone'] ?? json['seller_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident_id': residentId,
      'verification_result_id': verificationResultId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'image_path': imagePath,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'seller_name': sellerName,
      'seller_phone': sellerPhone,
    };
  }

  // Helper untuk mendapatkan URL gambar lengkap
  String getImageUrl() {
    if (imagePath.isEmpty) return '';

    // Jika sudah HTTP URL, return langsung
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Jika path lokal device (full path), extract filename saja
    String filename = imagePath;
    if (imagePath.contains('/')) {
      filename = imagePath.split('/').last;
    }

    // Gabungkan dengan base URL backend
    const baseUrl = 'http://10.0.2.2:8000'; // Sesuaikan dengan ApiService

    // Return full URL
    return '$baseUrl/uploads/$filename';
  }
}
