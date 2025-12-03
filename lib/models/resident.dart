enum RegistrationStatus { pending, accepted, inactive }

class Resident {
  final int id;
  final String name;
  final String nik;
  final String gender;
  final String status; // aktif, pindah, meninggal
  final int familyId;
  final int houseId;
  final RegistrationStatus registrationStatus;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime? birthDate;
  final String? birthPlace;
  final String? religion;
  final String? bloodType;
  final String? education;
  final String? occupation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Resident({
    required this.id,
    required this.name,
    required this.nik,
    required this.gender,
    required this.status,
    required this.familyId,
    required this.houseId,
    this.registrationStatus = RegistrationStatus.accepted,
    this.phone,
    this.email,
    this.address,
    this.birthDate,
    this.birthPlace,
    this.religion,
    this.bloodType,
    this.education,
    this.occupation,
    this.createdAt,
    this.updatedAt,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nik: json['nik'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Laki-laki',
      status: json['status'] as String? ?? 'aktif',
      familyId: json['family_id'] as int? ?? 1,
      houseId: json['house_id'] as int? ?? 1,
      registrationStatus: _statusFromString(
        json['registration_status'] as String? ?? 'accepted',
      ),
      phone: json['phone'] as String?,
      email:
          json['email'] as String? ??
          (json['user'] != null ? json['user']['email'] as String? : null),
      address:
          json['address'] as String? ??
          (json['house'] != null ? json['house']['address'] as String? : null),
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      birthPlace: json['birth_place'] as String?,
      religion: json['religion'] as String?,
      bloodType: json['blood_type'] as String?,
      education: json['education'] as String?,
      occupation: json['occupation'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'gender': gender,
      'status': status,
      'registration_status': registrationStatus.name,
      'phone': phone,
      'email': email,
      'address': address,
      'birth_date': birthDate?.toIso8601String(),
      'birth_place': birthPlace,
      'religion': religion,
      'blood_type': bloodType,
      'education': education,
      'occupation': occupation,
      'family_id': familyId,
      'house_id': houseId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static RegistrationStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RegistrationStatus.pending;
      case 'accepted':
        return RegistrationStatus.accepted;
      case 'inactive':
        return RegistrationStatus.inactive;
      default:
        return RegistrationStatus.accepted;
    }
  }

  Resident copyWith({
    int? id,
    String? name,
    String? nik,
    String? gender,
    String? status,
    RegistrationStatus? registrationStatus,
    String? phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? birthPlace,
    String? religion,
    String? bloodType,
    String? education,
    String? occupation,
    int? familyId,
    int? houseId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Resident(
      id: id ?? this.id,
      name: name ?? this.name,
      nik: nik ?? this.nik,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      registrationStatus: registrationStatus ?? this.registrationStatus,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      religion: religion ?? this.religion,
      bloodType: bloodType ?? this.bloodType,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      familyId: familyId ?? this.familyId,
      houseId: houseId ?? this.houseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
