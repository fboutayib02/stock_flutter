import 'package:flutter_test/flutter_test.dart';
import 'package:stock_flutter/domain/entities/monthly_stats.dart';

void main() {
  test('MonthlyStats calcule les parts carburant / entretien', () {
    final stats = MonthlyStats(
      month: DateTime(2026, 6),
      fuelTotal: 70,
      maintenanceTotal: 30,
      fuelLiters: 100,
      fuelByVehicle: {},
    );
    expect(stats.total, 100);
    expect(stats.fuelSharePercent, 70);
    expect(stats.maintenanceSharePercent, 30);
  });
}
