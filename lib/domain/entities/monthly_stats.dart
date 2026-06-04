class MonthlyStats {
  const MonthlyStats({
    required this.month,
    required this.fuelTotal,
    required this.maintenanceTotal,
    required this.fuelLiters,
    required this.fuelByVehicle,
  });

  final DateTime month;
  final double fuelTotal;
  final double maintenanceTotal;
  final double fuelLiters;
  final Map<String, double> fuelByVehicle;

  double get total => fuelTotal + maintenanceTotal;

  double get fuelSharePercent =>
      total == 0 ? 0 : (fuelTotal / total) * 100;

  double get maintenanceSharePercent =>
      total == 0 ? 0 : (maintenanceTotal / total) * 100;
}
