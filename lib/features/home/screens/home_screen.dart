import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/domain/models/user_profile.dart';
import 'package:fitforge/core/constants/app_enums.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final todayCalories = ref.watch(todayCaloriesProvider);
    final streakAsync = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ref, profileAsync),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                profileAsync.when(
                  data: (profile) =>
                      _GreetingCard(profile: profile, streak: streakAsync.value ?? 0),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 20),
                profileAsync.when(
                  data: (profile) => _CalorieRingCard(
                    eaten: todayCalories,
                    goal: profile?.calorieGoal ?? 2500,
                    proteinEaten: 0,
                    proteinGoal: profile?.proteinGoal ?? 150,
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 20),
                _QuickStartRow(ref: ref),
                const SizedBox(height: 20),
                const _TodayWorkoutCard(),
                const SizedBox(height: 20),
                const _MotivationBanner(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(
      BuildContext context, WidgetRef ref, AsyncValue<UserProfile?> profileAsync) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: AppDecorations.primaryCard.copyWith(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('⚡', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'FitForge',
            style: GoogleFonts.rajdhani(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.profile),
          icon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final UserProfile? profile;
  final int streak;

  const _GreetingCard({required this.profile, required this.streak});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.name ?? 'Athlete',
                  style: GoogleFonts.rajdhani(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '$streak day streak',
                        style: GoogleFonts.rajdhani(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
              borderRadius: BorderRadius.circular(28),
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
    );
  }
}

class _CalorieRingCard extends StatelessWidget {
  final int eaten;
  final int goal;
  final int proteinEaten;
  final int proteinGoal;

  const _CalorieRingCard({
    required this.eaten,
    required this.goal,
    required this.proteinEaten,
    required this.proteinGoal,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (goal - eaten).clamp(0, goal);
    final progress = goal > 0 ? (eaten / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Nutrition",
            style: GoogleFonts.rajdhani(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 130,
                width: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: progress * 100,
                            color: AppColors.primary,
                            radius: 20,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: (1 - progress) * 100,
                            color: AppColors.darkSurface,
                            radius: 20,
                            showTitle: false,
                          ),
                        ],
                        centerSpaceRadius: 45,
                        sectionsSpace: 0,
                        startDegreeOffset: -90,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$eaten',
                          style: GoogleFonts.rajdhani(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'kcal',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MacroStat(
                      label: 'Goal',
                      value: '$goal kcal',
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    _MacroStat(
                      label: 'Eaten',
                      value: '$eaten kcal',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    _MacroStat(
                      label: 'Remaining',
                      value: '$remaining kcal',
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    _MacroStat(
                      label: 'Protein',
                      value: '${proteinEaten}g / ${proteinGoal}g',
                      color: AppColors.info,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.textMuted)),
            Text(value,
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                )),
          ],
        ),
      ],
    );
  }
}

class _QuickStartRow extends StatelessWidget {
  final WidgetRef ref;
  const _QuickStartRow({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickButton(
            icon: FontAwesomeIcons.dumbbell,
            label: 'Start\nWorkout',
            gradient: AppGradients.primaryGradient,
            onTap: () => context.push('/home/exercises'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickButton(
            icon: FontAwesomeIcons.stopwatch,
            label: 'Open\nTimer',
            gradient: const LinearGradient(
              colors: [Color(0xFF2979FF), Color(0xFF00BCD4)],
            ),
            onTap: () => context.go(AppRoutes.timer),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickButton(
            icon: FontAwesomeIcons.bowlFood,
            label: 'Log\nMeal',
            gradient: const LinearGradient(
              colors: [Color(0xFF00C853), Color(0xFF64DD17)],
            ),
            onTap: () => context.go(AppRoutes.diet),
          ),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            FaIcon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayWorkoutCard extends ConsumerWidget {
  const _TodayWorkoutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.primaryCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.fire,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                "Today's Workout",
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          programsAsync.when(
            data: (programs) {
              final program = programs.isNotEmpty ? programs.first : null;
              final day = program?.weeks.isNotEmpty == true
                  ? program!.weeks.first.days.first
                  : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program?.name ?? 'No Program Selected',
                    style: GoogleFonts.rajdhani(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day?.isRestDay == true
                        ? '😴 Rest Day'
                        : '${day?.exercises.length ?? 0} exercises • Week 1 Day 1',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: day?.isRestDay == true
                          ? null
                          : () => context.push(AppRoutes.workoutSession,
                              extra: {
                                'workoutName': day?.name ?? 'Workout',
                                'exercises': day?.exercises ?? [],
                                'planId': program?.id ?? '',
                              }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        day?.isRestDay == true ? 'Rest Today' : 'Start Session',
                        style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (_, __) => const Text('Failed to load'),
          ),
        ],
      ),
    );
  }
}

class _MotivationBanner extends StatelessWidget {
  const _MotivationBanner();

  static const quotes = [
    'The only bad workout is the one that didn\'t happen.',
    'Train insane or remain the same.',
    'Your only limit is you.',
    'Sweat is just fat crying.',
    'Push yourself, because no one else is going to do it for you.',
  ];

  @override
  Widget build(BuildContext context) {
    final quote = quotes[DateTime.now().day % quotes.length];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          const Text('💬', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '"$quote"',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: AppDecorations.card,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
