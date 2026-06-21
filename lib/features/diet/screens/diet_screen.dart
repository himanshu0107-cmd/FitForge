import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/core/constants/app_enums.dart';
import 'package:fitforge/core/utils/tdee_calculator.dart';
import 'package:fitforge/domain/models/diet_and_progress.dart';

const _uuid = Uuid();

class DietScreen extends ConsumerStatefulWidget {
  const DietScreen({super.key});

  @override
  ConsumerState<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends ConsumerState<DietScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Text(
          'Diet & Nutrition',
          style: GoogleFonts.rajdhani(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Meal Plans'),
            Tab(text: 'Macros'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TodayTab(ref: ref),
          const _MealPlansTab(),
          _MacrosTab(ref: ref),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddFoodDialog(context, ref),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Log Food',
                style: GoogleFonts.rajdhani(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            )
          : null,
    );
  }

  void _showAddFoodDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final gramsCtrl = TextEditingController(text: '100');
    final calCtrl = TextEditingController();
    final proteinCtrl = TextEditingController(text: '0');
    final carbCtrl = TextEditingController(text: '0');
    final fatCtrl = TextEditingController(text: '0');
    MealType selectedType = MealType.lunch;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Food',
                  style: GoogleFonts.rajdhani(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Meal type selector
                Wrap(
                  spacing: 8,
                  children: MealType.values.map((t) {
                    final isSelected = t == selectedType;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedType = t),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.darkBorder,
                          ),
                        ),
                        child: Text(
                          '${t.emoji} ${t.displayName}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                _DialogField(
                    ctrl: nameCtrl,
                    label: 'Food Name',
                    hint: 'e.g. Chicken Breast'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _DialogField(
                            ctrl: gramsCtrl,
                            label: 'Grams',
                            hint: '100',
                            isNumber: true)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _DialogField(
                            ctrl: calCtrl,
                            label: 'Calories',
                            hint: '0',
                            isNumber: true)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _DialogField(
                            ctrl: proteinCtrl,
                            label: 'Protein (g)',
                            hint: '0',
                            isNumber: true)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _DialogField(
                            ctrl: carbCtrl,
                            label: 'Carbs (g)',
                            hint: '0',
                            isNumber: true)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _DialogField(
                            ctrl: fatCtrl,
                            label: 'Fat (g)',
                            hint: '0',
                            isNumber: true)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.trim().isEmpty) return;
                      ref.read(foodLogProvider.notifier).logFood(
                            FoodEntry(
                              id: _uuid.v4(),
                              foodName: nameCtrl.text.trim(),
                              grams: double.tryParse(gramsCtrl.text) ?? 100,
                              calories: int.tryParse(calCtrl.text) ?? 0,
                              proteinGrams:
                                  double.tryParse(proteinCtrl.text) ?? 0,
                              carbGrams: double.tryParse(carbCtrl.text) ?? 0,
                              fatGrams: double.tryParse(fatCtrl.text) ?? 0,
                              mealType: selectedType,
                              loggedAt: DateTime.now(),
                            ),
                          );
                      Navigator.pop(ctx);
                    },
                    child: Text('Save',
                        style: GoogleFonts.rajdhani(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TODAY TAB
// ─────────────────────────────────────────
class _TodayTab extends StatelessWidget {
  final WidgetRef ref;
  const _TodayTab({required this.ref});

  @override
  Widget build(BuildContext context) {
    final foodLogAsync = ref.watch(foodLogProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return foodLogAsync.when(
      data: (entries) {
        final totalCal = entries.fold(0, (s, e) => s + e.calories);
        final totalProtein = entries.fold(0.0, (s, e) => s + e.proteinGrams);
        final totalCarbs = entries.fold(0.0, (s, e) => s + e.carbGrams);
        final totalFat = entries.fold(0.0, (s, e) => s + e.fatGrams);

        final profile = profileAsync.value;
        final calGoal = profile?.calorieGoal ?? 2500;
        final proteinGoal = profile?.proteinGoal ?? 150;
        final carbGoal = profile?.carbGoal ?? 300;
        final fatGoal = profile?.fatGoal ?? 70;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            // Macro summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Calories',
                        style: GoogleFonts.rajdhani(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$totalCal / $calGoal kcal',
                        style: GoogleFonts.rajdhani(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: calGoal > 0
                          ? (totalCal / calGoal).clamp(0.0, 1.0)
                          : 0,
                      backgroundColor: AppColors.darkSurface,
                      color: totalCal > calGoal
                          ? AppColors.error
                          : AppColors.primary,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: _MacroBar(
                              label: 'Protein',
                              eaten: totalProtein.round(),
                              goal: proteinGoal,
                              unit: 'g',
                              color: AppColors.info)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _MacroBar(
                              label: 'Carbs',
                              eaten: totalCarbs.round(),
                              goal: carbGoal,
                              unit: 'g',
                              color: AppColors.warning)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _MacroBar(
                              label: 'Fat',
                              eaten: totalFat.round(),
                              goal: fatGoal,
                              unit: 'g',
                              color: AppColors.accent)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Food entries grouped by meal
            if (entries.isEmpty)
              _EmptyFoodLog()
            else ...[
              ...MealType.values.map((type) {
                final typeEntries =
                    entries.where((e) => e.mealType == type).toList();
                if (typeEntries.isEmpty) return const SizedBox();
                return _MealGroup(type: type, entries: typeEntries, ref: ref);
              }),
            ],
          ],
        );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final int eaten;
  final int goal;
  final String unit;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.eaten,
    required this.goal,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (eaten / goal).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.darkSurface,
            color: color,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '$eaten/$goal$unit',
          style: GoogleFonts.rajdhani(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MealGroup extends StatelessWidget {
  final MealType type;
  final List<FoodEntry> entries;
  final WidgetRef ref;

  const _MealGroup({
    required this.type,
    required this.entries,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final totalCal = entries.fold(0, (s, e) => s + e.calories);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(type.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                type.displayName,
                style: GoogleFonts.rajdhani(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$totalCal kcal',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        ...entries.map((e) => Dismissible(
              key: Key(e.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) =>
                  ref.read(foodLogProvider.notifier).deleteEntry(e.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.foodName,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              )),
                          Text(
                            '${e.grams.toStringAsFixed(0)}g • P:${e.proteinGrams.toStringAsFixed(0)}g C:${e.carbGrams.toStringAsFixed(0)}g F:${e.fatGrams.toStringAsFixed(0)}g',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${e.calories} kcal',
                      style: GoogleFonts.rajdhani(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _EmptyFoodLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'No food logged today',
            style: GoogleFonts.rajdhani(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to log your first meal',
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

// ─────────────────────────────────────────
// MEAL PLANS TAB
// ─────────────────────────────────────────
class _MealPlansTab extends ConsumerWidget {
  const _MealPlansTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(mealPlansProvider);

    return plansAsync.when(
      data: (plans) => ListView(
        padding: const EdgeInsets.all(20),
        children: plans.map((plan) => _MealPlanCard(plan: plan)).toList(),
      ),
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _MealPlanCard extends StatefulWidget {
  final MealPlan plan;
  const _MealPlanCard({required this.plan});

  @override
  State<_MealPlanCard> createState() => _MealPlanCardState();
}

class _MealPlanCardState extends State<_MealPlanCard> {
  bool _expanded = false;

  Color get _typeColor {
    switch (widget.plan.type) {
      case MealPlanType.bulking:
        return AppColors.success;
      case MealPlanType.cutting:
        return AppColors.error;
      case MealPlanType.maintenance:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: _typeColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          plan.type.displayName.toUpperCase(),
                          style: GoogleFonts.rajdhani(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _typeColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plan.name,
                    style: GoogleFonts.rajdhani(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _MiniMacro(
                          label: 'Cal',
                          value: '${plan.totalCalories}',
                          color: AppColors.primary),
                      const SizedBox(width: 12),
                      _MiniMacro(
                          label: 'Protein',
                          value: '${plan.proteinGrams}g',
                          color: AppColors.info),
                      const SizedBox(width: 12),
                      _MiniMacro(
                          label: 'Carbs',
                          value: '${plan.carbGrams}g',
                          color: AppColors.warning),
                      const SizedBox(width: 12),
                      _MiniMacro(
                          label: 'Fat',
                          value: '${plan.fatGrams}g',
                          color: AppColors.accent),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.darkBorder),
            ...plan.meals.map((meal) => _MealRow(meal: meal)),
          ],
        ],
      ),
    );
  }
}

class _MiniMacro extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniMacro(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
        Text(value,
            style: GoogleFonts.rajdhani(
                fontSize: 15, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _MealRow extends StatelessWidget {
  final DailyMeal meal;
  const _MealRow({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(meal.type.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                meal.name,
                style: GoogleFonts.rajdhani(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${meal.calories} kcal',
                style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...meal.ingredients.map((ing) => Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 2),
                child: Text(
                  '• ${ing.name} — ${ing.grams.toStringAsFixed(0)}g (${ing.calories} kcal)',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textMuted),
                ),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// MACROS TAB
// ─────────────────────────────────────────
class _MacrosTab extends StatelessWidget {
  final WidgetRef ref;
  const _MacrosTab({required this.ref});

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text('Complete onboarding first'));
        }

        final tdee = TdeeCalculator.calculate(
          weightKg: profile.weightKg,
          heightCm: profile.heightCm,
          age: profile.age,
          gender: profile.gender,
          activityLevel: ActivityLevel.moderatelyActive,
          goal: profile.goal,
        );

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _TdeeCard(tdee: tdee, profile: profile),
            const SizedBox(height: 20),
            _MacroPieCard(tdee: tdee),
            const SizedBox(height: 20),
            _MacroTips(goal: profile.goal),
          ],
        );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _TdeeCard extends StatelessWidget {
  final TdeeResult tdee;
  final profile;
  const _TdeeCard({required this.tdee, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.primaryCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your TDEE',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500)),
          Text(
            '${tdee.tdee} kcal/day',
            style: GoogleFonts.rajdhani(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Target: ${tdee.targetCalories} kcal (${profile.goal.displayName})',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TdeeMetric(label: 'BMR', value: '${tdee.bmr}', unit: 'kcal'),
              _TdeeMetric(
                  label: 'Protein', value: '${tdee.proteinGrams}', unit: 'g'),
              _TdeeMetric(
                  label: 'Carbs', value: '${tdee.carbGrams}', unit: 'g'),
              _TdeeMetric(label: 'Fat', value: '${tdee.fatGrams}', unit: 'g'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TdeeMetric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _TdeeMetric(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white60)),
        Text(
          value,
          style: GoogleFonts.rajdhani(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        Text(unit,
            style: GoogleFonts.inter(fontSize: 10, color: Colors.white60)),
      ],
    );
  }
}

class _MacroPieCard extends StatelessWidget {
  final TdeeResult tdee;
  const _MacroPieCard({required this.tdee});

  @override
  Widget build(BuildContext context) {
    final proteinCal = tdee.proteinGrams * 4;
    final carbCal = tdee.carbGrams * 4;
    final fatCal = tdee.fatGrams * 9;
    final total = proteinCal + carbCal + fatCal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macro Split',
            style: GoogleFonts.rajdhani(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _MacroSplitBar(
            label: 'Protein',
            grams: tdee.proteinGrams,
            percent: total > 0 ? (proteinCal / total * 100).round() : 0,
            color: AppColors.info,
          ),
          const SizedBox(height: 10),
          _MacroSplitBar(
            label: 'Carbs',
            grams: tdee.carbGrams,
            percent: total > 0 ? (carbCal / total * 100).round() : 0,
            color: AppColors.warning,
          ),
          const SizedBox(height: 10),
          _MacroSplitBar(
            label: 'Fat',
            grams: tdee.fatGrams,
            percent: total > 0 ? (fatCal / total * 100).round() : 0,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class _MacroSplitBar extends StatelessWidget {
  final String label;
  final int grams;
  final int percent;
  final Color color;

  const _MacroSplitBar({
    required this.label,
    required this.grams,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textSecondary)),
            const Spacer(),
            Text('${grams}g',
                style: GoogleFonts.rajdhani(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                )),
            const SizedBox(width: 8),
            Text('$percent%',
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100.0,
            backgroundColor: AppColors.darkSurface,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _MacroTips extends StatelessWidget {
  final FitnessGoal goal;
  const _MacroTips({required this.goal});

  @override
  Widget build(BuildContext context) {
    final tips = switch (goal) {
      FitnessGoal.muscleGain => [
          'Eat in a ~300kcal surplus for lean gains',
          'Prioritise protein at 2g/kg bodyweight',
          'Time carbs around workouts for energy',
          'Don\'t fear fats — they support hormones',
        ],
      FitnessGoal.fatLoss => [
          'Maintain a moderate 500kcal deficit',
          'High protein preserves muscle on a cut',
          'Prioritise whole foods for satiety',
          'Don\'t drop calories too fast — lose fat not muscle',
        ],
      FitnessGoal.endurance => [
          'Carbs are king for endurance performance',
          'Increase carb intake on long training days',
          'Protein aids recovery between sessions',
          'Hydration is as important as macros',
        ],
      FitnessGoal.sportSpecific => [
          'Periodise nutrition around training cycles',
          'High carbs on intense training days',
          'Focus on recovery nutrition post-workout',
          'Maintain adequate protein year-round',
        ],
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Nutrition Tips',
                style: GoogleFonts.rajdhani(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 5, right: 10),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final bool isNumber;

  const _DialogField({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
