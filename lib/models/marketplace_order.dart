class MarketplaceOrder {
  final int id;
  final int productId;
  final int buyerId;
  final int sellerId;
  final int quantity;
  final double totalPrice;
  final String paymentMethod; // cash, transfer
  final String status; // pending, paid, delivered, cancelled
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? deliveredAt;
  final String? buyerName;
  final String? sellerName;
  final String? productName;

  const MarketplaceOrder({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.paidAt,
    this.deliveredAt,
    this.buyerName,
    this.sellerName,
    this.productName,
  });

  factory MarketplaceOrder.fromJson(Map<String, dynamic> json) {
    return MarketplaceOrder(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      buyerId: json['buyer_id'] as int,
      sellerId: json['seller_id'] as int,
      quantity: json['quantity'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      buyerName: json['buyer_name'] as String?,
      sellerName: json['seller_name'] as String?,
      productName: json['product_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'quantity': quantity,
      'total_price': totalPrice,
      'payment_method': paymentMethod,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'buyer_name': buyerName,
      'seller_name': sellerName,
      'product_name': productName,
    };
  }
}
