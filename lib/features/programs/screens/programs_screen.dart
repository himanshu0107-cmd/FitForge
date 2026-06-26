import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/domain/models/diet_and_progress.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Text(
          'Training Programs',
          style: GoogleFonts.rajdhani(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: programsAsync.when(
        data: (programs) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
          itemCount: programs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            final isActive = activeProgramAsync.valueOrNull?.programId == programs[i].id;
            return ProgramCard(
              program: programs[i],
              isActive: isActive,
              onTap: () => context.push('/programs/${programs[i].id}', extra: programs[i]),
              onActivate: () async {
                await ref.read(activeProgramProvider.notifier).activate(programs[i].id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${programs[i].name} set as active program! 🔥'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            );
          },
        ),
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Text('Error loading programs: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class ProgramCard extends StatelessWidget {
  final TrainingProgram program;
  final VoidCallback onTap;
  final bool isActive;
  final VoidCallback? onActivate;

  const ProgramCard({
    super.key,
    required this.program,
    required this.onTap,
    this.isActive = false,
    this.onActivate,
  });

  Color get _sportColor {
    switch (program.sport.toLowerCase()) {
      case 'gym':
        return AppColors.primary;
      case 'football':
        return AppColors.success;
      case 'boxing':
        return AppColors.error;
      case 'running':
        return AppColors.info;
      default:
        return AppColors.accent;
    }
  }

  String get _sportEmoji {
    switch (program.sport.toLowerCase()) {
      case 'gym':
        return '🏋️';
      case 'football':
        return '⚽';
      case 'boxing':
        return '🥊';
      case 'running':
        return '🏃';
      default:
        return '⚡';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? _sportColor : AppColors.darkBorder,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: _sportColor.withValues(alpha: 0.2),
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header gradient
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _sportColor.withValues(alpha: 0.4),
                    _sportColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Text(
                      _sportEmoji,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  if (isActive)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _sportColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow,
                                size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'ACTIVE',
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
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            program.level.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          program.name,
                          style: GoogleFonts.rajdhani(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Stats row
                  Row(
                    children: [
                      _ProgramStat(
                        icon: FontAwesomeIcons.calendarDays,
                        value: '${program.daysPerWeek}x/wk',
                        color: _sportColor,
                      ),
                      const SizedBox(width: 16),
                      _ProgramStat(
                        icon: FontAwesomeIcons.clock,
                        value: '${program.durationWeeks} weeks',
                        color: AppColors.textSecondary,
                      ),
                      const Spacer(),
                      if (!isActive && onActivate != null)
                        GestureDetector(
                          onTap: onActivate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: _sportColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _sportColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'Activate',
                              style: GoogleFonts.rajdhani(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _sportColor,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _sportColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: _sportColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'View Plan',
                            style: GoogleFonts.rajdhani(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _sportColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramStat extends StatelessWidget {
  final FaIconData icon;
  final String value;
  final Color color;

  const _ProgramStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 12, color: color),
        const SizedBox(width: 5),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
