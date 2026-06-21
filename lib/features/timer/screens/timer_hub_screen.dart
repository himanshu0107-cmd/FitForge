import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitforge/core/theme/app_theme.dart';

// ─────────────────────────────────────────
// TIMER HUB SCREEN — 4 tabs
// ─────────────────────────────────────────
class TimerHubScreen extends StatelessWidget {
  const TimerHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          title: Text(
            'Timer Hub',
            style: GoogleFonts.rajdhani(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(
                  child: Text('Rest',
                      style: GoogleFonts.rajdhani(
                          fontSize: 13, fontWeight: FontWeight.w600))),
              Tab(
                  child: Text('HIIT',
                      style: GoogleFonts.rajdhani(
                          fontSize: 13, fontWeight: FontWeight.w600))),
              Tab(
                  child: Text('Tabata',
                      style: GoogleFonts.rajdhani(
                          fontSize: 13, fontWeight: FontWeight.w600))),
              Tab(
                  child: Text('Stopwatch',
                      style: GoogleFonts.rajdhani(
                          fontSize: 13, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            RestTimerTab(),
            HiitTimerTab(),
            TabataTimerTab(),
            StopwatchTab(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// REST TIMER TAB
// ─────────────────────────────────────────
class RestTimerTab extends StatefulWidget {
  const RestTimerTab({super.key});
  @override
  State<RestTimerTab> createState() => _RestTimerTabState();
}

class _RestTimerTabState extends State<RestTimerTab> {
  int _total = 90;
  int _remaining = 90;
  bool _running = false;
  Timer? _timer;

  static const _presets = [60, 90, 120, 180];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        HapticFeedback.heavyImpact();
        setState(() {
          _running = false;
          _remaining = 0;
        });
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _remaining = _total;
    });
  }

  void _setPreset(int seconds) {
    _timer?.cancel();
    setState(() {
      _total = seconds;
      _remaining = seconds;
      _running = false;
    });
  }

  void _adjust(int delta) {
    setState(() {
      _remaining = (_remaining + delta).clamp(5, 600);
      if (!_running) _total = _remaining;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _total > 0 ? _remaining / _total : 0.0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Preset buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _presets.map((s) {
              final isActive = _total == s;
              return GestureDetector(
                onTap: () => _setPreset(s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isActive ? AppColors.primary : AppColors.darkBorder,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    '${s}s',
                    style: GoogleFonts.rajdhani(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const Spacer(),

          // Circle timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 240,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: AppColors.darkSurface,
                  color: _remaining <= 10
                      ? AppColors.error
                      : progress > 0.3
                          ? AppColors.primary
                          : AppColors.warning,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    _formatTime(_remaining),
                    style: GoogleFonts.rajdhani(
                      fontSize: 58,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _running ? 'RESTING' : 'READY',
                    style: GoogleFonts.rajdhani(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Adjust buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AdjBtn(label: '-15s', onTap: () => _adjust(-15)),
              const SizedBox(width: 12),
              _AdjBtn(label: '-5s', onTap: () => _adjust(-5)),
              const SizedBox(width: 12),
              _AdjBtn(label: '+5s', onTap: () => _adjust(5)),
              const SizedBox(width: 12),
              _AdjBtn(label: '+15s', onTap: () => _adjust(15)),
            ],
          ),

          const Spacer(),

          // Controls
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child:
                      Text('Reset', style: GoogleFonts.rajdhani(fontSize: 15)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _running ? _pause : _start,
                    child: Text(
                      _running
                          ? 'Pause'
                          : (_remaining == _total ? 'Start' : 'Resume'),
                      style: GoogleFonts.rajdhani(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// HIIT TIMER TAB
// ─────────────────────────────────────────
class HiitTimerTab extends StatefulWidget {
  const HiitTimerTab({super.key});
  @override
  State<HiitTimerTab> createState() => _HiitTimerTabState();
}

class _HiitTimerTabState extends State<HiitTimerTab> {
  final _workCtrl = TextEditingController(text: '30');
  final _restCtrl = TextEditingController(text: '15');
  final _roundsCtrl = TextEditingController(text: '8');

  bool _isWork = true;
  bool _running = false;
  int _currentRound = 1;
  int _remaining = 30;
  Timer? _timer;

  int get _workSec => int.tryParse(_workCtrl.text) ?? 30;
  int get _restSec => int.tryParse(_restCtrl.text) ?? 15;
  int get _totalRounds => int.tryParse(_roundsCtrl.text) ?? 8;

  @override
  void dispose() {
    _timer?.cancel();
    _workCtrl.dispose();
    _restCtrl.dispose();
    _roundsCtrl.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isWork = true;
      _currentRound = 1;
      _remaining = _workSec;
      _running = true;
    });
    _tick();
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        HapticFeedback.heavyImpact();
        if (_isWork) {
          // Switch to rest
          setState(() {
            _isWork = false;
            _remaining = _restSec;
          });
        } else {
          // End of rest — next round
          if (_currentRound >= _totalRounds) {
            _timer?.cancel();
            setState(() => _running = false);
            return;
          }
          setState(() {
            _currentRound++;
            _isWork = true;
            _remaining = _workSec;
          });
        }
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _resume() {
    setState(() => _running = true);
    _tick();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _isWork = true;
      _currentRound = 1;
      _remaining = _workSec;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = !_running && _currentRound > _totalRounds;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Config (only editable when not running)
          Row(
            children: [
              Expanded(
                child: _HiitField(
                  controller: _workCtrl,
                  label: 'Work (s)',
                  enabled: !_running,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HiitField(
                  controller: _restCtrl,
                  label: 'Rest (s)',
                  enabled: !_running,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HiitField(
                  controller: _roundsCtrl,
                  label: 'Rounds',
                  enabled: !_running,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Phase indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: (_isWork ? AppColors.timerWork : AppColors.timerRest)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              isComplete
                  ? 'COMPLETE!'
                  : _running || _currentRound > 1
                      ? (_isWork ? 'WORK' : 'REST')
                      : 'READY',
              style: GoogleFonts.rajdhani(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: isComplete
                    ? AppColors.success
                    : _isWork
                        ? AppColors.timerWork
                        : AppColors.timerRest,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Timer display
          Text(
            _formatTime(_remaining),
            style: GoogleFonts.rajdhani(
              fontSize: 72,
              fontWeight: FontWeight.w700,
              color: _isWork ? AppColors.timerWork : AppColors.timerRest,
            ),
          ),

          Text(
            'Round $_currentRound / $_totalRounds',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),

          const Spacer(),

          // Controls
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child:
                      Text('Reset', style: GoogleFonts.rajdhani(fontSize: 15)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: !_running && _currentRound == 1
                        ? _start
                        : _running
                            ? _pause
                            : _resume,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isWork ? AppColors.timerWork : AppColors.timerRest,
                    ),
                    child: Text(
                      _running
                          ? 'Pause'
                          : (!_running && _currentRound > 1
                              ? 'Resume'
                              : 'Start'),
                      style: GoogleFonts.rajdhani(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HiitField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  const _HiitField(
      {required this.controller, required this.label, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: enabled ? AppColors.textPrimary : AppColors.textMuted,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// TABATA TIMER TAB
// ─────────────────────────────────────────
class TabataTimerTab extends StatefulWidget {
  const TabataTimerTab({super.key});
  @override
  State<TabataTimerTab> createState() => _TabataTimerTabState();
}

class _TabataTimerTabState extends State<TabataTimerTab> {
  static const _defaultWork = 20;
  static const _defaultRest = 10;
  static const _defaultRounds = 8;

  int _workSec = _defaultWork;
  int _restSec = _defaultRest;
  int _totalRounds = _defaultRounds;

  bool _isWork = true;
  bool _running = false;
  int _currentRound = 1;
  int _remaining = _defaultWork;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isWork = true;
      _currentRound = 1;
      _remaining = _workSec;
      _running = true;
    });
    _tick();
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        HapticFeedback.heavyImpact();
        if (_isWork) {
          setState(() {
            _isWork = false;
            _remaining = _restSec;
          });
        } else {
          if (_currentRound >= _totalRounds) {
            _timer?.cancel();
            HapticFeedback.vibrate();
            setState(() => _running = false);
            return;
          }
          setState(() {
            _currentRound++;
            _isWork = true;
            _remaining = _workSec;
          });
        }
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _isWork = true;
      _currentRound = 1;
      _remaining = _workSec;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalProgress = (_currentRound - 1) / _totalRounds +
        (_isWork
            ? (_workSec - _remaining) / _workSec / _totalRounds
            : _workSec / _workSec / _totalRounds);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TabataSetting(
                label: 'Work',
                value: '${_workSec}s',
                onInc: !_running
                    ? () => setState(() {
                          _workSec += 5;
                          _remaining = _workSec;
                        })
                    : null,
                onDec: !_running && _workSec > 5
                    ? () => setState(() {
                          _workSec -= 5;
                          _remaining = _workSec;
                        })
                    : null,
              ),
              const SizedBox(width: 16),
              _TabataSetting(
                label: 'Rest',
                value: '${_restSec}s',
                onInc: !_running ? () => setState(() => _restSec += 5) : null,
                onDec: !_running && _restSec > 5
                    ? () => setState(() => _restSec -= 5)
                    : null,
              ),
              const SizedBox(width: 16),
              _TabataSetting(
                label: 'Rounds',
                value: '$_totalRounds',
                onInc: !_running ? () => setState(() => _totalRounds++) : null,
                onDec: !_running && _totalRounds > 1
                    ? () => setState(() => _totalRounds--)
                    : null,
              ),
            ],
          ),

          const Spacer(),

          // Overall progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalProgress.clamp(0.0, 1.0),
              backgroundColor: AppColors.darkSurface,
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Round $_currentRound of $_totalRounds',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
          ),

          const SizedBox(height: 32),

          // Phase label
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isWork
                    ? [
                        AppColors.timerWork.withValues(alpha: 0.3),
                        AppColors.timerWork.withValues(alpha: 0.1)
                      ]
                    : [
                        AppColors.timerRest.withValues(alpha: 0.3),
                        AppColors.timerRest.withValues(alpha: 0.1)
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isWork ? AppColors.timerWork : AppColors.timerRest,
                width: 2,
              ),
            ),
            child: Text(
              _isWork ? '💪 WORK' : '😮‍💨 REST',
              style: GoogleFonts.rajdhani(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _isWork ? AppColors.timerWork : AppColors.timerRest,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '$_remaining',
            style: GoogleFonts.rajdhani(
              fontSize: 96,
              fontWeight: FontWeight.w700,
              color: _isWork ? AppColors.timerWork : AppColors.timerRest,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child:
                      Text('Reset', style: GoogleFonts.rajdhani(fontSize: 15)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _running ? _pause : _start,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isWork ? AppColors.timerWork : AppColors.timerRest,
                    ),
                    child: Text(
                      _running ? 'Pause' : 'Start',
                      style: GoogleFonts.rajdhani(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TabataSetting extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onInc;
  final VoidCallback? onDec;

  const _TabataSetting({
    required this.label,
    required this.value,
    this.onInc,
    this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Row(
          children: [
            GestureDetector(
              onTap: onDec,
              child: Icon(Icons.remove_circle_outline,
                  color:
                      onDec != null ? AppColors.primary : AppColors.textMuted,
                  size: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                value,
                style: GoogleFonts.rajdhani(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: onInc,
              child: Icon(Icons.add_circle_outline,
                  color:
                      onInc != null ? AppColors.primary : AppColors.textMuted,
                  size: 20),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// STOPWATCH TAB
// ─────────────────────────────────────────
class StopwatchTab extends StatefulWidget {
  const StopwatchTab({super.key});
  @override
  State<StopwatchTab> createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<Duration> _laps = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {});
    });
  }

  void _pause() {
    _stopwatch.stop();
    _timer?.cancel();
    setState(() {});
  }

  void _reset() {
    _stopwatch.reset();
    _stopwatch.stop();
    _timer?.cancel();
    setState(() => _laps.clear());
  }

  void _lap() {
    HapticFeedback.lightImpact();
    setState(() => _laps.insert(0, _stopwatch.elapsed));
  }

  String _format(Duration d) {
    final mins = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms =
        (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return '$mins:$secs.$ms';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),

          // Time display
          Text(
            _format(elapsed),
            style: GoogleFonts.rajdhani(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 32),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleBtn(
                icon: Icons.refresh,
                onTap: _reset,
                color: AppColors.error,
                size: 52,
              ),
              const SizedBox(width: 24),
              _CircleBtn(
                icon: _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                onTap: _stopwatch.isRunning ? _pause : _start,
                color: AppColors.primary,
                size: 72,
                iconSize: 32,
              ),
              const SizedBox(width: 24),
              _CircleBtn(
                icon: Icons.flag_outlined,
                onTap: _stopwatch.isRunning ? _lap : null,
                color: AppColors.info,
                size: 52,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Laps
          if (_laps.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, i) {
                  final lapNum = _laps.length - i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Text(
                          'Lap $lapNum',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _format(_laps[i]),
                          style: GoogleFonts.rajdhani(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: i == 0
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ] else
            const Spacer(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final double size;
  final double iconSize;

  const _CircleBtn({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.size,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? color.withValues(alpha: 0.2)
              : AppColors.darkSurface,
          border: Border.all(
            color: onTap != null ? color : AppColors.darkBorder,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: onTap != null ? color : AppColors.textMuted,
          size: iconSize,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────
class _AdjBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AdjBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.rajdhani(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

String _formatTime(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}
