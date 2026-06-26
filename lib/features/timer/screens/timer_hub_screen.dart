import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/services/notification_service.dart';

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
          elevation: 0,
          title: Text(
            'Timer Hub',
            style: GoogleFonts.rajdhani(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: GoogleFonts.rajdhani(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.rajdhani(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            indicator: UnderlineTabIndicator(
              borderSide: const BorderSide(color: AppColors.primary, width: 3),
              borderRadius: BorderRadius.circular(3),
              insets: const EdgeInsets.symmetric(horizontal: 16),
            ),
            tabs: const [
              Tab(text: 'Rest'),
              Tab(text: 'HIIT'),
              Tab(text: 'Tabata'),
              Tab(text: 'Stopwatch'),
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

class _RestTimerTabState extends State<RestTimerTab>
    with SingleTickerProviderStateMixin {
  int _total = 90;
  int _remaining = 90;
  bool _running = false;
  Timer? _timer;
  late AnimationController _pulseCtrl;

  static const _presets = [60, 90, 120, 180];

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
        NotificationService().showRestTimerComplete();
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
              return _PressScale(
                onTap: () => _setPreset(s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.darkBorder,
                      width: isActive ? 1.5 : 1,
                    ),
                    boxShadow: isActive
                        ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 12)]
                        : null,
                  ),
                  child: Text(
                    '${s}s',
                    style: GoogleFonts.rajdhani(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
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
              CustomPaint(
                size: const Size(230, 230),
                painter: RadialTimerPainter(
                  progress: progress,
                  color: _remaining <= 10
                      ? AppColors.error
                      : progress > 0.3
                          ? AppColors.primary
                          : AppColors.warning,
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
                      _formatTime(_remaining),
                      style: GoogleFonts.rajdhani(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      _running ? 'RESTING' : 'READY',
                      style: GoogleFonts.rajdhani(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: _running ? AppColors.primary : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

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
                child: SizedBox(
                  height: 50,
                  child: _PressScale(
                    onTap: _reset,
                    child: OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
                      ),
                      child: Text('Reset',
                          style: GoogleFonts.rajdhani(fontSize: 15, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: _PressScale(
                    onTap: _running ? _pause : _start,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: AppColors.primary,
                        disabledForegroundColor: Colors.white,
                      ),
                      child: Text(
                        _running
                            ? 'Pause'
                            : (_remaining == _total ? 'Start' : 'Resume'),
                        style: GoogleFonts.rajdhani(
                            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

class _HiitTimerTabState extends State<HiitTimerTab>
    with SingleTickerProviderStateMixin {
  final _workCtrl = TextEditingController(text: '30');
  final _restCtrl = TextEditingController(text: '15');
  final _roundsCtrl = TextEditingController(text: '8');

  bool _isWork = true;
  bool _running = false;
  int _currentRound = 1;
  int _remaining = 30;
  Timer? _timer;
  late AnimationController _pulseCtrl;

  int get _workSec => int.tryParse(_workCtrl.text) ?? 30;
  int get _restSec => int.tryParse(_restCtrl.text) ?? 15;
  int get _totalRounds => int.tryParse(_roundsCtrl.text) ?? 8;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
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
    final totalSecs = _isWork ? _workSec : _restSec;
    final progress = totalSecs > 0 ? _remaining / totalSecs : 0.0;
    final activeColor = _isWork ? AppColors.timerWork : AppColors.timerRest;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Config inputs in sheen cards
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

          // Phase indicator & Circle dial
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(220, 220),
                painter: RadialTimerPainter(
                  progress: progress,
                  color: activeColor,
                ),
              ),
              ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.02).animate(
                  CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: activeColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        isComplete
                            ? 'FINISHED'
                            : _running || _currentRound > 1
                                ? (_isWork ? 'WORK' : 'REST')
                                : 'READY',
                        style: GoogleFonts.rajdhani(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: activeColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatTime(_remaining),
                      style: GoogleFonts.rajdhani(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'Round $_currentRound / $_totalRounds',
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

          const Spacer(),

          // Controls
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: _PressScale(
                    onTap: _reset,
                    child: OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
                      ),
                      child: Text('Reset',
                          style: GoogleFonts.rajdhani(fontSize: 15, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: _PressScale(
                    onTap: !_running && _currentRound == 1
                        ? _start
                        : _running
                            ? _pause
                            : _resume,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: activeColor,
                        disabledForegroundColor: Colors.white,
                      ),
                      child: Text(
                        _running
                            ? 'Pause'
                            : (!_running && _currentRound > 1
                                ? 'Resume'
                                : 'Start'),
                        style: GoogleFonts.rajdhani(
                            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppDecorations.sheenCard(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label.toUpperCase(),
              style: GoogleFonts.rajdhani(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: enabled ? AppColors.textPrimary : AppColors.textMuted,
            ),
            decoration: const InputDecoration(
              filled: false,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ],
      ),
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

class _TabataTimerTabState extends State<TabataTimerTab>
    with SingleTickerProviderStateMixin {
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
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
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

    final currentTotal = _isWork ? _workSec : _restSec;
    final dialProgress = currentTotal > 0 ? _remaining / currentTotal : 0.0;
    final activeColor = _isWork ? AppColors.timerWork : AppColors.timerRest;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Settings Row
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
              const SizedBox(width: 12),
              _TabataSetting(
                label: 'Rest',
                value: '${_restSec}s',
                onInc: !_running ? () => setState(() => _restSec += 5) : null,
                onDec: !_running && _restSec > 5
                    ? () => setState(() => _restSec -= 5)
                    : null,
              ),
              const SizedBox(width: 12),
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

          // Overall progress indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Round $_currentRound of $_totalRounds',
                    style: GoogleFonts.rajdhani(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(totalProgress * 100).toStringAsFixed(0)}% Done',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: totalProgress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.darkSurface,
                  color: AppColors.primary,
                  minHeight: 6,
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

          // Circle dial with breathing animation
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(210, 210),
                painter: RadialTimerPainter(
                  progress: dialProgress,
                  color: activeColor,
                ),
              ),
              ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.02).animate(
                  CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: activeColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _running
                            ? (_isWork ? 'WORK' : 'REST')
                            : 'READY',
                        style: GoogleFonts.rajdhani(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: activeColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatTime(_remaining),
                      style: GoogleFonts.rajdhani(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'ROUND $_currentRound',
                      style: GoogleFonts.rajdhani(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // Controls
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: _PressScale(
                    onTap: _reset,
                    child: OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
                      ),
                      child: Text('Reset',
                          style: GoogleFonts.rajdhani(fontSize: 15, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: _PressScale(
                    onTap: _running ? _pause : _start,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: activeColor,
                        disabledForegroundColor: Colors.white,
                      ),
                      child: Text(
                        _running ? 'Pause' : 'Start',
                        style: GoogleFonts.rajdhani(
                            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: AppDecorations.sheenCard(radius: 14),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.rajdhani(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.rajdhani(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PressScale(
                  onTap: onDec,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: onDec != null ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                ),
                _PressScale(
                  onTap: onInc,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: onInc != null ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 36),

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

          const SizedBox(height: 36),

          // Laps
          if (_laps.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _laps.length,
                itemBuilder: (context, i) {
                  final lapNum = _laps.length - i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Lap $lapNum',
                            style: GoogleFonts.rajdhani(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _format(_laps[i]),
                            style: GoogleFonts.rajdhani(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: i == 0
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else
            const Spacer(),

          const SizedBox(height: 12),
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
    return _PressScale(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? color.withValues(alpha: 0.15)
              : AppColors.darkSurface,
          border: Border.all(
            color: onTap != null ? color : AppColors.darkBorder,
            width: 2,
          ),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 10,
                  )
                ]
              : null,
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
// HELPERS & PAINTER
// ─────────────────────────────────────────
class _AdjBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AdjBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.rajdhani(
              fontSize: 14,
              fontWeight: FontWeight.bold,
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

class RadialTimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  RadialTimerPainter({required this.progress, required this.color});

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
  bool shouldRepaint(covariant RadialTimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

// ─────────────────────────────────────────
// PRESS SCALE WRAPPER (LOCAL)
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
