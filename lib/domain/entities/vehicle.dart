class Vehicle {
  const Vehicle({
    required this.id,
    required this.label,
    required this.plate,
    this.odometerKm,
    required this.createdAt,
  });

  final String id;
  final String label;
  final String plate;
  final int? odometerKm;
  final DateTime createdAt;
}
