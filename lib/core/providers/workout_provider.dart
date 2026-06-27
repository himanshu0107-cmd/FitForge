import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/database.dart';
import '../../data/repositories/workout_repository.dart';
import '../../domain/models/workout.dart';
import 'app_providers.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return WorkoutRepository(db);
});

final activeWorkoutProvider = StateNotifierProvider<ActiveWorkoutNotifier, WorkoutSession?>((ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  return ActiveWorkoutNotifier(repository);
});

final workoutHistoryProvider = FutureProvider<List<WorkoutSession>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getRecentWorkouts(limit: 20);
});

final workoutStreakProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getWorkoutStreak();
});

class ActiveWorkoutNotifier extends StateNotifier<WorkoutSession?> {
  final WorkoutRepository _repository;
  final _uuid = const Uuid();

  ActiveWorkoutNotifier(this._repository) : super(null);

  Future<void> startWorkout(String workoutName, List<PlannedExercise> exercises) async {
    final sessionId = await _repository.startWorkout('custom', workoutName);
    
    state = WorkoutSession(
      id: sessionId,
      workoutPlanId: 'custom',
      workoutName: workoutName,
      startTime: DateTime.now(),
      exerciseLogs: exercises.map((e) => ExerciseLog(
        id: _uuid.v4(),
        exerciseId: e.exerciseId,
        exerciseName: e.exerciseName,
        sets: [],
      )).toList(),
    );
  }

  void addSet(String exerciseId, int reps, double weightKg) {
    if (state == null) return;

    final updatedLogs = state!.exerciseLogs.map((log) {
      if (log.exerciseId == exerciseId) {
        final newSet = SetLog(
          id: _uuid.v4(),
          setNumber: log.sets.length + 1,
          reps: reps,
          weightKg: weightKg,
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        return log.copyWith(sets: [...log.sets, newSet]);
      }
      return log;
    }).toList();

    state = state!.copyWith(exerciseLogs: updatedLogs);
  }

  void removeLastSet(String exerciseId) {
    if (state == null) return;

    final updatedLogs = state!.exerciseLogs.map((log) {
      if (log.exerciseId == exerciseId && log.sets.isNotEmpty) {
        return log.copyWith(sets: log.sets.sublist(0, log.sets.length - 1));
      }
      return log;
    }).toList();

    state = state!.copyWith(exerciseLogs: updatedLogs);
  }

  void skipExercise(String exerciseId) {
    if (state == null) return;

    final updatedLogs = state!.exerciseLogs.map((log) {
      if (log.exerciseId == exerciseId) {
        return log.copyWith(isSkipped: true);
      }
      return log;
    }).toList();

    state = state!.copyWith(exerciseLogs: updatedLogs);
  }

  Future<void> completeWorkout({String? notes}) async {
    if (state == null) return;

    final completedSession = state!.copyWith(
      endTime: DateTime.now(),
      isCompleted: true,
      notes: notes,
    );

    await _repository.completeWorkout(
      completedSession.id,
      completedSession.exerciseLogs,
      notes: notes,
    );

    for (final log in completedSession.exerciseLogs) {
      if (log.sets.isNotEmpty && log.bestSet != null) {
        final bestSet = log.bestSet!;
        final isPR = await _repository.checkIfPersonalRecord(
          log.exerciseId,
          bestSet.weightKg,
          bestSet.reps,
        );

        if (isPR) {
          await _repository.savePersonalRecord(PersonalRecord(
            id: _uuid.v4(),
            exerciseId: log.exerciseId,
            exerciseName: log.exerciseName,
            weightKg: bestSet.weightKg,
            reps: bestSet.reps,
            achievedAt: DateTime.now(),
            sessionId: completedSession.id,
          ));
        }
      }
    }

    state = null;
  }

  void cancelWorkout() {
    state = null;
  }
}
