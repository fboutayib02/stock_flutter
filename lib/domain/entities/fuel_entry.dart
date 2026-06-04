class FuelEntry {
  const FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.liters,
    required this.amount,
    required this.filledAt,
    this.station,
  });

  final String id;
  final String vehicleId;
  final double liters;
  final double amount;
  final DateTime filledAt;
  final String? station;
}
