import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../local/database.dart';
import '../../domain/models/workout.dart';

class WorkoutRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  WorkoutRepository(this._db);

  Future<String> startWorkout(String workoutPlanId, String workoutName) async {
    final id = _uuid.v4();
    final session = WorkoutSessionsCompanion(
      id: Value(id),
      workoutPlanId: Value(workoutPlanId),
      workoutName: Value(workoutName),
      startTime: Value(DateTime.now()),
      exerciseLogs: const Value('[]'),
      isCompleted: const Value(false),
    );

    await _db.into(_db.workoutSessions).insert(session);
    return id;
  }

  Future<void> updateWorkoutSession(WorkoutSession session) async {
    await (_db.update(_db.workoutSessions)..where((t) => t.id.equals(session.id))).write(
      WorkoutSessionsCompanion(
        exerciseLogs: Value(jsonEncode(session.exerciseLogs.map((e) => e.toJson()).toList())),
        endTime: Value(session.endTime),
        isCompleted: Value(session.isCompleted),
        notes: Value(session.notes),
      ),
    );
  }

  Future<void> completeWorkout(String sessionId, List<ExerciseLog> logs, {String? notes}) async {
    await (_db.update(_db.workoutSessions)..where((t) => t.id.equals(sessionId))).write(
      WorkoutSessionsCompanion(
        endTime: Value(DateTime.now()),
        exerciseLogs: Value(jsonEncode(logs.map((e) => e.toJson()).toList())),
        isCompleted: const Value(true),
        notes: Value(notes),
      ),
    );

    await _updateWorkoutStreak();
  }

  Future<WorkoutSession?> getWorkoutSession(String sessionId) async {
    final query = _db.select(_db.workoutSessions)..where((t) => t.id.equals(sessionId));
    final result = await query.getSingleOrNull();
    return result != null ? _workoutSessionFromDb(result) : null;
  }

  Future<List<WorkoutSession>> getRecentWorkouts({int limit = 10}) async {
    final query = _db.select(_db.workoutSessions)
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
      ..limit(limit);

    final results = await query.get();
    return results.map(_workoutSessionFromDb).toList();
  }

  Future<void> savePersonalRecord(PersonalRecord pr) async {
    await _db.into(_db.personalRecords).insert(
          PersonalRecordsCompanion(
            id: Value(pr.id),
            exerciseId: Value(pr.exerciseId),
            exerciseName: Value(pr.exerciseName),
            weightKg: Value(pr.weightKg),
            reps: Value(pr.reps),
            achievedAt: Value(pr.achievedAt),
            sessionId: Value(pr.sessionId),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<PersonalRecord?> getPersonalRecord(String exerciseId) async {
    final query = _db.select(_db.personalRecords)
      ..where((t) => t.exerciseId.equals(exerciseId))
      ..orderBy([(t) => OrderingTerm.desc(t.weightKg)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result != null ? _personalRecordFromDb(result) : null;
  }

  Future<bool> checkIfPersonalRecord(String exerciseId, double weightKg, int reps) async {
    final currentPR = await getPersonalRecord(exerciseId);
    if (currentPR == null) return true;
    return weightKg * (1 + reps / 30.0) > currentPR.oneRepMax;
  }

  Future<void> _updateWorkoutStreak() async {
    final streakQuery = _db.select(_db.workoutStreaks)..limit(1);
    final existingStreak = await streakQuery.getSingleOrNull();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (existingStreak == null) {
      await _db.into(_db.workoutStreaks).insert(
            WorkoutStreaksCompanion(
              id: Value(_uuid.v4()),
              currentStreak: const Value(1),
              longestStreak: const Value(1),
              lastWorkoutDate: Value(today),
            ),
          );
      return;
    }

    final lastWorkout = existingStreak.lastWorkoutDate;
    if (lastWorkout == null) return;

    final lastDay = DateTime(lastWorkout.year, lastWorkout.month, lastWorkout.day);
    final daysDiff = today.difference(lastDay).inDays;

    if (daysDiff == 0) return;

    final newStreak = daysDiff == 1 ? existingStreak.currentStreak + 1 : 1;
    final newLongest = newStreak > existingStreak.longestStreak ? newStreak : existingStreak.longestStreak;

    await (_db.update(_db.workoutStreaks)..where((t) => t.id.equals(existingStreak.id))).write(
      WorkoutStreaksCompanion(
        currentStreak: Value(newStreak),
        longestStreak: Value(newLongest),
        lastWorkoutDate: Value(today),
      ),
    );
  }

  Future<Map<String, int>> getWorkoutStreak() async {
    final query = _db.select(_db.workoutStreaks)..limit(1);
    final result = await query.getSingleOrNull();
    return result == null ? {'current': 0, 'longest': 0} : {'current': result.currentStreak, 'longest': result.longestStreak};
  }

  WorkoutSession _workoutSessionFromDb(WorkoutSession row) {
    final logs = (jsonDecode(row.exerciseLogs) as List).map((l) => ExerciseLog.fromJson(l)).toList();
    return WorkoutSession(
      id: row.id,
      workoutPlanId: row.workoutPlanId,
      workoutName: row.workoutName,
      startTime: row.startTime,
      endTime: row.endTime,
      exerciseLogs: logs,
      isCompleted: row.isCompleted,
      notes: row.notes,
    );
  }

  PersonalRecord _personalRecordFromDb(PersonalRecord row) {
    return PersonalRecord(
      id: row.id,
      exerciseId: row.exerciseId,
      exerciseName: row.exerciseName,
      weightKg: row.weightKg,
      reps: row.reps,
      achievedAt: row.achievedAt,
      sessionId: row.sessionId,
    );
  }
}
