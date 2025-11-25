enum RegistrationStatus { pending, accepted, inactive }

class Resident {
  final int id;
  final String name;
  final String nik;
  final String email;
  final String gender;
  final String status; // Changed from RegistrationStatus to String
  final RegistrationStatus registrationStatus;
  final String? phone;
  final DateTime? birthDate;
  final String? address;
  final int? familyId;
  final String? photoUrl;

  const Resident({
    required this.id,
    required this.name,
    required this.nik,
    required this.email,
    required this.gender,
    required this.status,
    required this.registrationStatus,
    this.phone,
    this.birthDate,
    this.address,
    this.familyId,
    this.photoUrl,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'] as int,
      name: json['name'] as String,
      nik: json['nik'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String? ?? 'Aktif',
      registrationStatus: _statusFromString(json['registration_status'] as String? ?? 'accepted'),
      phone: json['phone'] as String?,
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      address: json['address'] as String?,
      familyId: json['family_id'] as int?,
      photoUrl: json['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'email': email,
      'gender': gender,
      'status': status,
      'registration_status': registrationStatus.name,
      'phone': phone,
      'birth_date': birthDate?.toIso8601String(),
      'address': address,
      'family_id': familyId,
      'photo_url': photoUrl,
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
        return RegistrationStatus.pending;
    }
  }

  Resident copyWith({
    int? id,
    String? name,
    String? nik,
    String? email,
    String? gender,
    String? status,
    RegistrationStatus? registrationStatus,
    String? phone,
    DateTime? birthDate,
    String? address,
    int? familyId,
    String? photoUrl,
  }) {
    return Resident(
      id: id ?? this.id,
      name: name ?? this.name,
      nik: nik ?? this.nik,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      registrationStatus: registrationStatus ?? this.registrationStatus,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      familyId: familyId ?? this.familyId,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}