import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restTimerProvider = StateNotifierProvider<RestTimerNotifier, RestTimerState>((ref) {
  return RestTimerNotifier();
});

class RestTimerState {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;

  const RestTimerState({
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
    this.isRunning = false,
  });

  RestTimerState copyWith({int? remainingSeconds, int? totalSeconds, bool? isRunning}) {
    return RestTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class RestTimerNotifier extends StateNotifier<RestTimerState> {
  Timer? _timer;

  RestTimerNotifier() : super(const RestTimerState());

  void startTimer(int seconds) {
    _timer?.cancel();
    
    state = RestTimerState(
      remainingSeconds: seconds,
      totalSeconds: seconds,
      isRunning: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    state = const RestTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class RestTimerWidget extends ConsumerWidget {
  final VoidCallback? onComplete;

  const RestTimerWidget({super.key, this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(restTimerProvider);

    if (!timerState.isRunning && timerState.remainingSeconds == 0) {
      return const SizedBox.shrink();
    }

    if (timerState.remainingSeconds == 0 && onComplete != null) {
      Future.microtask(onComplete!);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rest Timer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: timerState.totalSeconds > 0 ? timerState.remainingSeconds / timerState.totalSeconds : 0,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              _formatTime(timerState.remainingSeconds),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(restTimerProvider.notifier).stopTimer(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
