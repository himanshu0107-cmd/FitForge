import 'package:drift/drift.dart';
import 'package:fitforge/data/local/database.dart';
import 'package:uuid/uuid.dart';

class WaterRepository {
  final AppDatabase _db;
  const WaterRepository(this._db);

  Future<void> logWater(int amountMl) async {
    await _db.into(_db.waterLogs).insert(
          WaterLogsCompanion.insert(
            id: const Uuid().v4(),
            amountMl: amountMl,
            loggedAt: DateTime.now(),
          ),
        );
  }

  Future<int> getTodayWaterIntake() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = _db.select(_db.waterLogs)
      ..where((t) =>
          t.loggedAt.isBiggerOrEqualValue(startOfDay) &
          t.loggedAt.isSmallerThanValue(endOfDay));

    final logs = await query.get();
    return logs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  Future<List<WaterLog>> getTodayWaterLogs() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = _db.select(_db.waterLogs)
      ..where((t) =>
          t.loggedAt.isBiggerOrEqualValue(startOfDay) &
          t.loggedAt.isSmallerThanValue(endOfDay))
      ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]);

    return await query.get();
  }

  Future<void> deleteWaterLog(String id) async {
    await (_db.delete(_db.waterLogs)..where((t) => t.id.equals(id))).go();
  }
}
