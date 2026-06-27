import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart';
import '../../data/repositories/progress_repository.dart';
import '../../domain/models/diet_and_progress.dart';
import 'app_providers.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProgressRepository(db);
});

final weightHistoryProvider = FutureProvider<List<WeightLog>>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getWeightHistory(limit: 30);
});

final latestWeightProvider = FutureProvider<WeightLog?>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getLatestWeight();
});

class ProgressNotifier extends StateNotifier<AsyncValue<void>> {
  final ProgressRepository _repository;
  final Ref _ref;

  ProgressNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> logWeight(double weightKg, {String? notes}) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.logWeight(weightKg, notes: notes);
      _ref.invalidate(weightHistoryProvider);
      _ref.invalidate(latestWeightProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteWeight(String id) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.deleteWeightLog(id);
      _ref.invalidate(weightHistoryProvider);
      _ref.invalidate(latestWeightProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final progressNotifierProvider = StateNotifierProvider<ProgressNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return ProgressNotifier(repository, ref);
});
