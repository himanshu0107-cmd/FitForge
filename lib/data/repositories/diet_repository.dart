import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../local/database.dart';
import '../../domain/models/diet_and_progress.dart';

class DietRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  DietRepository(this._db);

  Future<void> logFood(FoodLog food) async {
    await _db.into(_db.foodLogs).insert(
          FoodLogsCompanion(
            id: Value(food.id),
            foodName: Value(food.foodName),
            grams: Value(food.grams),
            calories: Value(food.calories),
            proteinGrams: Value(food.proteinGrams),
            carbGrams: Value(food.carbGrams),
            fatGrams: Value(food.fatGrams),
            mealType: Value(food.mealType.index),
            loggedAt: Value(food.loggedAt),
          ),
        );
  }

  Future<List<FoodLog>> getFoodLogsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = _db.select(_db.foodLogs)
      ..where((t) => t.loggedAt.isBiggerOrEqualValue(startOfDay) & t.loggedAt.isSmallerThanValue(endOfDay))
      ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]);

    final results = await query.get();
    return results.map(_foodLogFromDb).toList();
  }

  Future<void> deleteFoodLog(String id) async {
    await (_db.delete(_db.foodLogs)..where((t) => t.id.equals(id))).go();
  }

  Future<Map<String, dynamic>> getDailyNutrition(DateTime date) async {
    final logs = await getFoodLogsForDate(date);

    return {
      'calories': logs.fold(0, (sum, log) => sum + log.calories),
      'protein': logs.fold(0.0, (sum, log) => sum + log.proteinGrams),
      'carbs': logs.fold(0.0, (sum, log) => sum + log.carbGrams),
      'fat': logs.fold(0.0, (sum, log) => sum + log.fatGrams),
    };
  }

  FoodLog _foodLogFromDb(FoodLog row) {
    return FoodLog(
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
  }
}
