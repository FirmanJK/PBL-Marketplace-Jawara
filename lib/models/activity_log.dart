class ActivityLog {
  final int id;
  final String description;
  final String actor;
  final DateTime timestamp;

  const ActivityLog({
    required this.id,
    required this.description,
    required this.actor,
    required this.timestamp,
  });
}