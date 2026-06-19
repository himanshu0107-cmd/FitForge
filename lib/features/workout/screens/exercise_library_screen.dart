import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/core/constants/app_enums.dart';
import 'package:fitforge/domain/models/exercise.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Providers for search + filter state
final _searchQueryProvider = StateProvider<String>((ref) => '');
final _selectedMuscleProvider = StateProvider<MuscleGroup?>((ref) => null);
final _selectedEquipmentProvider = StateProvider<Equipment?>((ref) => null);

final _filteredExercisesProvider = Provider<AsyncValue<List<Exercise>>>((ref) {
  final exercisesAsync = ref.watch(exercisesProvider);
  final query = ref.watch(_searchQueryProvider).toLowerCase();
  final muscle = ref.watch(_selectedMuscleProvider);
  final equipment = ref.watch(_selectedEquipmentProvider);

  return exercisesAsync.whenData((exercises) {
    return exercises.where((e) {
      final matchesQuery = query.isEmpty ||
          e.name.toLowerCase().contains(query) ||
          e.description.toLowerCase().contains(query);
      final matchesMuscle =
          muscle == null || e.primaryMuscle == muscle;
      final matchesEquipment =
          equipment == null || e.equipment == equipment;
      return matchesQuery && matchesMuscle && matchesEquipment;
    }).toList();
  });
});

class ExerciseLibraryScreen extends ConsumerWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(_filteredExercisesProvider);
    final selectedMuscle = ref.watch(_selectedMuscleProvider);
    final selectedEquipment = ref.watch(_selectedEquipmentProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('Exercise Library',
            style: GoogleFonts.rajdhani(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) =>
                  ref.read(_searchQueryProvider.notifier).state = v,
              style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: ref.watch(_searchQueryProvider).isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.textMuted, size: 18),
                        onPressed: () =>
                            ref.read(_searchQueryProvider.notifier).state = '',
                      )
                    : null,
              ),
            ),
          ),

          // Muscle filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: selectedMuscle == null,
                  onTap: () =>
                      ref.read(_selectedMuscleProvider.notifier).state = null,
                ),
                ...MuscleGroup.values.map((m) => _FilterChip(
                      label: m.displayName,
                      isSelected: selectedMuscle == m,
                      onTap: () => ref
                          .read(_selectedMuscleProvider.notifier)
                          .state = m == selectedMuscle ? null : m,
                      color: _muscleColor(m),
                    )),
              ],
            ),
          ),

          // Equipment filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                _FilterChip(
                  label: 'Any Equipment',
                  isSelected: selectedEquipment == null,
                  onTap: () =>
                      ref.read(_selectedEquipmentProvider.notifier).state = null,
                  small: true,
                ),
                ...Equipment.values.map((e) => _FilterChip(
                      label: e.displayName,
                      isSelected: selectedEquipment == e,
                      onTap: () => ref
                          .read(_selectedEquipmentProvider.notifier)
                          .state = e == selectedEquipment ? null : e,
                      small: true,
                    )),
              ],
            ),
          ),

          // Exercise grid
          Expanded(
            child: filteredAsync.when(
              data: (exercises) {
                if (exercises.isEmpty) {
                  return const _EmptyState();
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: exercises.length,
                  itemBuilder: (context, i) => ExerciseCard(
                    exercise: exercises[i],
                    onTap: () =>
                        context.push('/home/exercises/${exercises[i].id}'),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text('Error: $e',
                    style:
                        const TextStyle(color: AppColors.textSecondary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _muscleColor(MuscleGroup m) {
  switch (m) {
    case MuscleGroup.chest:
      return AppColors.chest;
    case MuscleGroup.back:
      return AppColors.back;
    case MuscleGroup.legs:
      return AppColors.legs;
    case MuscleGroup.shoulders:
      return AppColors.shoulders;
    case MuscleGroup.arms:
      return AppColors.arms;
    case MuscleGroup.core:
      return AppColors.core;
    case MuscleGroup.cardio:
      return AppColors.cardio;
    case MuscleGroup.fullBody:
      return AppColors.accent;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final bool small;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(
            horizontal: small ? 10 : 14, vertical: small ? 5 : 7),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.2)
              : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.darkBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: small ? 11 : 12,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? activeColor : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muscleColor = _muscleColor(exercise.primaryMuscle);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  exercise.thumbnailUrl != null
                      ? CachedNetworkImage(
                          imageUrl: exercise.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: AppColors.darkSurface,
                            child: const Icon(Icons.image_outlined,
                                color: AppColors.textMuted),
                          ),
                          errorWidget: (_, __, ___) => _Placeholder(
                              muscle: exercise.primaryMuscle),
                        )
                      : _Placeholder(muscle: exercise.primaryMuscle),
                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppGradients.heroGradient,
                    ),
                  ),
                  // Equipment badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        exercise.equipment.displayName,
                        style: GoogleFonts.inter(
                            fontSize: 9, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: muscleColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      exercise.primaryMuscle.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: muscleColor,
                      ),
                    ),
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

class _Placeholder extends StatelessWidget {
  final MuscleGroup muscle;
  const _Placeholder({required this.muscle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _muscleColor(muscle).withOpacity(0.1),
      child: Center(
        child: Text(
          '💪',
          style: const TextStyle(fontSize: 36),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'No exercises found',
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
