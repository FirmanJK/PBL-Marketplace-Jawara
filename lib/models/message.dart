enum Status { pending, accepted }

class CitizenMessage {
  final int id;
  final String senderName;
  final String title;
  final String description;
  final Status status;
  final DateTime createdAt;
  final String creatorName; 
  final String? creatorId;

  const CitizenMessage({
    required this.id,
    required this.senderName,
    required this.title,
    required this.description, 
    required this.status,
    required this.createdAt,
    required this.creatorName, 
    this.creatorId,
  });

  String get statusInIndonesian {
    switch (status) {
      case Status.accepted:
        return 'Diterima';
      case Status.pending:
        return 'Pending';
    }
  }
}