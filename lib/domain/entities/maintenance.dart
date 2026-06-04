class Maintenance {
  const Maintenance({
    required this.id,
    required this.vehicleId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.performedAt,
  });

  final String id;
  final String vehicleId;
  final String categoryId;
  final String description;
  final double amount;
  final DateTime performedAt;
}
