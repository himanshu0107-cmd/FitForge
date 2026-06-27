import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/core/providers/program_provider.dart';
import 'package:fitforge/domain/models/diet_and_progress.dart';
import 'package:fitforge/domain/models/workout.dart';

// ─────────────────────────────────────────
// PRESS SCALE
// ─────────────────────────────────────────
class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressScale({required this.child, required this.onTap});
  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnim = Tween<double>(begin: 1, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scaleAnim, child: widget.child),
    );
  }
}

// ─────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────
class ProgramDetailScreen extends ConsumerWidget {
  final String programId;
  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);

    return programsAsync.when(
      data: (programs) {
        final program = programs.firstWhere(
          (p) => p.id == programId,
          orElse: () => programs.first,
        );
        return _ProgramDetailContent(program: program);
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

// ─────────────────────────────────────────
// DETAIL CONTENT (Stateful)
// ─────────────────────────────────────────
class _ProgramDetailContent extends StatefulWidget {
  final TrainingProgram program;
  const _ProgramDetailContent({required this.program});

  @override
  State<_ProgramDetailContent> createState() => _ProgramDetailContentState();
}

class _ProgramDetailContentState extends State<_ProgramDetailContent>
    with SingleTickerProviderStateMixin {
  int _selectedWeek = 0;
  int? _expandedDay;
  late AnimationController _shimCtrl;

  Color get _color {
    switch (widget.program.sport.toLowerCase()) {
      case 'gym': return AppColors.primary;
      case 'football': return AppColors.success;
      case 'boxing': return AppColors.error;
      case 'running': return AppColors.info;
      default: return AppColors.accent;
    }
  }

  String get _emoji {
    switch (widget.program.sport.toLowerCase()) {
      case 'gym': return '🏋️';
      case 'football': return '⚽';
      case 'boxing': return '🥊';
      case 'running': return '🏃';
      default: return '⚡';
    }
  }

  @override
  void initState() {
    super.initState();
    _shimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _shimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final program = widget.program;
    final weeks = program.weeks;
    final currentWeek = weeks.isNotEmpty ? weeks[_selectedWeek] : null;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.darkBackground,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _shimCtrl,
                builder: (_, __) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _color.withValues(alpha: 0.7),
                        _color.withValues(alpha: 0.3),
                        AppColors.darkBackground,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Sheen
                      Positioned.fill(
                        child: Transform.rotate(
                          angle: -math.pi / 5,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(
                                    alpha: 0.03 +
                                        0.025 *
                                            math.sin(_shimCtrl.value * 2 * math.pi),
                                  ),
                                  Colors.transparent,
                                ],
                                stops: const [0.3, 0.5, 0.7],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Giant emoji
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Text(_emoji, style: const TextStyle(fontSize: 160)),
                      ),
                      // Content
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Level badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _color.withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  program.level.toUpperCase(),
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Program name
                              Text(
                                program.name,
                                style: GoogleFonts.rajdhani(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Meta chips
                              Row(
                                children: [
                                  _HeaderChip(
                                    icon: FontAwesomeIcons.calendarDays,
                                    label: '${program.daysPerWeek}x / week',
                                  ),
                                  const SizedBox(width: 8),
                                  _HeaderChip(
                                    icon: FontAwesomeIcons.clock,
                                    label: '${program.durationWeeks} weeks',
                                  ),
                                  const SizedBox(width: 8),
                                  _HeaderChip(
                                    icon: FontAwesomeIcons.dumbbell,
                                    label: program.sport,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Description card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Text(
                    program.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.65,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Week selector (if multi-week)
                if (weeks.length > 1) ...[
                  const _SectionTitle(label: 'SELECT WEEK'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weeks.length,
                      itemBuilder: (context, i) {
                        final isSelected = i == _selectedWeek;
                        return _PressScale(
                          onTap: () => setState(() {
                            _selectedWeek = i;
                            _expandedDay = null;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _color.withValues(alpha: 0.18)
                                  : AppColors.darkCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? _color
                                    : AppColors.darkBorder,
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: _color.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(
                              'Week ${weeks[i].weekNumber}',
                              style: GoogleFonts.rajdhani(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? _color
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (currentWeek != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 14,
                          decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentWeek.focus,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                ],

                // Training days
                if (currentWeek != null) ...[
                  const _SectionTitle(label: 'TRAINING DAYS'),
                  const SizedBox(height: 12),
                  ...currentWeek.days.map((day) {
                    final isExpanded = _expandedDay == day.dayNumber;
                    final isRest = day.isRestDay;
                    return Column(
                      children: [
                        _PressScale(
                          onTap: () {
                            if (!isRest) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _expandedDay =
                                    isExpanded ? null : day.dayNumber;
                              });
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isExpanded
                                  ? _color.withValues(alpha: 0.08)
                                  : AppColors.darkCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isExpanded
                                    ? _color.withValues(alpha: 0.45)
                                    : isRest
                                        ? AppColors.darkBorder
                                        : AppColors.darkBorder,
                                width: isExpanded ? 1.5 : 1,
                              ),
                              boxShadow: isExpanded
                                  ? [
                                      BoxShadow(
                                        color: _color.withValues(alpha: 0.12),
                                        blurRadius: 12,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                // Day circle
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isRest
                                        ? AppColors.darkSurface
                                        : _color.withValues(alpha: 0.18),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isRest
                                          ? AppColors.darkBorder
                                          : _color.withValues(alpha: 0.35),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: isRest
                                        ? const Text('😴',
                                            style: TextStyle(fontSize: 18))
                                        : Text(
                                            'D${day.dayNumber}',
                                            style: GoogleFonts.rajdhani(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: _color,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        day.name,
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: isRest
                                              ? AppColors.textMuted
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (!isRest)
                                        Text(
                                          '${day.exercises.length} exercises',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Start button
                                if (!isRest) ...[
                                  _PressScale(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      context.push(
                                        AppRoutes.workoutSession,
                                        extra: {
                                          'workoutName': day.name,
                                          'exercises': day.exercises
                                              .map(
                                                (e) => PlannedExercise(
                                                  exerciseId: e.exerciseId,
                                                  exerciseName: e.exerciseName,
                                                  sets: _parseSets(e.setsReps),
                                                  reps: _parseReps(e.setsReps),
                                                  restSeconds: e.restSeconds,
                                                  order: 0,
                                                ),
                                              )
                                              .toList(),
                                          'planId': widget.program.id,
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: _color.withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _color.withValues(alpha: 0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.play_arrow,
                                              size: 14, color: _color),
                                          const SizedBox(width: 3),
                                          Text(
                                            'Start',
                                            style: GoogleFonts.rajdhani(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: _color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.textMuted,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Expandable exercise list
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: isRest
                              ? const SizedBox.shrink()
                              : Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 0, bottom: 10),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkSurface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: _color.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: day.exercises
                                        .asMap()
                                        .entries
                                        .map((e) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Row(
                                                children: [
                                                  // Exercise number bubble
                                                  Container(
                                                    width: 26,
                                                    height: 26,
                                                    decoration: BoxDecoration(
                                                      color: _color.withValues(
                                                          alpha: 0.15),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: _color
                                                            .withValues(
                                                                alpha: 0.3),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${e.key + 1}',
                                                        style:
                                                            GoogleFonts.rajdhani(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: _color,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      e.value.exerciseName,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 13,
                                                        color: AppColors
                                                            .textPrimary,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color: _color.withValues(
                                                          alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Text(
                                                      e.value.setsReps,
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: _color,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 220),
                        ),
                      ],
                    );
                  }),
                ],

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          final enrollmentAsync = ref.watch(activeEnrollmentProvider);
          final isEnrolled = enrollmentAsync.value?.programId == widget.program.id;

          return FloatingActionButton.extended(
            onPressed: () {
              if (isEnrolled) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Already enrolled in this program!')),
                );
              } else {
                HapticFeedback.mediumImpact();
                ref.read(programNotifierProvider.notifier).enrollProgram(
                  programId: widget.program.id,
                  programName: widget.program.name,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Enrolled in ${widget.program.name}!')),
                );
              }
            },
            backgroundColor: isEnrolled ? AppColors.success : _color,
            icon: Icon(
              isEnrolled ? Icons.check_circle : Icons.add_circle,
              color: Colors.white,
            ),
            label: Text(
              isEnrolled ? 'Enrolled' : 'Enroll Program',
              style: GoogleFonts.rajdhani(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  int _parseSets(String setsReps) {
    final parts = setsReps.split('x');
    if (parts.length >= 2) {
      return int.tryParse(
              parts[0].trim().replaceAll(RegExp(r'[^0-9]'), '')) ??
          3;
    }
    return 3;
  }

  int _parseReps(String setsReps) {
    final parts = setsReps.split('x');
    if (parts.length >= 2) {
      return int.tryParse(
              parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '')) ??
          10;
    }
    return 10;
  }
}

// ─────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.rajdhani(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.5,
        color: AppColors.textMuted,
      ),
    );
  }
}

// ─────────────────────────────────────────
// HEADER CHIP
// ─────────────────────────────────────────
class _HeaderChip extends StatelessWidget {
  final FaIconData icon;
  final String label;
  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: Colors.white60),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
