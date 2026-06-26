import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/core/constants/app_enums.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Text(
          'Profile & Settings',
          style: GoogleFonts.rajdhani(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: profileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
          children: [
            // Avatar + Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        profile?.name.isNotEmpty == true
                            ? profile!.name[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.rajdhani(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile?.name ?? 'Athlete',
                    style: GoogleFonts.rajdhani(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    profile?.goal.displayName ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Body Stats
            const _SectionHeader(title: 'Body Stats', emoji: '⚖️'),
            const SizedBox(height: 12),
            if (profile != null)
              Row(
                children: [
                  Expanded(
                    child: _StatCard2(
                        label: 'Age', value: '${profile.age}', unit: 'yrs'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard2(
                        label: 'Weight',
                        value: profile.weightKg.toStringAsFixed(1),
                        unit: 'kg'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard2(
                        label: 'Height',
                        value: profile.heightCm.toStringAsFixed(0),
                        unit: 'cm'),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Goals
            const _SectionHeader(title: 'Targets', emoji: '🎯'),
            const SizedBox(height: 12),
            if (profile != null) ...[
              _TargetRow(
                icon: FontAwesomeIcons.fire,
                label: 'Daily Calories',
                value: '${profile.calorieGoal} kcal',
                color: AppColors.primary,
              ),
              _TargetRow(
                icon: FontAwesomeIcons.drumstickBite,
                label: 'Protein',
                value: '${profile.proteinGoal}g',
                color: AppColors.info,
              ),
              _TargetRow(
                icon: FontAwesomeIcons.wheatAwn,
                label: 'Carbohydrates',
                value: '${profile.carbGoal}g',
                color: AppColors.warning,
              ),
              _TargetRow(
                icon: FontAwesomeIcons.droplet,
                label: 'Fat',
                value: '${profile.fatGoal}g',
                color: AppColors.accent,
              ),
            ],

            const SizedBox(height: 24),

            // Sport
            const _SectionHeader(title: 'Training', emoji: '🏋️'),
            const SizedBox(height: 12),
            if (profile != null) ...[
              _SettingRow(
                icon: FontAwesomeIcons.personRunning,
                label: 'Sport',
                value:
                    '${profile.sportType.emoji} ${profile.sportType.displayName}',
              ),
              _SettingRow(
                icon: FontAwesomeIcons.bullseye,
                label: 'Goal',
                value: '${profile.goal.emoji} ${profile.goal.displayName}',
              ),
            ],

            const SizedBox(height: 24),

            // App Settings
            const _SectionHeader(title: 'App Settings', emoji: '⚙️'),
            const SizedBox(height: 12),

            // Dark mode toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                children: [
                  FaIcon(
                    isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Dark Mode',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Notifications toggle
            if (profile != null) ...[
              _SwitchRow(
                icon: FontAwesomeIcons.bell,
                label: 'Workout Reminders',
                value: profile.notificationsEnabled,
                onChanged: (v) {
                  ref.read(userProfileProvider.notifier).toggleWorkoutReminders(v);
                },
              ),
              if (profile.notificationsEnabled) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final timeParts = (profile.workoutReminderTime ?? '08:00').split(':');
                    final initialTime = TimeOfDay(
                      hour: int.tryParse(timeParts[0]) ?? 8,
                      minute: int.tryParse(timeParts[1]) ?? 0,
                    );
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppColors.primary,
                              onPrimary: Colors.black,
                              surface: AppColors.darkCard,
                              onSurface: AppColors.textPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                      await ref
                          .read(userProfileProvider.notifier)
                          .setWorkoutReminderTime(formattedTime);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.clock, color: AppColors.primary, size: 14),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Reminder Time',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          profile.workoutReminderTime ?? '08:00',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              _SwitchRow(
                icon: FontAwesomeIcons.droplet,
                label: 'Water Reminders',
                value: profile.waterReminderEnabled,
                onChanged: (v) {
                  ref.read(userProfileProvider.notifier).toggleWaterReminders(v);
                },
              ),
            ],

            const SizedBox(height: 24),

            // Version info
            Center(
              child: Text(
                'FitForge v1.0.0 — Built with ❤️ & Flutter',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String emoji;
  const _SectionHeader({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.rajdhani(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _StatCard2 extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatCard2({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.rajdhani(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style:
                GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _TargetRow extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;
  final Color color;

  const _TargetRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: FaIcon(icon, color: color, size: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: AppColors.textMuted, size: 14),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: AppColors.primary, size: 14),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
