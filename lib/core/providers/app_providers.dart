import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/data/local/database.dart' as db;
import 'package:drift/drift.dart' hide Column;
import 'package:fitforge/domain/models/user_profile.dart';
import 'package:fitforge/domain/models/exercise.dart';
import 'package:fitforge/domain/models/workout.dart';
import 'package:fitforge/domain/models/diet_and_progress.dart';
import 'package:fitforge/core/constants/app_enums.dart';
import 'package:uuid/uuid.dart';

// ─────────────────────────────────────────
// CORE PROVIDERS
// ─────────────────────────────────────────

final _uuid = const Uuid();

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main with override');
});

final appDatabaseProvider = Provider<db.AppDatabase>((ref) {
  final database = db.AppDatabase();
  ref.onDispose(database.close);
  return database;
});

// ─────────────────────────────────────────
// USER PROFILE
// ─────────────────────────────────────────

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final db.AppDatabase _db;
  final SharedPreferences _prefs;

  UserProfileNotifier(this._db, this._prefs) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await _db.select(_db.userProfiles).get();
      if (rows.isEmpty) {
        state = const AsyncValue.data(null);
        return;
      }
      final row = rows.first;
      state = AsyncValue.data(_rowToProfile(row));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _db.into(_db.userProfiles).insertOnConflictUpdate(
            db.UserProfilesCompanion.insert(
              id: profile.id,
              name: profile.name,
              age: profile.age,
              weightKg: profile.weightKg,
              heightCm: profile.heightCm,
              gender: profile.gender.index,
              goal: profile.goal.index,
              sportType: profile.sportType.index,
              calorieGoal: profile.calorieGoal,
              proteinGoal: profile.proteinGoal,
              carbGoal: profile.carbGoal,
              fatGoal: profile.fatGoal,
              createdAt: profile.createdAt,
            ),
          );
      await _prefs.setBool(AppConstants.kOnboardingComplete, true);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  UserProfile _rowToProfile(db.UserProfile row) => UserProfile(
        id: row.id,
        name: row.name,
        age: row.age,
        weightKg: row.weightKg,
        heightCm: row.heightCm,
        gender: Gender.values[row.gender],
        goal: FitnessGoal.values[row.goal],
        sportType: SportType.values[row.sportType],
        calorieGoal: row.calorieGoal,
        proteinGoal: row.proteinGoal,
        carbGoal: row.carbGoal,
        fatGoal: row.fatGoal,
        notificationsEnabled: row.notificationsEnabled,
        waterReminderEnabled: row.waterReminderEnabled,
        workoutReminderTime: row.workoutReminderTime,
        createdAt: row.createdAt,
      );
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserProfileNotifier(
    ref.watch(appDatabaseProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

final isOnboardingCompleteProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(AppConstants.kOnboardingComplete) ?? false;
});

// ─────────────────────────────────────────
// EXERCISES
// ─────────────────────────────────────────

final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final database = ref.watch(appDatabaseProvider);

  // Load from DB first
  final dbRows = await database.select(database.exercisesTable).get();
  if (dbRows.isNotEmpty) {
    return dbRows.map(_exerciseRowToModel).toList();
  }

  // Seed from assets
  final json = await rootBundle.loadString(AppConstants.exercisesAsset);
  final list = jsonDecode(json) as List<dynamic>;
  final exercises = list
      .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
      .toList();

  for (final ex in exercises) {
    await database.into(database.exercisesTable).insertOnConflictUpdate(
          db.ExercisesTableCompanion.insert(
            id: ex.id,
            name: ex.name,
            description: ex.description,
            primaryMuscle: ex.primaryMuscle.index,
            secondaryMuscles:
                jsonEncode(ex.secondaryMuscles.map((m) => m.name).toList()),
            equipment: ex.equipment.index,
            instructions: jsonEncode(ex.instructions),
          ),
        );
  }

  return exercises;
});

Exercise _exerciseRowToModel(db.ExercisesTableData row) {
  final secondaryList =
      (jsonDecode(row.secondaryMuscles) as List<dynamic>).map((m) {
    return MuscleGroup.values.firstWhere(
      (mg) => mg.name == m,
      orElse: () => MuscleGroup.fullBody,
    );
  }).toList();

  final instructionList =
      (jsonDecode(row.instructions) as List<dynamic>).map((i) => i as String).toList();

  return Exercise(
    id: row.id,
    name: row.name,
    description: row.description,
    primaryMuscle: MuscleGroup.values[row.primaryMuscle],
    secondaryMuscles: secondaryList,
    equipment: Equipment.values[row.equipment],
    videoUrl: row.videoUrl,
    thumbnailUrl: row.thumbnailUrl,
    defaultSets: row.defaultSets,
    defaultReps: row.defaultReps,
    defaultRestSeconds: row.defaultRestSeconds,
    instructions: instructionList,
    isCustom: row.isCustom,
  );
}

// ─────────────────────────────────────────
// WORKOUT SESSION
// ─────────────────────────────────────────

class WorkoutSessionNotifier extends StateNotifier<WorkoutSession?> {
  final db.AppDatabase _db;

  WorkoutSessionNotifier(this._db) : super(null);

  void startSession(String planId, String workoutName) {
    state = WorkoutSession(
      id: _uuid.v4(),
      workoutPlanId: planId,
      workoutName: workoutName,
      startTime: DateTime.now(),
    );
  }

  void addExerciseLog(ExerciseLog log) {
    if (state == null) return;
    final existing = state!.exerciseLogs;
    final index = existing.indexWhere((e) => e.exerciseId == log.exerciseId);
    List<ExerciseLog> updated;
    if (index >= 0) {
      updated = [...existing];
      updated[index] = log;
    } else {
      updated = [...existing, log];
    }
    state = state!.copyWith(exerciseLogs: updated);
  }

  Future<WorkoutSession?> completeSession() async {
    if (state == null) return null;
    final completed = state!.copyWith(
      endTime: DateTime.now(),
      isCompleted: true,
    );

    await _db.into(_db.workoutSessions).insertOnConflictUpdate(
          db.WorkoutSessionsCompanion.insert(
            id: completed.id,
            workoutPlanId: completed.workoutPlanId,
            workoutName: completed.workoutName,
            startTime: completed.startTime,
            exerciseLogs: jsonEncode(
              completed.exerciseLogs.map((l) => l.toJson()).toList(),
            ),
            isCompleted: const Value(true),
          ),
        );

    state = null;
    return completed;
  }

  void cancelSession() => state = null;
}

final workoutSessionNotifierProvider =
    StateNotifierProvider<WorkoutSessionNotifier, WorkoutSession?>((ref) {
  return WorkoutSessionNotifier(ref.watch(appDatabaseProvider));
});

// ─────────────────────────────────────────
// FOOD LOG
// ─────────────────────────────────────────

class FoodLogNotifier extends StateNotifier<AsyncValue<List<FoodEntry>>> {
  final db.AppDatabase _db;

  FoodLogNotifier(this._db) : super(const AsyncValue.loading()) {
    _loadToday();
  }

  Future<void> _loadToday() async {
    try {
      final today = DateTime.now();
      final start = DateTime(today.year, today.month, today.day);
      final end = start.add(const Duration(days: 1));

      final rows = await (_db.select(_db.foodLogs)
            ..where((t) => t.loggedAt.isBetweenValues(start, end)))
          .get();

      state = AsyncValue.data(rows.map(_rowToEntry).toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  FoodEntry _rowToEntry(db.FoodLog row) => FoodEntry(
        id: row.id,
        foodName: row.foodName,
        grams: row.grams,
        calories: row.calories,
        proteinGrams: row.proteinGrams,
        carbGrams: row.carbGrams,
        fatGrams: row.fatGrams,
        mealType: MealType.values[row.mealType],
        loggedAt: row.loggedAt,
      );

  Future<void> logFood(FoodEntry entry) async {
    await _db.into(_db.foodLogs).insert(db.FoodLogsCompanion.insert(
          id: entry.id,
          foodName: entry.foodName,
          grams: entry.grams,
          calories: entry.calories,
          proteinGrams: entry.proteinGrams,
          carbGrams: entry.carbGrams,
          fatGrams: entry.fatGrams,
          mealType: entry.mealType.index,
          loggedAt: entry.loggedAt,
        ));
    _loadToday();
  }

  Future<void> deleteEntry(String id) async {
    await (_db.delete(_db.foodLogs)..where((t) => t.id.equals(id))).go();
    _loadToday();
  }
}

final foodLogProvider =
    StateNotifierProvider<FoodLogNotifier, AsyncValue<List<FoodEntry>>>((ref) {
  return FoodLogNotifier(ref.watch(appDatabaseProvider));
});

final todayCaloriesProvider = Provider<int>((ref) {
  final foodLog = ref.watch(foodLogProvider);
  return foodLog.maybeWhen(
    data: (entries) => entries.fold<int>(0, (sum, e) => sum + e.calories),
    orElse: () => 0,
  );
});

// ─────────────────────────────────────────
// WEIGHT LOG
// ─────────────────────────────────────────

class WeightLogNotifier extends StateNotifier<AsyncValue<List<WeightLog>>> {
  final db.AppDatabase _db;

  WeightLogNotifier(this._db) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final rows = await (_db.select(_db.weightLogs)
            ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
            ..limit(90))
          .get();
      state = AsyncValue.data(rows.map(_rowToLog).toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  WeightLog _rowToLog(db.WeightLog row) => WeightLog(
        id: row.id,
        weightKg: row.weightKg,
        loggedAt: row.loggedAt,
        notes: row.notes,
      );

  Future<void> addEntry(double weightKg) async {
    await _db.into(_db.weightLogs).insert(db.WeightLogsCompanion.insert(
          id: _uuid.v4(),
          weightKg: weightKg,
          loggedAt: DateTime.now(),
        ));
    load();
  }
}

final weightLogProvider =
    StateNotifierProvider<WeightLogNotifier, AsyncValue<List<WeightLog>>>((ref) {
  return WeightLogNotifier(ref.watch(appDatabaseProvider));
});

// ─────────────────────────────────────────
// PERSONAL RECORDS
// ─────────────────────────────────────────

final personalRecordsProvider =
    FutureProvider<List<PersonalRecord>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final rows = await (db.select(db.personalRecords)
        ..orderBy([(t) => OrderingTerm.desc(t.achievedAt)]))
      .get();

  return rows
      .map((r) => PersonalRecord(
            id: r.id,
            exerciseId: r.exerciseId,
            exerciseName: r.exerciseName,
            weightKg: r.weightKg,
            reps: r.reps,
            achievedAt: r.achievedAt,
            sessionId: r.sessionId,
          ))
      .toList();
});

// ─────────────────────────────────────────
// STREAK
// ─────────────────────────────────────────

final streakProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final rows = await db.select(db.workoutStreaks).get();
  if (rows.isEmpty) return 0;
  return rows.first.currentStreak;
});

// ─────────────────────────────────────────
// TRAINING PROGRAMS
// ─────────────────────────────────────────

final programsProvider = FutureProvider<List<TrainingProgram>>((ref) async {
  final assets = [
    AppConstants.pplProgramAsset,
    AppConstants.fullBodyProgramAsset,
    AppConstants.footballProgramAsset,
    AppConstants.boxingProgramAsset,
    AppConstants.runningProgramAsset,
  ];

  final programs = <TrainingProgram>[];
  for (final asset in assets) {
    final json = await rootBundle.loadString(asset);
    programs.add(TrainingProgram.fromJson(
        jsonDecode(json) as Map<String, dynamic>));
  }
  return programs;
});

// ─────────────────────────────────────────
// MEAL PLANS
// ─────────────────────────────────────────

final mealPlansProvider = FutureProvider<List<MealPlan>>((ref) async {
  final assets = [
    AppConstants.bulkingMealAsset,
    AppConstants.cuttingMealAsset,
    AppConstants.maintenanceMealAsset,
  ];

  final plans = <MealPlan>[];
  for (final asset in assets) {
    final json = await rootBundle.loadString(asset);
    plans.add(MealPlan.fromJson(jsonDecode(json) as Map<String, dynamic>));
  }
  return plans;
});

// ─────────────────────────────────────────
// THEME
// ─────────────────────────────────────────

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeNotifier(this._prefs)
      : super(
          _prefs.getString(AppConstants.kThemeMode) == 'light'
              ? ThemeMode.light
              : ThemeMode.dark,
        );

  void toggle() {
    final newMode =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    _prefs.setString(
        AppConstants.kThemeMode, newMode == ThemeMode.dark ? 'dark' : 'light');
  }
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(sharedPreferencesProvider));
});
