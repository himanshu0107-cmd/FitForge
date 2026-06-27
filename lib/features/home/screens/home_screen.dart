import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/home_dashboard.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return const Scaffold(
      body: HomeDashboard(),
    );
  }
}

// ─────────────────────────────────────────
// HERO APP BAR
// ─────────────────────────────────────────
class _HeroAppBar extends StatelessWidget {
  final AsyncValue<UserProfile?> profileAsync;
  final AsyncValue<int> streakAsync;

  const _HeroAppBar({
    required this.profileAsync,
    required this.streakAsync,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 5
        ? 'Night Owl 🌙'
        : hour < 12
            ? 'Good Morning ☀️'
            : hour < 17
                ? 'Good Afternoon'
                : hour < 21
                    ? 'Good Evening 🌆'
                    : 'Good Night 🌙';

    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient mesh
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F0E1F),
                    AppColors.darkBackground,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Orb glow top-right
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: logo + profile
                    Row(
                      children: [
                        // Logo badge
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow:
                                AppShadows.glow(AppColors.primary, intensity: 0.5),
                          ),
                          child: const Center(
                            child: Text('⚡', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'FitForge',
                          style: GoogleFonts.rajdhani(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        // Profile button
                        _PressScale(
                          onTap: () => context.push(AppRoutes.profile),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.darkSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: AppColors.darkBorderBright, width: 1),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Greeting
                    profileAsync.when(
                      data: (profile) => Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  greeting,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  profile?.name ?? 'Athlete',
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Sport emoji avatar
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primaryGradient,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow:
                                  AppShadows.glow(AppColors.primary, intensity: 0.4),
                            ),
                            child: Center(
                              child: Text(
                                profile?.sportType.emoji ?? '🏋️',
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                        ],
                      ),
                      loading: () => _shimmerBox(width: 160, height: 40),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// BENTO NUTRITION ROW
// ─────────────────────────────────────────
class _BentoNutritionRow extends StatelessWidget {
  final int eaten, goal, proteinEaten, proteinGoal, carbEaten, carbGoal,
      fatEaten, fatGoal;

  const _BentoNutritionRow({
    required this.eaten,
    required this.goal,
    required this.proteinEaten,
    required this.proteinGoal,
    required this.carbEaten,
    required this.carbGoal,
    required this.fatEaten,
    required this.fatGoal,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (goal - eaten).clamp(0, goal);
    final progress = goal > 0 ? (eaten / goal).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left: Calorie ring ──
          Expanded(
            flex: 5,
            child: Container(
              decoration: AppDecorations.glowCard(AppColors.primary),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TODAY'S CALORIES",
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Custom arc ring
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(96, 96),
                              painter: _ArcRingPainter(
                                progress: progress,
                                color: AppColors.primary,
                                trackColor:
                                    AppColors.darkSurface,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$eaten',
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    height: 1.0,
                                  ),
                                ),
                                Text(
                                  'eaten',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _KcalLine(
                                label: 'Goal',
                                value: '$goal',
                                color: AppColors.textSecondary),
                            const SizedBox(height: 8),
                            _KcalLine(
                                label: 'Left',
                                value: '$remaining',
                                color: AppColors.success),
                            const SizedBox(height: 8),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppColors.darkSurface,
                                valueColor:
                                    const AlwaysStoppedAnimation(AppColors.primary),
                                minHeight: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // ── Right: Macro mini-cards stack ──
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: _MacroMiniCard(
                    label: 'PROTEIN',
                    value: proteinEaten,
                    goal: proteinGoal,
                    color: AppColors.info,
                    unit: 'g',
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _MacroMiniCard(
                    label: 'CARBS',
                    value: carbEaten,
                    goal: carbGoal,
                    color: AppColors.warning,
                    unit: 'g',
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _MacroMiniCard(
                    label: 'FAT',
                    value: fatEaten,
                    goal: fatGoal,
                    color: AppColors.success,
                    unit: 'g',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KcalLine extends StatelessWidget {
  final String label, value;
  final Color color;
  const _KcalLine(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
        Text(value,
            style: GoogleFonts.rajdhani(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color)),
      ],
    );
  }
}

class _MacroMiniCard extends StatelessWidget {
  final String label, unit;
  final int value, goal;
  final Color color;

  const _MacroMiniCard({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final pct = goal > 0 ? (value / goal).clamp(0.0, 1.0) : 0.0;
    return Container(
      decoration: AppDecorations.glowCard(color),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '$value$unit',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.darkSurface,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// CUSTOM ARC RING PAINTER
// ─────────────────────────────────────────
class _ArcRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _ArcRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy) - 8;
    const strokeWidth = 8.0;
    const startAngle = -math.pi * 0.75;
    const sweepTotal = math.pi * 1.5;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepTotal,
      false,
      trackPaint,
    );

    if (progress > 0) {
      // Glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = strokeWidth + 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweepTotal * progress,
        false,
        glowPaint,
      );

      // Arc fill
      final fillPaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepTotal * progress,
          colors: [color.withValues(alpha: 0.7), color],
          tileMode: TileMode.clamp,
        ).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweepTotal * progress,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcRingPainter old) =>
      old.progress != progress || old.color != color;
}

// ─────────────────────────────────────────
// STATS STRIP
// ─────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  final int weeklyWorkouts, streak;
  const _StatsStrip(
      {required this.weeklyWorkouts, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          _StatCell(
            emoji: '🏋️',
            value: '$weeklyWorkouts',
            label: 'Workouts',
            sub: 'this week',
            color: AppColors.primary,
          ),
          _verticalDivider(),
          _StatCell(
            emoji: '🔥',
            value: '$streak',
            label: 'Day Streak',
            sub: streak > 0 ? 'keep it up!' : 'start today',
            color: AppColors.warning,
          ),
          _verticalDivider(),
          _StatCell(
            emoji: weeklyWorkouts >= 3 ? '🎯' : '⚡',
            value: weeklyWorkouts >= 3 ? 'On Track' : 'Keep Going',
            label: 'Weekly Goal',
            sub: '$weeklyWorkouts/5 done',
            color:
                weeklyWorkouts >= 3 ? AppColors.success : AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 44,
      color: AppColors.darkBorder,
    );
  }
}

class _StatCell extends StatelessWidget {
  final String emoji, value, label, sub;
  final Color color;

  const _StatCell({
    required this.emoji,
    required this.value,
    required this.label,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.rajdhani(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1.1,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
          Text(
            sub,
            style: GoogleFonts.inter(
                fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// QUICK ACTIONS
// ─────────────────────────────────────────
class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'QUICK ACTIONS',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1.4,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: FontAwesomeIcons.dumbbell,
                label: 'Workout',
                gradient: AppGradients.primaryGradient,
                onTap: () => context.push('/home/exercises'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                icon: FontAwesomeIcons.stopwatch,
                label: 'Timer',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4D8FFF), Color(0xFF00E5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => context.go(AppRoutes.timer),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                icon: FontAwesomeIcons.utensils,
                label: 'Log Meal',
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => context.go(AppRoutes.diet),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                icon: FontAwesomeIcons.chartLine,
                label: 'Progress',
                gradient: const LinearGradient(
                  colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => context.go(AppRoutes.progress),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 140));
    _scale = Tween(begin: 1.0, end: 0.92).animate(
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
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.glow(
                widget.gradient.colors.first, intensity: 0.3),
          ),
          child: Column(
            children: [
              FaIcon(widget.icon, color: Colors.white, size: 18),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TODAY'S WORKOUT CARD
// ─────────────────────────────────────────
class _TodayWorkoutCard extends ConsumerWidget {
  const _TodayWorkoutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            "TODAY'S WORKOUT",
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1.4,
            ),
          ),
        ),
        programsAsync.when(
          data: (programs) {
            final activeState = activeProgramAsync.valueOrNull;
            final program = activeState != null
                ? programs.firstWhere(
                    (p) => p.id == activeState.programId,
                    orElse: () =>
                        programs.isNotEmpty ? programs.first : programs.first,
                  )
                : (programs.isNotEmpty ? programs.first : null);

            if (program == null) {
              return _NoProgramCard();
            }

            final weekIdx = (activeState?.currentWeek ?? 1) - 1;
            final dayIdx = (activeState?.currentDay ?? 1) - 1;
            final week = program.weeks.isNotEmpty
                ? program.weeks[weekIdx.clamp(0, program.weeks.length - 1)]
                : null;
            final day = week?.days.isNotEmpty == true
                ? week!.days[dayIdx.clamp(0, week.days.length - 1)]
                : null;
            final isRest = day?.isRestDay == true;

            return _PressScale(
              onTap: isRest
                  ? null
                  : () => context.push(AppRoutes.workoutSession, extra: {
                        'workoutName': day?.name ?? 'Workout',
                        'exercises': day?.exercises ?? [],
                        'planId': program.id,
                      }),
              child: Container(
                decoration: AppDecorations.primaryCard,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(FontAwesomeIcons.fire,
                                  color: Colors.white, size: 10),
                              const SizedBox(width: 5),
                              Text(
                                isRest
                                    ? 'REST DAY'
                                    : 'W${activeState?.currentWeek ?? 1} · D${activeState?.currentDay ?? 1}',
                                style: GoogleFonts.rajdhani(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (!isRest)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${day?.exercises.length ?? 0} exercises',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Program + workout name
                    Text(
                      program.name,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.65),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isRest ? '😴 Rest & Recover' : day?.name ?? 'Workout',
                      style: GoogleFonts.rajdhani(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),

                    // Exercise chips preview
                    if (!isRest && day != null && day.exercises.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: day.exercises
                            .take(3)
                            .map((e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    e.exerciseName,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.white
                                          .withValues(alpha: 0.85),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList()
                          ..addAll(
                            day.exercises.length > 3
                                ? [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.14),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '+${day.exercises.length - 3} more',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    )
                                  ]
                                : [],
                          ),
                      ),
                    ],

                    const SizedBox(height: 18),
                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: isRest
                            ? null
                            : () => context.push(AppRoutes.workoutSession,
                                extra: {
                                  'workoutName': day?.name ?? 'Workout',
                                  'exercises': day?.exercises ?? [],
                                  'planId': program.id,
                                }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              Colors.white.withValues(alpha: 0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              isRest
                                  ? FontAwesomeIcons.bed
                                  : FontAwesomeIcons.play,
                              size: 13,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isRest ? 'Enjoy your rest' : 'Start Session',
                              style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => _shimmerBox(height: 200),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

class _NoProgramCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('🏋️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'No Active Program',
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select a training program to get started',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          _PressScale(
            onTap: () => context.go(AppRoutes.programs),
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: AppDecorations.primaryCard,
              child: Center(
                child: Text(
                  'Browse Programs',
                  style: GoogleFonts.rajdhani(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
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
// MOTIVATION CARD
// ─────────────────────────────────────────
class _MotivationCard extends StatelessWidget {
  const _MotivationCard();

  static const _quotes = [
    ('The only bad workout is the one that didn\'t happen.', 'Unknown'),
    ('Train insane or remain the same.', 'Jillian Michaels'),
    ('Your body can stand almost anything. It\'s your mind you have to convince.', 'Unknown'),
    ('Strength does not come from the body. It comes from the will.', 'Mahatma Gandhi'),
    ('The pain you feel today will be the strength you feel tomorrow.', 'Arnold Schwarzenegger'),
    ('Champions aren\'t made in gyms. They\'re made from something deep inside them.', 'Muhammad Ali'),
    ('The last three or four reps is what makes the muscle grow.', 'Arnold Schwarzenegger'),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = DateTime.now().day % _quotes.length;
    final (quote, author) = _quotes[idx];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25), width: 1),
            ),
            child: const Center(
              child: Text('💬', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"$quote"',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '— $author',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// SHIMMER BENTO PLACEHOLDER
// ─────────────────────────────────────────
class _ShimmerBento extends StatefulWidget {
  const _ShimmerBento();

  @override
  State<_ShimmerBento> createState() => _ShimmerBentoState();
}

class _ShimmerBentoState extends State<_ShimmerBento>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
    _shimmer = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) {
        return SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _shimmerContainer(borderRadius: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(child: _shimmerContainer(borderRadius: 16)),
                    const SizedBox(height: 10),
                    Expanded(child: _shimmerContainer(borderRadius: 16)),
                    const SizedBox(height: 10),
                    Expanded(child: _shimmerContainer(borderRadius: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerContainer({double borderRadius = 16}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment(_shimmer.value - 1, 0),
          end: Alignment(_shimmer.value, 0),
          colors: const [
            AppColors.darkCard,
            AppColors.darkSurface,
            AppColors.darkCard,
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
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
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
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}

// ─────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────
Widget _shimmerBox({double height = 100, double? width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: AppColors.darkCard,
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
