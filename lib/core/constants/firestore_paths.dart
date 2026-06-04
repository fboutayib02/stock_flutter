/// Chemins Firestore avec isolation par conducteur (multi-tenant).
abstract final class FirestorePaths {
  static String userRoot(String userId) => 'users/$userId';

  static String vehicles(String userId) => '${userRoot(userId)}/vehicles';

  static String vehicle(String userId, String vehicleId) =>
      '${vehicles(userId)}/$vehicleId';

  static String fuelEntries(String userId) =>
      '${userRoot(userId)}/fuel_entries';

  static String maintenances(String userId) =>
      '${userRoot(userId)}/maintenances';

  static String maintenanceCategories(String userId) =>
      '${userRoot(userId)}/maintenance_categories';
}
