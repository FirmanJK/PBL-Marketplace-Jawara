enum RegistrationStatus { pending, accepted, inactive }

class Resident {
  final int id;
  final String name;
  final String nik;
  final String email;
  final String gender;
  final RegistrationStatus status;

  const Resident({
    required this.id,
    required this.name,
    required this.nik,
    required this.email,
    required this.gender,
    required this.status,
  });
}