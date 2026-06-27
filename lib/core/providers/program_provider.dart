import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitforge/core/providers/database_provider.dart';
import 'package:fitforge/data/local/database.dart';
import 'package:fitforge/data/repositories/program_repository.dart';

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProgramRepository(db);
});

final activeEnrollmentProvider = FutureProvider<ProgramEnrollment?>((ref) {
  final repo = ref.watch(programRepositoryProvider);
  return repo.getActiveEnrollment();
});

class ProgramNotifier extends StateNotifier<AsyncValue<void>> {
  final ProgramRepository _repository;
  final Ref _ref;

  ProgramNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> enrollProgram({
    required String programId,
    required String programName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.enrollProgram(
        programId: programId,
        programName: programName,
      );
      _ref.invalidate(activeEnrollmentProvider);
    });
  }

  Future<void> updateProgress({
    required String enrollmentId,
    required int week,
    required int day,
  }) async {
    state = await AsyncValue.guard(() async {
      await _repository.updateProgress(
        enrollmentId: enrollmentId,
        week: week,
        day: day,
      );
      _ref.invalidate(activeEnrollmentProvider);
    });
  }

  Future<void> completeProgram(String enrollmentId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.completeProgram(enrollmentId);
      _ref.invalidate(activeEnrollmentProvider);
    });
  }
}

final programNotifierProvider =
    StateNotifierProvider<ProgramNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(programRepositoryProvider);
  return ProgramNotifier(repo, ref);
});
