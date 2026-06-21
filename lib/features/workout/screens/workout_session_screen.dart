import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/domain/models/workout.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// ─────────────────────────────────────────
// STATE
// ─────────────────────────────────────────
class WorkoutSessionState {
  final int currentExerciseIndex;
  final int currentSetIndex;
  final Map<String, List<SetLog>> setLogs; // exerciseId -> sets
  final bool isResting;
  final int restSecondsRemaining;
  final int restSecondsTotal;
  final DateTime startTime;
  final bool isComplete;

  const WorkoutSessionState({
    this.currentExerciseIndex = 0,
    this.currentSetIndex = 0,
    this.setLogs = const {},
    this.isResting = false,
    this.restSecondsRemaining = 0,
    this.restSecondsTotal = 90,
    required this.startTime,
    this.isComplete = false,
  });

  WorkoutSessionState copyWith({
    int? currentExerciseIndex,
    int? currentSetIndex,
    Map<String, List<SetLog>>? setLogs,
    bool? isResting,
    int? restSecondsRemaining,
    int? restSecondsTotal,
    DateTime? startTime,
    bool? isComplete,
  }) {
    return WorkoutSessionState(
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      setLogs: setLogs ?? this.setLogs,
      isResting: isResting ?? this.isResting,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
      restSecondsTotal: restSecondsTotal ?? this.restSecondsTotal,
      startTime: startTime ?? this.startTime,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class WorkoutStateNotifier extends StateNotifier<WorkoutSessionState> {
  final List<PlannedExercise> exercises;
  Timer? _restTimer;

  WorkoutStateNotifier(this.exercises)
      : super(WorkoutSessionState(startTime: DateTime.now()));

  PlannedExercise get currentExercise => exercises[state.currentExerciseIndex];

  void completeSet(int reps, double weightKg) {
    final ex = currentExercise;
    final set = SetLog(
      id: _uuid.v4(),
      setNumber: state.currentSetIndex + 1,
      reps: reps,
      weightKg: weightKg,
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    final existingLogs = Map<String, List<SetLog>>.from(state.setLogs);
    existingLogs[ex.exerciseId] = [
      ...(existingLogs[ex.exerciseId] ?? []),
      set,
    ];

    // Check if all sets done for this exercise
    final setsCompleted = existingLogs[ex.exerciseId]!.length;
    final totalSets = ex.sets;

    if (setsCompleted >= totalSets) {
      // All sets done — move to next exercise
      state = state.copyWith(
        setLogs: existingLogs,
        isResting: false,
      );
      _startRestAndAdvance(ex.restSeconds, advance: true);
    } else {
      // More sets — start rest timer
      state = state.copyWith(
        setLogs: existingLogs,
        currentSetIndex: state.currentSetIndex + 1,
        isResting: true,
        restSecondsRemaining: ex.restSeconds,
        restSecondsTotal: ex.restSeconds,
      );
      _startRestTimer();
    }
  }

  void _startRestAndAdvance(int restSeconds, {required bool advance}) {
    if (advance) {
      final nextIndex = state.currentExerciseIndex + 1;
      if (nextIndex >= exercises.length) {
        // Workout complete
        state = state.copyWith(isComplete: true);
        return;
      }
      state = state.copyWith(
        isResting: true,
        restSecondsRemaining: restSeconds,
        restSecondsTotal: restSeconds,
        currentExerciseIndex: nextIndex,
        currentSetIndex: 0,
      );
    }
    _startRestTimer();
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.restSecondsRemaining <= 1) {
        _restTimer?.cancel();
        HapticFeedback.heavyImpact();
        state = state.copyWith(isResting: false, restSecondsRemaining: 0);
      } else {
        state = state.copyWith(
          restSecondsRemaining: state.restSecondsRemaining - 1,
        );
      }
    });
  }

  void skipRest() {
    _restTimer?.cancel();
    state = state.copyWith(isResting: false, restSecondsRemaining: 0);
  }

  void skipSet() {
    final ex = currentExercise;
    final nextSet = state.currentSetIndex + 1;
    if (nextSet >= ex.sets) {
      skipExercise();
    } else {
      state = state.copyWith(currentSetIndex: nextSet);
    }
  }

  void skipExercise() {
    _restTimer?.cancel();
    final nextIndex = state.currentExerciseIndex + 1;
    if (nextIndex >= exercises.length) {
      state = state.copyWith(isComplete: true);
    } else {
      state = state.copyWith(
        currentExerciseIndex: nextIndex,
        currentSetIndex: 0,
        isResting: false,
      );
    }
  }

  void addRestTime(int seconds) {
    state = state.copyWith(
      restSecondsRemaining:
          (state.restSecondsRemaining + seconds).clamp(5, 600),
    );
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }
}

final workoutStateProvider = StateNotifierProvider.autoDispose
    .family<WorkoutStateNotifier, WorkoutSessionState, List<PlannedExercise>>(
  (ref, exercises) => WorkoutStateNotifier(exercises),
);

// ─────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────
class WorkoutSessionScreen extends ConsumerStatefulWidget {
  final String workoutName;
  final List<PlannedExercise> exercises;
  final String planId;

  const WorkoutSessionScreen({
    super.key,
    required this.workoutName,
    required this.exercises,
    required this.planId,
  });

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  final _repsController = TextEditingController(text: '10');
  final _weightController = TextEditingController(text: '60');

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(
          child: Text(
            'No exercises in this workout',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final state = ref.watch(workoutStateProvider(widget.exercises));
    final notifier = ref.read(workoutStateProvider(widget.exercises).notifier);

    // Watch for completion
    if (state.isComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleComplete(state);
      });
    }

    final ex = state.currentExerciseIndex < widget.exercises.length
        ? widget.exercises[state.currentExerciseIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: _buildAppBar(context, state),
      body: ex == null
          ? const Center(child: Text('Done!'))
          : state.isResting
              ? _RestTimerView(
                  state: state,
                  notifier: notifier,
                  nextExercise:
                      state.currentExerciseIndex < widget.exercises.length
                          ? widget.exercises[state.currentExerciseIndex]
                          : null,
                )
              : _ExerciseView(
                  exercise: ex,
                  state: state,
                  repsController: _repsController,
                  weightController: _weightController,
                  onCompleteSet: () {
                    final reps = int.tryParse(_repsController.text) ?? 10;
                    final weight = double.tryParse(_weightController.text) ?? 0;
                    notifier.completeSet(reps, weight);
                  },
                  onSkipSet: notifier.skipSet,
                  onSkipExercise: notifier.skipExercise,
                  nextExercise:
                      state.currentExerciseIndex + 1 < widget.exercises.length
                          ? widget.exercises[state.currentExerciseIndex + 1]
                          : null,
                ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, WorkoutSessionState state) {
    final elapsed = DateTime.now().difference(state.startTime);
    final mins = elapsed.inMinutes;
    final secs = elapsed.inSeconds % 60;
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
        onPressed: () => _showExitDialog(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.workoutName,
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '${state.currentExerciseIndex + 1} / ${widget.exercises.length}',
              style: GoogleFonts.rajdhani(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('End Workout?',
            style: GoogleFonts.rajdhani(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        content: Text('Your progress will be saved.',
            style: GoogleFonts.inter(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleComplete(ref.read(workoutStateProvider(widget.exercises)));
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }

  void _handleComplete(WorkoutSessionState state) async {
    final notifier = ref.read(workoutSessionNotifierProvider.notifier);
    notifier.startSession(widget.planId, widget.workoutName);

    for (final ex in widget.exercises) {
      final sets = state.setLogs[ex.exerciseId] ?? [];
      if (sets.isNotEmpty) {
        notifier.addExerciseLog(ExerciseLog(
          id: _uuid.v4(),
          exerciseId: ex.exerciseId,
          exerciseName: ex.exerciseName,
          sets: sets,
        ));
      }
    }

    final session = await notifier.completeSession();
    if (mounted) {
      context.go(AppRoutes.workoutSummary, extra: session);
    }
  }
}

// ─────────────────────────────────────────
// EXERCISE VIEW
// ─────────────────────────────────────────
class _ExerciseView extends StatelessWidget {
  final PlannedExercise exercise;
  final WorkoutSessionState state;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback onCompleteSet;
  final VoidCallback onSkipSet;
  final VoidCallback onSkipExercise;
  final PlannedExercise? nextExercise;

  const _ExerciseView({
    required this.exercise,
    required this.state,
    required this.repsController,
    required this.weightController,
    required this.onCompleteSet,
    required this.onSkipSet,
    required this.onSkipExercise,
    this.nextExercise,
  });

  @override
  Widget build(BuildContext context) {
    final completedSets = state.setLogs[exercise.exerciseId]?.length ?? 0;
    final totalSets = exercise.sets;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise name
                Text(
                  exercise.exerciseName,
                  style: GoogleFonts.rajdhani(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercise.sets} sets × ${exercise.reps} reps',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                // Set progress
                Row(
                  children: List.generate(totalSets, (i) {
                    final isDone = i < completedSets;
                    final isCurrent = i == completedSets;
                    return Expanded(
                      child: Container(
                        height: 8,
                        margin:
                            EdgeInsets.only(right: i < totalSets - 1 ? 6 : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isDone
                              ? AppColors.primary
                              : isCurrent
                                  ? AppColors.primary.withValues(alpha: 0.4)
                                  : AppColors.darkSurface,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  'Set ${completedSets + 1} of $totalSets',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 32),

                // Set logs (completed sets)
                if (completedSets > 0) ...[
                  Text(
                    'Completed Sets',
                    style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  ...(state.setLogs[exercise.exerciseId] ?? [])
                      .map((set) => Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.darkCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      AppColors.success.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: AppColors.success, size: 16),
                                const SizedBox(width: 10),
                                Text(
                                  'Set ${set.setNumber}',
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary),
                                ),
                                const Spacer(),
                                Text(
                                  '${set.weightKg}kg × ${set.reps}',
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 14,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          )),
                  const SizedBox(height: 24),
                ],

                // Current set input
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set ${completedSets + 1}',
                        style: GoogleFonts.rajdhani(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _SetInput(
                              controller: repsController,
                              label: 'Reps',
                              suffix: 'reps',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _SetInput(
                              controller: weightController,
                              label: 'Weight',
                              suffix: 'kg',
                              isDecimal: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Next exercise preview
        if (nextExercise != null) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_forward,
                    color: AppColors.textMuted, size: 16),
                const SizedBox(width: 8),
                Text('Next: ',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textMuted)),
                Text(nextExercise!.exerciseName,
                    style: GoogleFonts.rajdhani(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Actions
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onCompleteSet,
                  child: Text(
                    'Set Done ✓',
                    style: GoogleFonts.rajdhani(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSkipSet,
                      child: Text('Skip Set',
                          style: GoogleFonts.rajdhani(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSkipExercise,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textMuted,
                        side: BorderSide(color: AppColors.darkBorder),
                      ),
                      child: Text('Skip Exercise',
                          style: GoogleFonts.rajdhani(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SetInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;
  final bool isDecimal;

  const _SetInput({
    required this.controller,
    required this.label,
    required this.suffix,
    this.isDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle:
                GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// REST TIMER VIEW
// ─────────────────────────────────────────
class _RestTimerView extends StatelessWidget {
  final WorkoutSessionState state;
  final WorkoutStateNotifier notifier;
  final PlannedExercise? nextExercise;

  const _RestTimerView({
    required this.state,
    required this.notifier,
    this.nextExercise,
  });

  @override
  Widget build(BuildContext context) {
    final progress = state.restSecondsTotal > 0
        ? state.restSecondsRemaining / state.restSecondsTotal
        : 0.0;
    final mins = state.restSecondsRemaining ~/ 60;
    final secs = state.restSecondsRemaining % 60;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'REST',
            style: GoogleFonts.rajdhani(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),

          // Circular timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: progress.toDouble(),
                  strokeWidth: 10,
                  backgroundColor: AppColors.darkSurface,
                  color: progress > 0.3 ? AppColors.primary : AppColors.warning,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                    style: GoogleFonts.rajdhani(
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'seconds',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Adjust time buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AdjustButton(
                label: '-15s',
                onTap: () => notifier.addRestTime(-15),
              ),
              const SizedBox(width: 16),
              _AdjustButton(
                label: '+15s',
                onTap: () => notifier.addRestTime(15),
              ),
              const SizedBox(width: 16),
              _AdjustButton(
                label: '+30s',
                onTap: () => notifier.addRestTime(30),
              ),
            ],
          ),

          const SizedBox(height: 32),

          if (nextExercise != null) ...[
            Text(
              'Next up',
              style:
                  GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              nextExercise!.exerciseName,
              style: GoogleFonts.rajdhani(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
          ],

          OutlinedButton(
            onPressed: notifier.skipRest,
            child: Text(
              'Skip Rest',
              style: GoogleFonts.rajdhani(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdjustButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AdjustButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.rajdhani(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
