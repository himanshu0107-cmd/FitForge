import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../local/database.dart';
import '../../domain/models/diet_and_progress.dart';

class ProgressRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  ProgressRepository(this._db);

  Future<void> logWeight(double weightKg, {String? notes}) async {
    await _db.into(_db.weightLogs).insert(
          WeightLogsCompanion(
            id: Value(_uuid.v4()),
            weightKg: Value(weightKg),
            loggedAt: Value(DateTime.now()),
            notes: Value(notes),
          ),
        );
  }

  Future<List<WeightLog>> getWeightHistory({int? limit}) async {
    final query = _db.select(_db.weightLogs)..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]);
    if (limit != null) query.limit(limit);

    final results = await query.get();
    return results.map(_weightLogFromDb).toList();
  }

  Future<WeightLog?> getLatestWeight() async {
    final query = _db.select(_db.weightLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result != null ? _weightLogFromDb(result) : null;
  }

  Future<void> deleteWeightLog(String id) async {
    await (_db.delete(_db.weightLogs)..where((t) => t.id.equals(id))).go();
  }

  WeightLog _weightLogFromDb(WeightLog row) {
    return WeightLog(
      id: row.id,
      weightKg: row.weightKg,
      loggedAt: row.loggedAt,
      notes: row.notes,
    );
  }
}
