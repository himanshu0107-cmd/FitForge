import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ─────────────────────────────────────────
// TABLE DEFINITIONS
// ─────────────────────────────────────────

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  RealColumn get weightKg => real()();
  RealColumn get heightCm => real()();
  IntColumn get gender => integer()(); // Gender index
  IntColumn get goal => integer()(); // FitnessGoal index
  IntColumn get sportType => integer()(); // SportType index
  IntColumn get calorieGoal => integer()();
  IntColumn get proteinGoal => integer()();
  IntColumn get carbGoal => integer()();
  IntColumn get fatGoal => integer()();
  TextColumn get workoutReminderTime => text().nullable()();
  BoolColumn get waterReminderEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ExercisesTable extends Table {
  @override
  String get tableName => 'exercises';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get primaryMuscle => integer()(); // MuscleGroup index
  TextColumn get secondaryMuscles => text()(); // JSON array
  IntColumn get equipment => integer()(); // Equipment index
  TextColumn get videoUrl => text().nullable()();
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get defaultSets => integer().withDefault(const Constant(3))();
  IntColumn get defaultReps => integer().withDefault(const Constant(10))();
  IntColumn get defaultRestSeconds => integer().withDefault(const Constant(90))();
  TextColumn get instructions => text()(); // JSON array
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get workoutPlanId => text()();
  TextColumn get workoutName => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get exerciseLogs => text()(); // JSON of ExerciseLog list
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PersonalRecords extends Table {
  TextColumn get id => text()();
  TextColumn get exerciseId => text()();
  TextColumn get exerciseName => text()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  DateTimeColumn get achievedAt => dateTime()();
  TextColumn get sessionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class FoodLogs extends Table {
  TextColumn get id => text()();
  TextColumn get foodName => text()();
  RealColumn get grams => real()();
  IntColumn get calories => integer()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbGrams => real()();
  RealColumn get fatGrams => real()();
  IntColumn get mealType => integer()(); // MealType index
  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class WeightLogs extends Table {
  TextColumn get id => text()();
  RealColumn get weightKg => real()();
  DateTimeColumn get loggedAt => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutStreaks extends Table {
  TextColumn get id => text()();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastWorkoutDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────────────────────
// DATABASE
// ─────────────────────────────────────────

@DriftDatabase(
  tables: [
    UserProfiles,
    ExercisesTable,
    WorkoutSessions,
    PersonalRecords,
    FoodLogs,
    WeightLogs,
    WorkoutStreaks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations
        },
      );

  static DatabaseConnection _openConnection() {
    return DatabaseConnection(
      driftDatabase(name: 'fitforge_db'),
    );
  }
}
