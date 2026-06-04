import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_flutter/core/utils/firestore_timestamp.dart';

void main() {
  test('parseFirestoreDate gère Timestamp et DateTime', () {
    final dt = DateTime(2026, 6, 4, 12);
    expect(parseFirestoreDate(Timestamp.fromDate(dt)), dt);
    expect(parseFirestoreDate(dt), dt);
    expect(parseFirestoreDate('2026-06-04'), DateTime(2026, 6, 4));
  });
}
