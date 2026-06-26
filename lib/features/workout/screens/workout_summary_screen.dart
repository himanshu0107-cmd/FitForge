import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/domain/models/workout.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  final WorkoutSession? session;
  const WorkoutSummaryScreen({super.key, this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                'Workout Complete!',
                style: GoogleFonts.rajdhani(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final s = session!;
    final totalVolume = s.totalVolumeKg;
    final totalSets = s.totalSetsCompleted;
    final duration = s.durationMinutes;
    final exercisesCompleted = s.exerciseLogs.where((e) => !e.isSkipped).length;

    // Detect PRs (simplified: exercises with at least 1 set logged)
    final newPRs =
        s.exerciseLogs.where((e) => e.sets.any((set) => set.isPR)).toList();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Trophy + heading
              _buildHeader(),
              const SizedBox(height: 32),

              // Stats grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
                children: [
                  _StatCard(
                    icon: FontAwesomeIcons.clock,
                    label: 'Duration',
                    value: '${duration}min',
                    color: AppColors.info,
                  ),
                  _StatCard(
                    icon: FontAwesomeIcons.weightHanging,
                    label: 'Total Volume',
                    value: '${totalVolume.toStringAsFixed(0)}kg',
                    color: AppColors.primary,
                  ),
                  _StatCard(
                    icon: FontAwesomeIcons.listCheck,
                    label: 'Sets Done',
                    value: '$totalSets',
                    color: AppColors.success,
                  ),
                  _StatCard(
                    icon: FontAwesomeIcons.dumbbell,
                    label: 'Exercises',
                    value: '$exercisesCompleted',
                    color: AppColors.accent,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PRs section
              if (newPRs.isNotEmpty) ...[
                _PRSection(logs: newPRs),
                const SizedBox(height: 24),
              ],

              // Exercise breakdown
              _ExerciseBreakdown(logs: s.exerciseLogs),

              const SizedBox(height: 32),

              // CTA Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const FaIcon(FontAwesomeIcons.house, size: 16),
                  label: Text(
                    'Back to Home',
                    style: GoogleFonts.rajdhani(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.progress),
                  icon: const FaIcon(FontAwesomeIcons.chartLine, size: 14),
                  label: Text(
                    'View Progress',
                    style: GoogleFonts.rajdhani(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Text('🏆', style: TextStyle(fontSize: 48)),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Workout Complete!',
          style: GoogleFonts.rajdhani(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          session?.workoutName ?? 'Great session!',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: FaIcon(icon, color: color, size: 16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.rajdhani(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PRSection extends StatelessWidget {
  final List<ExerciseLog> logs;
  const _PRSection({required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏅', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'New Personal Records!',
                style: GoogleFonts.rajdhani(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...logs.map((log) {
            final best = log.bestSet;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.star, color: AppColors.warning, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    log.exerciseName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (best != null)
                    Text(
                      '${best.weightKg}kg × ${best.reps}',
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ExerciseBreakdown extends StatelessWidget {
  final List<ExerciseLog> logs;
  const _ExerciseBreakdown({required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercise Breakdown',
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...logs.map((log) => _ExerciseSummaryRow(log: log)),
      ],
    );
  }
}

class _ExerciseSummaryRow extends StatelessWidget {
  final ExerciseLog log;
  const _ExerciseSummaryRow({required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  log.exerciseName,
                  style: GoogleFonts.rajdhani(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: log.isSkipped
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (log.isSkipped)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Skipped',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.error,
                    ),
                  ),
                )
              else
                Text(
                  '${log.totalVolume.toStringAsFixed(0)}kg vol',
                  style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          if (!log.isSkipped && log.sets.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: log.sets.take(5).map((set) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Text(
                    '${set.weightKg.toStringAsFixed(set.weightKg % 1 == 0 ? 0 : 1)}×${set.reps}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
