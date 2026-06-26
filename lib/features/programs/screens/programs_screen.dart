import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/domain/models/diet_and_progress.dart';

// ─────────────────────────────────────────
// PRESS SCALE HELPER
// ─────────────────────────────────────────
class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;
  const _PressScale({required this.child, required this.onTap, this.scale = 0.95});
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
    _scaleAnim = Tween<double>(begin: 1, end: widget.scale)
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
// PROGRAMS SCREEN
// ─────────────────────────────────────────
class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sliver App Bar ──
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.darkBackground,
            elevation: 0,
            expandedHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppShadows.glow(AppColors.primary, intensity: 0.5),
                    ),
                    child: const Center(
                      child: Text('🏆', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Programs',
                    style: GoogleFonts.rajdhani(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──
          programsAsync.when(
            data: (programs) {
              final activeId = activeProgramAsync.valueOrNull?.programId;
              final active = programs.where((p) => p.id == activeId).toList();
              final rest = programs.where((p) => p.id != activeId).toList();

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Active program hero (if any)
                    if (active.isNotEmpty) ...[
                      const _SectionLabel(label: 'ACTIVE PROGRAM'),
                      const SizedBox(height: 10),
                      _HeroProgramCard(
                        program: active.first,
                        onTap: () => context.push(
                          '/programs/${active.first.id}',
                          extra: active.first,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // All programs
                    _SectionLabel(
                      label: active.isEmpty ? 'ALL PROGRAMS' : 'MORE PROGRAMS',
                    ),
                    const SizedBox(height: 10),
                    ...rest.map((program) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ProgramCard(
                          program: program,
                          isActive: false,
                          onTap: () => context.push(
                            '/programs/${program.id}',
                            extra: program,
                          ),
                          onActivate: () async {
                            HapticFeedback.mediumImpact();
                            await ref
                                .read(activeProgramProvider.notifier)
                                .activate(program.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Text('🔥 '),
                                      Text(
                                        '${program.name} activated!',
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: _sportColor(program.sport),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }),

                    // Show active in the list too if no rest
                    if (rest.isEmpty && active.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('No programs yet',
                              style: TextStyle(color: AppColors.textMuted)),
                        ),
                      ),
                  ]),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $e',
                    style: const TextStyle(color: AppColors.textSecondary)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _sportColor(String sport) {
    switch (sport.toLowerCase()) {
      case 'gym': return AppColors.primary;
      case 'football': return AppColors.success;
      case 'boxing': return AppColors.error;
      case 'running': return AppColors.info;
      default: return AppColors.accent;
    }
  }
}

// ─────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

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
// HERO ACTIVE PROGRAM CARD
// ─────────────────────────────────────────
class _HeroProgramCard extends StatefulWidget {
  final TrainingProgram program;
  final VoidCallback onTap;
  const _HeroProgramCard({required this.program, required this.onTap});

  @override
  State<_HeroProgramCard> createState() => _HeroProgramCardState();
}

class _HeroProgramCardState extends State<_HeroProgramCard>
    with SingleTickerProviderStateMixin {
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
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: widget.onTap,
      scale: 0.97,
      child: AnimatedBuilder(
        animation: _shimCtrl,
        builder: (_, __) {
          return Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  _color.withValues(alpha: 0.55),
                  _color.withValues(alpha: 0.2),
                  AppColors.darkCard,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _color.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _color.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                // Sheen sweep
                Positioned.fill(
                  child: Transform.rotate(
                    angle: -math.pi / 6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.04 + 0.03 * math.sin(_shimCtrl.value * 2 * math.pi)),
                            Colors.transparent,
                          ],
                          stops: const [0.3, 0.5, 0.7],
                        ),
                      ),
                    ),
                  ),
                ),
                // Giant emoji BG
                Positioned(
                  right: -20,
                  top: -20,
                  child: Text(_emoji, style: const TextStyle(fontSize: 130)),
                ),
                // Active pill
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: _color.withValues(alpha: 0.4), blurRadius: 8),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'ACTIVE',
                          style: GoogleFonts.rajdhani(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.program.level.toUpperCase(),
                          style: GoogleFonts.rajdhani(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.program.name,
                        style: GoogleFonts.rajdhani(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _StatPill(
                            icon: FontAwesomeIcons.calendarDays,
                            label: '${widget.program.daysPerWeek}x/week',
                            color: _color,
                          ),
                          const SizedBox(width: 8),
                          _StatPill(
                            icon: FontAwesomeIcons.clock,
                            label: '${widget.program.durationWeeks} weeks',
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// STAT PILL
// ─────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final Color color;
  const _StatPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// PROGRAM CARD (non-active)
// ─────────────────────────────────────────
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
      case 'gym': return AppColors.primary;
      case 'football': return AppColors.success;
      case 'boxing': return AppColors.error;
      case 'running': return AppColors.info;
      default: return AppColors.accent;
    }
  }

  String get _sportEmoji {
    switch (program.sport.toLowerCase()) {
      case 'gym': return '🏋️';
      case 'football': return '⚽';
      case 'boxing': return '🥊';
      case 'running': return '🏃';
      default: return '⚡';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? _sportColor.withValues(alpha: 0.5)
                : AppColors.darkBorder,
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: _sportColor.withValues(alpha: 0.18),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _sportColor.withValues(alpha: 0.35),
                    _sportColor.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -16,
                    top: -16,
                    child: Text(
                      _sportEmoji,
                      style: const TextStyle(fontSize: 90),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Level badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            program.level.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          program.name,
                          style: GoogleFonts.rajdhani(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Stats
                      _ProgramStat(
                        icon: FontAwesomeIcons.calendarDays,
                        value: '${program.daysPerWeek}x/wk',
                        color: _sportColor,
                      ),
                      const SizedBox(width: 14),
                      _ProgramStat(
                        icon: FontAwesomeIcons.clock,
                        value: '${program.durationWeeks} wks',
                        color: AppColors.textMuted,
                      ),
                      const Spacer(),
                      // CTA button
                      if (!isActive && onActivate != null)
                        _PressScale(
                          onTap: onActivate!,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _sportColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _sportColor.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Activate',
                              style: GoogleFonts.rajdhani(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
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
                            color: _sportColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _sportColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'View Plan',
                            style: GoogleFonts.rajdhani(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
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

// ─────────────────────────────────────────
// PROGRAM STAT ROW ITEM
// ─────────────────────────────────────────
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
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 11, color: color),
        const SizedBox(width: 5),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
