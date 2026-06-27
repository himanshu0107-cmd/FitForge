import 'package:drift/drift.dart';
import 'package:fitforge/data/local/database.dart';
import 'package:uuid/uuid.dart';

class ProgramRepository {
  final AppDatabase _db;
  const ProgramRepository(this._db);

  Future<void> enrollProgram({
    required String programId,
    required String programName,
  }) async {
    // Deactivate any existing active programs
    await (_db.update(_db.programEnrollments)
          ..where((t) => t.isActive.equals(true)))
        .write(const ProgramEnrollmentsCompanion(isActive: Value(false)));

    // Enroll in new program
    await _db.into(_db.programEnrollments).insert(
          ProgramEnrollmentsCompanion.insert(
            id: const Uuid().v4(),
            programId: programId,
            programName: programName,
            startDate: DateTime.now(),
            currentWeek: const Value(1),
            currentDay: const Value(1),
            isActive: const Value(true),
          ),
        );
  }

  Future<ProgramEnrollment?> getActiveEnrollment() async {
    final query = _db.select(_db.programEnrollments)
      ..where((t) => t.isActive.equals(true))
      ..limit(1);
    
    final results = await query.get();
    return results.isEmpty ? null : results.first;
  }

  Future<void> updateProgress({
    required String enrollmentId,
    required int week,
    required int day,
  }) async {
    await (_db.update(_db.programEnrollments)
          ..where((t) => t.id.equals(enrollmentId)))
        .write(ProgramEnrollmentsCompanion(
      currentWeek: Value(week),
      currentDay: Value(day),
    ));
  }

  Future<void> completeProgram(String enrollmentId) async {
    await (_db.update(_db.programEnrollments)
          ..where((t) => t.id.equals(enrollmentId)))
        .write(ProgramEnrollmentsCompanion(
      isActive: const Value(false),
      completedAt: Value(DateTime.now()),
    ));
  }

  Future<List<ProgramEnrollment>> getEnrollmentHistory() async {
    final query = _db.select(_db.programEnrollments)
      ..orderBy([(t) => OrderingTerm.desc(t.startDate)]);
    return await query.get();
  }
}
