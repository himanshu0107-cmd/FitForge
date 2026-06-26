import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/domain/models/workout.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppGradients.primaryGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: AppShadows.glow(AppColors.primary, intensity: 0.4),
              ),
              child: const Center(
                  child: Text('📈', style: TextStyle(fontSize: 15))),
            ),
            const SizedBox(width: 10),
            Text(
              'Progress',
              style: GoogleFonts.rajdhani(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showAddWeightDialog(context, ref),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:
                      AppShadows.glow(AppColors.primary, intensity: 0.4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      'Log Weight',
                      style: GoogleFonts.rajdhani(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.darkCard,
        onRefresh: () async {
          ref.invalidate(weightLogProvider);
          ref.invalidate(personalRecordsProvider);
          ref.invalidate(workoutHistoryProvider);
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: const [
            _WeightChartSection(),
            SizedBox(height: 20),
            _PersonalRecordsSection(),
            SizedBox(height: 20),
            _WorkoutCalendarSection(),
            SizedBox(height: 20),
            _RecentSessionsSection(),
          ],
        ),
      ),
    );
  }

  void _showAddWeightDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          'Log Weight',
          style: GoogleFonts.rajdhani(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.rajdhani(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            hintText: '75.5',
            suffixText: 'kg',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final w = double.tryParse(ctrl.text);
              if (w != null && w > 0) {
                ref.read(weightLogProvider.notifier).addEntry(w);
                Navigator.pop(ctx);
              }
            },
            child: Text('Save',
                style: GoogleFonts.rajdhani(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// WEIGHT CHART
// ─────────────────────────────────────────
class _WeightChartSection extends ConsumerWidget {
  const _WeightChartSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(weightLogProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Progress',
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Last 30 days',
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          logsAsync.when(
            data: (logs) {
              if (logs.isEmpty) {
                return SizedBox(
                  height: 140,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⚖️', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        Text('No weight data yet',
                            style: GoogleFonts.inter(
                                color: AppColors.textMuted)),
                        Text('Tap + to log your first weight',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                );
              }

              // Get last 30 days of logs
              final cutoff =
                  DateTime.now().subtract(const Duration(days: 30));
              final recent = logs
                  .where((l) => l.loggedAt.isAfter(cutoff))
                  .toList()
                ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));

              if (recent.isEmpty) {
                return SizedBox(
                  height: 140,
                  child: Center(
                    child: Text('No data in last 30 days',
                        style: GoogleFonts.inter(
                            color: AppColors.textMuted)),
                  ),
                );
              }

              final minW = recent
                  .map((l) => l.weightKg)
                  .reduce((a, b) => a < b ? a : b);
              final maxW = recent
                  .map((l) => l.weightKg)
                  .reduce((a, b) => a > b ? a : b);
              final range = (maxW - minW).clamp(2.0, double.infinity);

              final spots = recent.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.weightKg);
              }).toList();

              // Summary stats
              final current = recent.last.weightKg;
              final start = recent.first.weightKg;
              final change = current - start;

              return Column(
                children: [
                  // Stats row
                  Row(
                    children: [
                      _WeightStat(
                          label: 'Current',
                          value: '${current.toStringAsFixed(1)}kg',
                          color: AppColors.primary),
                      const SizedBox(width: 16),
                      _WeightStat(
                          label: 'Start',
                          value: '${start.toStringAsFixed(1)}kg',
                          color: AppColors.textSecondary),
                      const SizedBox(width: 16),
                      _WeightStat(
                          label: 'Change',
                          value:
                              '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}kg',
                          color: change >= 0
                              ? AppColors.success
                              : AppColors.error),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Line chart
                  SizedBox(
                    height: 160,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) => const FlLine(
                            color: AppColors.chartGrid,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (v, _) => Text(
                                v.toStringAsFixed(1),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (v, _) {
                                final idx = v.toInt();
                                if (idx >= recent.length) return const SizedBox();
                                if (idx % (recent.length ~/ 4).clamp(1, 10) != 0) {
                                  return const SizedBox();
                                }
                                return Text(
                                  DateFormat('d/M')
                                      .format(recent[idx].loggedAt),
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    color: AppColors.textMuted,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minY: (minW - range * 0.1),
                        maxY: (maxW + range * 0.1),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            curveSmoothness: 0.3,
                            color: AppColors.primary,
                            barWidth: 2.5,
                            dotData: FlDotData(
                              show: recent.length <= 10,
                              getDotPainter: (_, __, ___, ____) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: AppColors.primary,
                                strokeWidth: 2,
                                strokeColor: AppColors.darkBackground,
                              ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.chartFill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(
              height: 160,
              child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
            ),
            error: (e, _) =>
                Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }
}

class _WeightStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _WeightStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.rajdhani(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                )),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// PERSONAL RECORDS
// ─────────────────────────────────────────
class _PersonalRecordsSection extends ConsumerWidget {
  const _PersonalRecordsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prsAsync = ref.watch(personalRecordsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏅', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Personal Records',
                style: GoogleFonts.rajdhani(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          prsAsync.when(
            data: (prs) {
              if (prs.isEmpty) {
                return Column(
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(
                      'No PRs yet',
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Complete a workout to see your records',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: prs.take(10).map((pr) => _PRRow(pr: pr)).toList(),
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
            error: (e, _) =>
                Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}

class _PRRow extends StatelessWidget {
  final PersonalRecord pr;
  const _PRRow({required this.pr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🏅', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pr.exerciseName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  DateFormat('d MMM yyyy').format(pr.achievedAt),
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${pr.weightKg}kg × ${pr.reps}',
                style: GoogleFonts.rajdhani(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
              Text(
                '1RM: ${pr.oneRepMax.toStringAsFixed(1)}kg',
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// WORKOUT CALENDAR HEATMAP
// ─────────────────────────────────────────
class _WorkoutCalendarSection extends ConsumerWidget {
  const _WorkoutCalendarSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build a 7-week heatmap (last 49 days)
    final now = DateTime.now();
    final days = List.generate(49, (i) {
      return now.subtract(Duration(days: 48 - i));
    });

    // For now, mark some sample days as active (in prod, query from DB)
    final activeDays = <String>{};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📅', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Workout Heatmap',
                style: GoogleFonts.rajdhani(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Last 7 weeks',
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),

          // Day labels
          Row(
            children: [
              SizedBox(
                width: 28,
                child: Column(
                  children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                      .map((d) => SizedBox(
                            height: 20,
                            child: Text(
                              d,
                              style: GoogleFonts.inter(
                                  fontSize: 9, color: AppColors.textMuted),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1,
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, i) {
                    final day = days[i];
                    final key =
                        '${day.year}-${day.month}-${day.day}';
                    final isActive = activeDays.contains(key);
                    final isToday = day.year == now.year &&
                        day.month == now.month &&
                        day.day == now.day;

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200 + i * 5),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : isToday
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(3),
                        border: isToday
                            ? Border.all(
                                color: AppColors.primary, width: 1.5)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textMuted)),
              const SizedBox(width: 4),
              ...List.generate(4, (i) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withValues(alpha: 0.2 + i * 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
              const SizedBox(width: 4),
              Text('More',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// RECENT SESSIONS
// ─────────────────────────────────────────
class _RecentSessionsSection extends ConsumerWidget {
  const _RecentSessionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Sessions',
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        historyAsync.when(
          data: (sessions) {
            if (sessions.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  children: [
                    const Text('🏋️', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(
                      'No workouts yet',
                      style: GoogleFonts.rajdhani(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Complete a session to see your history here',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: sessions.take(10).map((session) {
                final duration = session.durationMinutes;
                final volume = session.totalVolumeKg;
                final date = DateFormat('EEE, MMM d').format(session.startTime);
                final time = DateFormat('h:mm a').format(session.startTime);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('🏋️', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.workoutName,
                              style: GoogleFonts.rajdhani(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$date • $time',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${duration}m',
                            style: GoogleFonts.rajdhani(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${volume.toStringAsFixed(0)} kg',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (e, _) => Text(
            'Error loading sessions: $e',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
