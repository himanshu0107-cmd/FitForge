import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/database.dart';
import '../../data/repositories/diet_repository.dart';
import '../../domain/models/diet_and_progress.dart';
import '../../core/constants/app_enums.dart';
import 'app_providers.dart';

final dietRepositoryProvider = Provider<DietRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DietRepository(db);
});

final dailyFoodLogsProvider = FutureProvider.family<List<FoodLog>, DateTime>((ref, date) async {
  final repository = ref.watch(dietRepositoryProvider);
  return repository.getFoodLogsForDate(date);
});

final dailyNutritionProvider = FutureProvider.family<Map<String, dynamic>, DateTime>((ref, date) async {
  final repository = ref.watch(dietRepositoryProvider);
  return repository.getDailyNutrition(date);
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class DietNotifier extends StateNotifier<AsyncValue<void>> {
  final DietRepository _repository;
  final Ref _ref;
  final _uuid = const Uuid();

  DietNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> logFood({
    required String foodName,
    required double grams,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required MealType mealType,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final food = FoodLog(
        id: _uuid.v4(),
        foodName: foodName,
        grams: grams,
        calories: calories,
        proteinGrams: protein,
        carbGrams: carbs,
        fatGrams: fat,
        mealType: mealType,
        loggedAt: DateTime.now(),
      );

      await _repository.logFood(food);
      _ref.invalidate(dailyFoodLogsProvider);
      _ref.invalidate(dailyNutritionProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteFood(String foodId) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.deleteFoodLog(foodId);
      _ref.invalidate(dailyFoodLogsProvider);
      _ref.invalidate(dailyNutritionProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dietNotifierProvider = StateNotifierProvider<DietNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(dietRepositoryProvider);
  return DietNotifier(repository, ref);
});
