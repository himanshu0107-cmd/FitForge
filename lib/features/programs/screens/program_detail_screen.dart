import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/domain/models/diet_and_progress.dart';
import 'package:fitforge/domain/models/workout.dart';

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
        body:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProgramDetailContent extends StatefulWidget {
  final TrainingProgram program;
  const _ProgramDetailContent({required this.program});

  @override
  State<_ProgramDetailContent> createState() => _ProgramDetailContentState();
}

class _ProgramDetailContentState extends State<_ProgramDetailContent> {
  int _selectedWeek = 0;
  int? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final program = widget.program;
    final weeks = program.weeks;
    final currentWeek = weeks.isNotEmpty ? weeks[_selectedWeek] : null;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.darkBackground,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.6),
                      AppColors.darkBackground,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          program.name,
                          style: GoogleFonts.rajdhani(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _HeaderBadge('${program.daysPerWeek}x/week'),
                            const SizedBox(width: 8),
                            _HeaderBadge('${program.durationWeeks} weeks'),
                            const SizedBox(width: 8),
                            _HeaderBadge(program.level.toUpperCase()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Description
                Text(
                  program.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // Week selector
                if (weeks.length > 1) ...[
                  Text(
                    'Select Week',
                    style: GoogleFonts.rajdhani(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weeks.length,
                      itemBuilder: (context, i) {
                        final isSelected = i == _selectedWeek;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedWeek = i;
                            _selectedDay = null;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.2)
                                  : AppColors.darkCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.darkBorder,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              'Wk ${weeks[i].weekNumber}',
                              style: GoogleFonts.rajdhani(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (currentWeek != null)
                    Text(
                      'Focus: ${currentWeek.focus}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // Days list
                if (currentWeek != null) ...[
                  Text(
                    'Training Days',
                    style: GoogleFonts.rajdhani(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...currentWeek.days.map((day) {
                    final isExpanded = _selectedDay == day.dayNumber;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            _selectedDay = isExpanded ? null : day.dayNumber;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isExpanded
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : AppColors.darkCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isExpanded
                                    ? AppColors.primary.withValues(alpha: 0.4)
                                    : AppColors.darkBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: day.isRestDay
                                        ? AppColors.darkSurface
                                        : AppColors.primary
                                            .withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.isRestDay ? '😴' : '${day.dayNumber}',
                                      style: GoogleFonts.rajdhani(
                                        fontSize: day.isRestDay ? 18 : 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
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
                                          color: day.isRestDay
                                              ? AppColors.textMuted
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (!day.isRestDay)
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
                                if (!day.isRestDay) ...[
                                  GestureDetector(
                                    onTap: () => context.push(
                                      AppRoutes.workoutSession,
                                      extra: {
                                        'workoutName': day.name,
                                        'exercises': day.exercises
                                            .map((e) => PlannedExercise(
                                                  exerciseId: e.exerciseId,
                                                  exerciseName: e.exerciseName,
                                                  sets: _parseSets(e.setsReps),
                                                  reps: _parseReps(e.setsReps),
                                                  restSeconds: e.restSeconds,
                                                  order: 0,
                                                ))
                                            .toList(),
                                        'planId': widget.program.id,
                                      },
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Start',
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Expanded exercises
                        if (isExpanded && !day.isRestDay)
                          Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.darkSurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.darkBorder),
                            ),
                            child: Column(
                              children: day.exercises
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${e.key + 1}',
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primary,
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
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            e.value.setsReps,
                                            style: GoogleFonts.rajdhani(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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
    );
  }

  int _parseSets(String setsReps) {
    // Parse "4x8" -> 4
    final parts = setsReps.split('x');
    if (parts.length >= 2) {
      return int.tryParse(parts[0].trim().replaceAll(RegExp(r'[^0-9]'), '')) ??
          3;
    }
    return 3;
  }

  int _parseReps(String setsReps) {
    // Parse "4x8" -> 8
    final parts = setsReps.split('x');
    if (parts.length >= 2) {
      return int.tryParse(parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '')) ??
          10;
    }
    return 10;
  }
}

class _HeaderBadge extends StatelessWidget {
  final String text;
  const _HeaderBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
