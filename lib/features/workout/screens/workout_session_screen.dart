import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/workout_provider.dart';
import 'package:fitforge/domain/models/workout.dart';
import 'package:uuid/uuid.dart';
import 'package:fitforge/core/services/notification_service.dart';

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
        NotificationService().showRestTimerComplete();
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
  Timer? _elapsedTimer;

  @override
  void initState() {
    super.initState();
    // Rebuild every second to show real-time workout timer
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
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
                    final weight = double.tryParse(_weightController.text) ?? 0.0;
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
      elevation: 0,
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
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _PulsingDot(),
              const SizedBox(width: 6),
              Text(
                '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Text(
                '${state.currentExerciseIndex + 1} / ${widget.exercises.length}',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
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
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        title: Text('End Workout?',
            style: GoogleFonts.rajdhani(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        content: Text('Are you sure you want to end this session early? Your progress so far will be saved.',
            style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Resume', style: GoogleFonts.rajdhani(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleComplete(ref.read(workoutStateProvider(widget.exercises)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('End Workout', style: GoogleFonts.rajdhani(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleComplete(WorkoutSessionState state) async {
    final notifier = ref.read(activeWorkoutProvider.notifier);
    
    await notifier.startWorkout(
      widget.workoutName,
      widget.exercises,
    );

    for (final ex in widget.exercises) {
      final sets = state.setLogs[ex.exerciseId] ?? [];
      if (sets.isNotEmpty) {
        for (final set in sets) {
          notifier.addSet(ex.exerciseId, set.reps, set.weightKg);
        }
      }
    }

    await notifier.completeWorkout();
    
    if (mounted) {
      context.go(AppRoutes.home);
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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise name & stats info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: AppDecorations.sheenCard(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exerciseName,
                        style: GoogleFonts.rajdhani(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.repeat, size: 14, color: AppColors.primary.withValues(alpha: 0.8)),
                          const SizedBox(width: 6),
                          Text(
                            '${exercise.sets} sets × ${exercise.reps} reps',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            'Rest: ${exercise.restSeconds}s',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Set progress bar
                Row(
                  children: List.generate(totalSets, (i) {
                    final isDone = i < completedSets;
                    final isCurrent = i == completedSets;
                    return Expanded(
                      child: Container(
                        height: 8,
                        margin: EdgeInsets.only(right: i < totalSets - 1 ? 6 : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: isCurrent
                              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 1)]
                              : null,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 28),

                // Set logs (completed sets)
                if (completedSets > 0) ...[
                  Text(
                    'Completed Sets',
                    style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  ...(state.setLogs[exercise.exerciseId] ?? [])
                      .map((set) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.darkCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: AppColors.success.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppColors.success, size: 18),
                                const SizedBox(width: 12),
                                Text(
                                  'Set ${set.setNumber}',
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary),
                                ),
                                const Spacer(),
                                Text(
                                  '${set.weightKg}kg × ${set.reps}',
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success),
                                ),
                              ],
                            ),
                          )),
                  const SizedBox(height: 24),
                ],

                // Current set input card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppDecorations.glowCard(AppColors.primary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Set ${completedSets + 1}',
                            style: GoogleFonts.rajdhani(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Target: ${exercise.reps} reps',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
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
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_forward,
                    color: AppColors.textMuted, size: 16),
                const SizedBox(width: 8),
                Text('Next: ',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                Expanded(
                  child: Text(nextExercise!.exerciseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      )),
                ),
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
                child: _PressScale(
                  onTap: onCompleteSet,
                  child: ElevatedButton(
                    onPressed: null, // Custom gesture detector in press scale handles it
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: AppColors.primary,
                      disabledForegroundColor: Colors.white,
                    ),
                    child: Text(
                      'Set Done ✓',
                      style: GoogleFonts.rajdhani(
                          fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: _PressScale(
                        onTap: onSkipSet,
                        child: OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          child: Text('Skip Set',
                              style: GoogleFonts.rajdhani(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: _PressScale(
                        onTap: onSkipExercise,
                        child: OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
                          ),
                          child: Text('Skip Exercise',
                              style: GoogleFonts.rajdhani(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                        ),
                      ),
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

// ─────────────────────────────────────────
// SET INPUT WIDGET
// ─────────────────────────────────────────
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
          label.toUpperCase(),
          style: GoogleFonts.rajdhani(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        const SizedBox(height: 8),
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
            filled: true,
            fillColor: AppColors.darkSurface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12, top: 18),
              child: Text(
                suffix,
                style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// REST TIMER VIEW
// ─────────────────────────────────────────
class _RestTimerView extends StatefulWidget {
  final WorkoutSessionState state;
  final WorkoutStateNotifier notifier;
  final PlannedExercise? nextExercise;

  const _RestTimerView({
    required this.state,
    required this.notifier,
    this.nextExercise,
  });

  @override
  State<_RestTimerView> createState() => _RestTimerViewState();
}

class _RestTimerViewState extends State<_RestTimerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.state.restSecondsTotal > 0
        ? widget.state.restSecondsRemaining / widget.state.restSecondsTotal
        : 0.0;
    final mins = widget.state.restSecondsRemaining ~/ 60;
    final secs = widget.state.restSecondsRemaining % 60;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'REST & RECOVER',
            style: GoogleFonts.rajdhani(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 36),

          // Custom circular painter timer
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(220, 220),
                painter: RestTimerPainter(
                  progress: progress,
                  color: progress > 0.3 ? AppColors.success : AppColors.warning,
                ),
              ),
              ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.02).animate(
                  CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                      style: GoogleFonts.rajdhani(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'seconds left',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Adjust time presets row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AdjustButton(
                label: '-15s',
                onTap: () => widget.notifier.addRestTime(-15),
              ),
              const SizedBox(width: 14),
              _AdjustButton(
                label: '+15s',
                onTap: () => widget.notifier.addRestTime(15),
              ),
              const SizedBox(width: 14),
              _AdjustButton(
                label: '+30s',
                onTap: () => widget.notifier.addRestTime(30),
              ),
            ],
          ),

          const SizedBox(height: 48),

          if (widget.nextExercise != null) ...[
            Text(
              'NEXT EXERCISE',
              style: GoogleFonts.rajdhani(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppColors.textMuted),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                widget.nextExercise!.exerciseName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rajdhani(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],

          SizedBox(
            width: 160,
            height: 46,
            child: _PressScale(
              onTap: widget.notifier.skipRest,
              child: OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
                ),
                child: Text(
                  'Skip Rest',
                  style: GoogleFonts.rajdhani(
                      fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// ADJUST BUTTON
// ─────────────────────────────────────────
class _AdjustButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AdjustButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.rajdhani(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// CUSTOM TIMER PAINTER
// ─────────────────────────────────────────
class RestTimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  RestTimerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 10.0;

    // Track
    final trackPaint = Paint()
      ..color = AppColors.darkSurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    if (progress > 0) {
      // Glow shadow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth + 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      // Active sweep
      final activePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;

      final sweepAngle = 2 * 3.1415926535 * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -3.1415926535 / 2,
        sweepAngle,
        false,
        glowPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -3.1415926535 / 2,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RestTimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

// ─────────────────────────────────────────
// PULSING DOT WIDGET
// ─────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: _ctrl.value * 0.7 + 0.3),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: _ctrl.value * 0.6),
              blurRadius: 6,
              spreadRadius: 2,
            )
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// PRESS SCALE WRAPPER
// ─────────────────────────────────────────
class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PressScale({
    required this.child,
    this.onTap,
  });

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _ctrl.forward() : null,
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

