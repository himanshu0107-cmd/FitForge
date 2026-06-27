import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

enum IntervalPhase { prepare, work, rest, complete }

class IntervalTimerState {
  final int workSeconds;
  final int restSeconds;
  final int rounds;
  final int currentRound;
  final IntervalPhase phase;
  final int secondsRemaining;
  final bool isRunning;

  const IntervalTimerState({
    this.workSeconds = 40,
    this.restSeconds = 20,
    this.rounds = 8,
    this.currentRound = 0,
    this.phase = IntervalPhase.prepare,
    this.secondsRemaining = 10,
    this.isRunning = false,
  });

  IntervalTimerState copyWith({
    int? workSeconds,
    int? restSeconds,
    int? rounds,
    int? currentRound,
    IntervalPhase? phase,
    int? secondsRemaining,
    bool? isRunning,
  }) {
    return IntervalTimerState(
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
      phase: phase ?? this.phase,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  int get totalSeconds {
    return 10 + (workSeconds + restSeconds) * rounds;
  }

  int get elapsedSeconds {
    int elapsed = 0;
    if (phase == IntervalPhase.prepare) {
      elapsed = 10 - secondsRemaining;
    } else if (phase == IntervalPhase.complete) {
      elapsed = totalSeconds;
    } else {
      elapsed = 10 + (currentRound * (workSeconds + restSeconds));
      if (phase == IntervalPhase.work) {
        elapsed += workSeconds - secondsRemaining;
      } else {
        elapsed += workSeconds + restSeconds - secondsRemaining;
      }
    }
    return elapsed;
  }

  double get progress {
    return totalSeconds > 0 ? elapsedSeconds / totalSeconds : 0;
  }
}

class IntervalTimerNotifier extends StateNotifier<IntervalTimerState> {
  Timer? _timer;

  IntervalTimerNotifier() : super(const IntervalTimerState());

  void configure({int? work, int? rest, int? rounds}) {
    state = IntervalTimerState(
      workSeconds: work ?? state.workSeconds,
      restSeconds: rest ?? state.restSeconds,
      rounds: rounds ?? state.rounds,
      secondsRemaining: 10,
      phase: IntervalPhase.prepare,
    );
  }

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _startTimer();
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = IntervalTimerState(
      workSeconds: state.workSeconds,
      restSeconds: state.restSeconds,
      rounds: state.rounds,
      secondsRemaining: 10,
      phase: IntervalPhase.prepare,
      isRunning: false,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsRemaining <= 1) {
        _advancePhase();
      } else {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      }

      if (state.secondsRemaining <= 3 && state.secondsRemaining > 0) {
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _advancePhase() {
    switch (state.phase) {
      case IntervalPhase.prepare:
        HapticFeedback.heavyImpact();
        state = state.copyWith(
          phase: IntervalPhase.work,
          secondsRemaining: state.workSeconds,
          currentRound: 1,
        );
        break;

      case IntervalPhase.work:
        HapticFeedback.mediumImpact();
        if (state.currentRound >= state.rounds) {
          _timer?.cancel();
          state = state.copyWith(
            phase: IntervalPhase.complete,
            secondsRemaining: 0,
            isRunning: false,
          );
        } else {
          state = state.copyWith(
            phase: IntervalPhase.rest,
            secondsRemaining: state.restSeconds,
          );
        }
        break;

      case IntervalPhase.rest:
        HapticFeedback.heavyImpact();
        state = state.copyWith(
          phase: IntervalPhase.work,
          secondsRemaining: state.workSeconds,
          currentRound: state.currentRound + 1,
        );
        break;

      case IntervalPhase.complete:
        break;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final intervalTimerProvider = StateNotifierProvider<IntervalTimerNotifier, IntervalTimerState>((ref) {
  return IntervalTimerNotifier();
});

class IntervalTimerWidget extends ConsumerWidget {
  const IntervalTimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(intervalTimerProvider);
    final notifier = ref.read(intervalTimerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Text(
          'HIIT Timer',
          style: GoogleFonts.rajdhani(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
      ),
      body: state.phase == IntervalPhase.prepare && !state.isRunning
          ? _ConfigView(state: state, notifier: notifier)
          : _TimerView(state: state, notifier: notifier),
    );
  }
}

class _ConfigView extends StatelessWidget {
  final IntervalTimerState state;
  final IntervalTimerNotifier notifier;

  const _ConfigView({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Configure Intervals',
            style: GoogleFonts.rajdhani(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 40),
          _ConfigItem(
            label: 'Work',
            value: state.workSeconds,
            unit: 'seconds',
            onIncrease: () => notifier.configure(work: (state.workSeconds + 5).clamp(5, 180)),
            onDecrease: () => notifier.configure(work: (state.workSeconds - 5).clamp(5, 180)),
          ),
          const SizedBox(height: 20),
          _ConfigItem(
            label: 'Rest',
            value: state.restSeconds,
            unit: 'seconds',
            onIncrease: () => notifier.configure(rest: (state.restSeconds + 5).clamp(5, 120)),
            onDecrease: () => notifier.configure(rest: (state.restSeconds - 5).clamp(5, 120)),
          ),
          const SizedBox(height: 20),
          _ConfigItem(
            label: 'Rounds',
            value: state.rounds,
            unit: 'rounds',
            onIncrease: () => notifier.configure(rounds: (state.rounds + 1).clamp(1, 20)),
            onDecrease: () => notifier.configure(rounds: (state.rounds - 1).clamp(1, 20)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.card,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Time', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                Text(
                  _formatTime(state.totalSeconds),
                  style: GoogleFonts.rajdhani(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: notifier.start,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text('Start Timer', style: GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins}:${secs.toString().padLeft(2, '0')}';
  }
}

class _ConfigItem extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _ConfigItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(unit, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 32),
          ),
          Container(
            width: 80,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: GoogleFonts.rajdhani(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ),
          IconButton(
            onPressed: onIncrease,
            icon: const Icon(Icons.add_circle_outline, color: AppColors.success, size: 32),
          ),
        ],
      ),
    );
  }
}

class _TimerView extends StatelessWidget {
  final IntervalTimerState state;
  final IntervalTimerNotifier notifier;

  const _TimerView({required this.state, required this.notifier});

  Color get _phaseColor {
    switch (state.phase) {
      case IntervalPhase.prepare:
        return AppColors.warning;
      case IntervalPhase.work:
        return AppColors.success;
      case IntervalPhase.rest:
        return AppColors.info;
      case IntervalPhase.complete:
        return AppColors.primary;
    }
  }

  String get _phaseLabel {
    switch (state.phase) {
      case IntervalPhase.prepare:
        return 'GET READY';
      case IntervalPhase.work:
        return 'WORK';
      case IntervalPhase.rest:
        return 'REST';
      case IntervalPhase.complete:
        return 'COMPLETE!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: state.progress,
          backgroundColor: AppColors.darkSurface,
          color: _phaseColor,
          minHeight: 4,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.phase != IntervalPhase.complete)
                  Text(
                    _phaseLabel,
                    style: GoogleFonts.rajdhani(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                      color: _phaseColor,
                    ),
                  ),
                const SizedBox(height: 40),
                Text(
                  '${state.secondsRemaining}',
                  style: GoogleFonts.rajdhani(
                    fontSize: 120,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    color: _phaseColor,
                  ),
                ),
                if (state.phase != IntervalPhase.complete) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Round ${state.currentRound} / ${state.rounds}',
                    style: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary),
                  ),
                ],
                if (state.phase == IntervalPhase.complete) ...[
                  const SizedBox(height: 20),
                  const Text('🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'Great Work!',
                    style: GoogleFonts.rajdhani(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: state.phase == IntervalPhase.complete
              ? SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: notifier.reset,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: Text('New Session', style: GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: notifier.reset,
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.darkBorder)),
                          child: Text('Reset', style: GoogleFonts.rajdhani(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: state.isRunning ? notifier.pause : notifier.start,
                          style: ElevatedButton.styleFrom(backgroundColor: state.isRunning ? AppColors.warning : AppColors.success),
                          child: Text(
                            state.isRunning ? 'Pause' : 'Resume',
                            style: GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
