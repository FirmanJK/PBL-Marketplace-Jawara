class House {
  final int id;
  final String? houseNumber;
  final String? address;
  final String? rt;
  final String? rw;
  final int residentCount;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const House({
    required this.id,
    this.houseNumber,
    this.address,
    this.rt,
    this.rw,
    this.residentCount = 0,
    this.status = 'available',
    this.createdAt,
    this.updatedAt,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: (json['id'] is int) ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      houseNumber: json['house_number'] as String? ?? json['houseNumber'] as String?,
      address: json['address'] as String?,
      rt: json['rt'] as String?,
      rw: json['rw'] as String?,
      residentCount: json['resident_count'] is int ? json['resident_count'] as int : int.tryParse('${json['resident_count'] ?? 0}') ?? 0,
      status: json['status'] as String? ?? 'available',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'house_number': houseNumber,
      'address': address,
      'rt': rt,
      'rw': rw,
      'status': status,
      'resident_count': residentCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
