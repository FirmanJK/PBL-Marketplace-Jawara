import 'package:flutter/material.dart';

class Transaction {
  final int id;
  final int productId;
  final int buyerId;
  final int sellerId;
  final int quantity;
  final double totalPrice;
  final String status; // pending, paid, shipped, completed, cancelled
  final String? shippingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    this.shippingAddress,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      buyerId: json['buyer_id'] as int,
      sellerId: json['seller_id'] as int,
      quantity: json['quantity'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      shippingAddress: json['shipping_address'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
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
      'status': status,
      'shipping_address': shippingAddress,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Transaction copyWith({
    int? id,
    int? productId,
    int? buyerId,
    int? sellerId,
    int? quantity,
    double? totalPrice,
    String? status,
    String? shippingAddress,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String getStatusText() {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Dibayar';
      case 'shipped':
        return 'Dikirim';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color getStatusColor() {
    switch (status) {
      case 'pending':
        return const Color(0xFFF59E0B); // Orange
      case 'paid':
        return const Color(0xFF3B82F6); // Blue
      case 'shipped':
        return const Color(0xFF8B5CF6); // Purple
      case 'completed':
        return const Color(0xFF10B981); // Green
      case 'cancelled':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
}
