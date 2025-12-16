class Family {
  final int id;
  final String familyNumber;
  final int? headResidentId;
  final int residentCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? headResidentName;
  final String? ownershipStatus;

  const Family({
    required this.id,
    required this.familyNumber,
    this.headResidentId,
    this.residentCount = 0,
    this.createdAt,
    this.updatedAt,
    this.headResidentName,
    this.ownershipStatus,
  });

  /// Convenience getter for UI label (keeps backward compatibility with
  /// older templates that used `namaKeluarga`).
  String get namaKeluarga => familyNumber;

  Family copyWith({
    int? id,
    String? familyNumber,
    int? headResidentId,
    int? residentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? headResidentName,
  }) {
    return Family(
      id: id ?? this.id,
      familyNumber: familyNumber ?? this.familyNumber,
      headResidentId: headResidentId ?? this.headResidentId,
      residentCount: residentCount ?? this.residentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      headResidentName: headResidentName ?? this.headResidentName,
      
    );
  }

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: (json['id'] is int) ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      familyNumber: json['family_number'] as String? ?? json['nama_keluarga'] as String? ?? '',
      headResidentId: json['head_resident_id'] is int
          ? json['head_resident_id'] as int
          : (json['head_resident_id'] != null ? int.tryParse('${json['head_resident_id']}') : null),
      residentCount: json['resident_count'] is int ? json['resident_count'] as int : int.tryParse('${json['resident_count'] ?? 0}') ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
      // Prefer server-provided head_resident object (new API shape). Keep
      // backward-compatibility with `head_resident_name` string when present.
      headResidentName: (() {
        if (json['head_resident'] != null && json['head_resident'] is Map) {
          final hr = json['head_resident'] as Map<String, dynamic>;
          return hr['name'] as String? ?? hr['nama'] as String? ?? null;
        }
        return json['head_resident_name'] as String? ?? null;
      })(),
      ownershipStatus: (() {
        return json['ownership_status'] as String?
            ?? json['ownership'] as String?
            ?? json['status_kepemilikan'] as String?
            ?? null;
      })(),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_number': familyNumber,
      'head_resident_id': headResidentId,
      'resident_count': residentCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'head_resident_name': headResidentName,
      'ownership_status': ownershipStatus,
    };
  }
}
