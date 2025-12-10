class ResidentApproval {
  final int id;
  final int? residentId;
  final String? name;
  final String? nik;
  final String? gender;
  final String? birthPlace;
  final String? birthDate;
  final String? address;
  final String? phone;
  final String? email;
  final String status; // pending_approval, approved, rejected
  final String? note;
  final int? approvedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ResidentApproval({
    required this.id,
    this.residentId,
    this.name,
    this.nik,
    this.gender,
    this.birthPlace,
    this.birthDate,
    this.address,
    this.phone,
    this.email,
    required this.status,
    this.note,
    this.approvedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory ResidentApproval.fromJson(Map<String, dynamic> json) {
    return ResidentApproval(
      id: json['id'] as int? ?? 0,
      residentId: json['resident_id'] as int?,
      name: json['name'] as String?,
      nik: json['nik'] as String?,
      gender: json['gender'] as String?,
      birthPlace: json['birth_place'] as String?,
      birthDate: json['birth_date'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String? ?? 'pending_approval',
      note: json['note'] as String?,
      approvedBy: json['approved_by'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'resident_id': residentId,
    'name': name,
    'nik': nik,
    'gender': gender,
    'birth_place': birthPlace,
    'birth_date': birthDate,
    'address': address,
    'phone': phone,
    'email': email,
    'status': status,
    'note': note,
    'approved_by': approvedBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  /// Get status display label
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending_approval':
        return 'Menunggu Persetujuan';
      case 'approved':
        return 'Diterima';
      case 'rejected':
        return 'Ditolak';
      default:
        return status;
    }
  }

  /// Check if approval is pending
  bool get isPending => status.toLowerCase() == 'pending_approval';

  /// Check if approval is approved
  bool get isApproved => status.toLowerCase() == 'approved';

  /// Check if approval is rejected
  bool get isRejected => status.toLowerCase() == 'rejected';

  /// Get age from birth_date (if available)
  int? get age {
    if (birthDate == null) return null;
    try {
      final dob = DateTime.parse(birthDate!);
      final now = DateTime.now();
      return now.year - dob.year;
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() =>
      'ResidentApproval(id: $id, name: $name, status: $status)';
}
