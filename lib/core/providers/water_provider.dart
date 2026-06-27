import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitforge/core/providers/database_provider.dart';
import 'package:fitforge/data/repositories/water_repository.dart';

final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return WaterRepository(db);
});

final todayWaterIntakeProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(waterRepositoryProvider);
  return Stream.periodic(const Duration(seconds: 1), (_) => repo.getTodayWaterIntake())
      .asyncMap((future) => future);
});

class WaterNotifier extends StateNotifier<AsyncValue<void>> {
  final WaterRepository _repository;

  WaterNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> logWater(int amountMl) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.logWater(amountMl));
  }
}

final waterNotifierProvider =
    StateNotifierProvider<WaterNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(waterRepositoryProvider);
  return WaterNotifier(repo);
});
