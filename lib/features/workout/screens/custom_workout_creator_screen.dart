import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/domain/models/workout.dart';
import 'package:fitforge/domain/models/exercise.dart';
import 'package:fitforge/core/constants/app_enums.dart';
import 'package:uuid/uuid.dart';

class CustomWorkoutCreatorScreen extends ConsumerStatefulWidget {
  final WorkoutPlan? workoutPlan;

  const CustomWorkoutCreatorScreen({super.key, this.workoutPlan});

  @override
  ConsumerState<CustomWorkoutCreatorScreen> createState() =>
      _CustomWorkoutCreatorScreenState();
}

class _CustomWorkoutCreatorScreenState
    extends ConsumerState<CustomWorkoutCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  final List<PlannedExercise> _exercises = [];
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.workoutPlan?.name ?? '');
    _descController =
        TextEditingController(text: widget.workoutPlan?.description ?? '');

    if (widget.workoutPlan != null && widget.workoutPlan!.days.isNotEmpty) {
      _exercises.addAll(widget.workoutPlan!.days.first.exercises);
      _exercises.sort((a, b) => a.order.compareTo(b.order));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addPlannedExercise(Exercise exercise) {
    setState(() {
      _exercises.add(
        PlannedExercise(
          exerciseId: exercise.id,
          exerciseName: exercise.name,
          sets: exercise.defaultSets,
          reps: exercise.defaultReps,
          restSeconds: exercise.defaultRestSeconds,
          order: _exercises.length,
        ),
      );
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
      // Re-assign orders
      for (int i = 0; i < _exercises.length; i++) {
        _exercises[i] = _exercises[i].copyWith(order: i);
      }
    });
  }

  void _updateSets(int index, int delta) {
    setState(() {
      final current = _exercises[index];
      final newSets = (current.sets + delta).clamp(1, 10);
      _exercises[index] = current.copyWith(sets: newSets);
    });
  }

  void _updateReps(int index, int delta) {
    setState(() {
      final current = _exercises[index];
      final newReps = (current.reps + delta).clamp(1, 100);
      _exercises[index] = current.copyWith(reps: newReps);
    });
  }

  void _updateRest(int index, int restSeconds) {
    setState(() {
      _exercises[index] = _exercises[index].copyWith(restSeconds: restSeconds);
    });
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _exercises.removeAt(oldIndex);
      _exercises.insert(newIndex, item);

      // Re-assign orders
      for (int i = 0; i < _exercises.length; i++) {
        _exercises[i] = _exercises[i].copyWith(order: i);
      }
    });
  }

  void _showExercisePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ExercisePickerSheet(
        onSelect: _addPlannedExercise,
        selectedIds: _exercises.map((e) => e.exerciseId).toSet(),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please add at least one exercise to your routine.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final isEdit = widget.workoutPlan != null;
    final plan = WorkoutPlan(
      id: widget.workoutPlan?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      isTemplate: true,
      days: [
        WorkoutDay(
          id: widget.workoutPlan?.days.first.id ?? _uuid.v4(),
          name: _nameController.text.trim(),
          dayNumber: 1,
          exercises: _exercises,
        ),
      ],
    );

    await ref.read(customWorkoutsProvider.notifier).saveWorkout(plan);

    if (mounted) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? 'Workout updated successfully!' : 'Workout created successfully!',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.workoutPlan != null;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.chevronLeft,
              color: AppColors.textPrimary, size: 16),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEdit ? 'Edit Custom Routine' : 'Create Custom Routine',
          style: GoogleFonts.rajdhani(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Save',
              style: GoogleFonts.rajdhani(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Meta Info fields
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Name textfield
                        TextFormField(
                          controller: _nameController,
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Routine Name',
                            labelStyle: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                            floatingLabelStyle: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: AppColors.darkBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: AppColors.error),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: AppColors.error, width: 1.5),
                            ),
                            fillColor: AppColors.darkCard,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter a name for the workout';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Description textfield
                        TextFormField(
                          controller: _descController,
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Description (optional)',
                            alignLabelWithHint: true,
                            labelStyle: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                            floatingLabelStyle: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: AppColors.darkBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                            fillColor: AppColors.darkCard,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Text(
                              'EXERCISES (${_exercises.length})',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMuted,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            if (_exercises.isNotEmpty)
                              Text(
                                'Drag to reorder',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ]),
                    ),
                  ),

                  // Exercises list
                  if (_exercises.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.darkCard,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.darkBorder),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.dumbbell,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Exercises Added Yet',
                            style: GoogleFonts.rajdhani(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap the button below to build your routine.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverReorderableList(
                        itemCount: _exercises.length,
                        // ignore: deprecated_member_use
                        onReorder: _reorder,
                        itemBuilder: (context, idx) {
                          final item = _exercises[idx];
                          return ReorderableDragStartListener(
                            key: ValueKey(item.exerciseId + idx.toString()),
                            index: idx,
                            child: _ExercisePlanningCard(
                              planned: item,
                              index: idx,
                              onDelete: () => _removeExercise(idx),
                              onUpdateSets: (d) => _updateSets(idx, d),
                              onUpdateReps: (d) => _updateReps(idx, d),
                              onUpdateRest: (s) => _updateRest(idx, s),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Bottom controls
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF131224),
                border: Border(
                  top: BorderSide(color: AppColors.darkBorder),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _showExercisePicker,
                        icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                        label: Text(
                          'Add Exercise',
                          style: GoogleFonts.rajdhani(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.glow(AppColors.primary, intensity: 0.4),
                      ),
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isEdit ? 'Update Routine' : 'Save Routine',
                          style: GoogleFonts.rajdhani(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

// ─────────────────────────────────────────
// EXERCISE PLANNING CARD WIDGET
// ─────────────────────────────────────────
class _ExercisePlanningCard extends StatelessWidget {
  final PlannedExercise planned;
  final int index;
  final VoidCallback onDelete;
  final Function(int) onUpdateSets;
  final Function(int) onUpdateReps;
  final Function(int) onUpdateRest;

  const _ExercisePlanningCard({
    required this.planned,
    required this.index,
    required this.onDelete,
    required this.onUpdateSets,
    required this.onUpdateReps,
    required this.onUpdateRest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: [
          // Header row with exercise name & drag/delete
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
            child: Row(
              children: [
                // Number label
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Name
                Expanded(
                  child: Text(
                    planned.exerciseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Delete button
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trashCan,
                      color: AppColors.error, size: 14),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDelete,
                ),
                const SizedBox(width: 8),

                // Drag handle hint icon
                const FaIcon(
                  FontAwesomeIcons.bars,
                  color: AppColors.textMuted,
                  size: 14,
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.darkBorder, height: 1),

          // Adjusters row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Sets Counter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SETS',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _CounterButton(
                            icon: Icons.remove,
                            onTap: () => onUpdateSets(-1),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '${planned.sets}',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          _CounterButton(
                            icon: Icons.add,
                            onTap: () => onUpdateSets(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Reps Counter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REPS',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _CounterButton(
                            icon: Icons.remove,
                            onTap: () => onUpdateReps(-1),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '${planned.reps}',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          _CounterButton(
                            icon: Icons.add,
                            onTap: () => onUpdateReps(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Rest settings row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                Text(
                  'REST TIME',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: [30, 60, 90, 120, 180].map((sec) {
                      final active = planned.restSeconds == sec;
                      return GestureDetector(
                        onTap: () => onUpdateRest(sec),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary
                                : AppColors.darkBorder.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.darkBorder,
                            ),
                          ),
                          child: Text(
                            '${sec}s',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: active ? FontWeight.bold : FontWeight.normal,
                              color: active ? Colors.black : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
// COUNTER BUTTON
// ─────────────────────────────────────────
class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.darkBorder.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// EXERCISE SELECTOR SHEET
// ─────────────────────────────────────────
class _ExercisePickerSheet extends ConsumerStatefulWidget {
  final Function(Exercise) onSelect;
  final Set<String> selectedIds;

  const _ExercisePickerSheet({required this.onSelect, required this.selectedIds});

  @override
  ConsumerState<_ExercisePickerSheet> createState() =>
      __ExercisePickerSheetState();
}

class __ExercisePickerSheetState extends ConsumerState<_ExercisePickerSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppColors.darkBorder),
            ),
          ),
          child: Column(
            children: [
              // Pull bar
              const SizedBox(height: 10),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.darkBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Select Exercise',
                      style: GoogleFonts.rajdhani(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.xmark,
                          color: AppColors.textMuted, size: 16),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextField(
                  style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search exercises...',
                    hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                    fillColor: AppColors.darkCard,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.darkBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (v) => setState(() => _search = v.toLowerCase()),
                ),
              ),

              const Divider(color: AppColors.darkBorder, height: 1),

              // Exercises List
              Expanded(
                child: exercisesAsync.when(
                  data: (list) {
                    final filtered = list.where((ex) {
                      return ex.name.toLowerCase().contains(_search) ||
                          ex.primaryMuscle.displayName
                              .toLowerCase()
                              .contains(_search);
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'No exercises found.',
                          style: GoogleFonts.inter(color: AppColors.textMuted),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, idx) {
                        final ex = filtered[idx];
                        final isAlreadyAdded = widget.selectedIds.contains(ex.id);

                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          title: Text(
                            ex.name,
                            style: GoogleFonts.rajdhani(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isAlreadyAdded
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            ex.primaryMuscle.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                          trailing: isAlreadyAdded
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkBorder,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Added',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: AppColors.primary,
                                    size: 10,
                                  ),
                                ),
                          onTap: isAlreadyAdded
                              ? null
                              : () {
                                  HapticFeedback.lightImpact();
                                  widget.onSelect(ex);
                                  Navigator.pop(context);
                                },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (e, _) => Center(
                    child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
