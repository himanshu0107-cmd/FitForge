import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/core/constants/app_enums.dart';
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/core/providers/app_providers.dart';
import 'package:fitforge/core/utils/tdee_calculator.dart';
import 'package:fitforge/domain/models/user_profile.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Step 1
  final _nameController = TextEditingController();
  FitnessGoal _selectedGoal = FitnessGoal.muscleGain;

  // Step 2
  final _ageController = TextEditingController(text: '25');
  final _weightController = TextEditingController(text: '75');
  final _heightController = TextEditingController(text: '175');
  Gender _selectedGender = Gender.male;

  // Step 3
  SportType _selectedSport = SportType.gym;

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _ageController.text.isNotEmpty &&
            _weightController.text.isNotEmpty &&
            _heightController.text.isNotEmpty;
      case 2:
        return true;
    }
    return true;
  }

  Future<void> _complete() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final age = int.tryParse(_ageController.text) ?? 25;
    final weight = double.tryParse(_weightController.text) ?? 75.0;
    final height = double.tryParse(_heightController.text) ?? 175.0;

    final tdeeResult = TdeeCalculator.calculate(
      weightKg: weight,
      heightCm: height,
      age: age,
      gender: _selectedGender,
      activityLevel: ActivityLevel.moderatelyActive,
      goal: _selectedGoal,
    );

    final profile = UserProfile(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      age: age,
      weightKg: weight,
      heightCm: height,
      gender: _selectedGender,
      goal: _selectedGoal,
      sportType: _selectedSport,
      calorieGoal: tdeeResult.targetCalories,
      proteinGoal: tdeeResult.proteinGrams,
      carbGoal: tdeeResult.carbGrams,
      fatGoal: tdeeResult.fatGrams,
      createdAt: DateTime.now(),
    );

    await ref.read(userProfileProvider.notifier).saveProfile(profile);

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: List.generate(3, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: i <= _currentPage
                            ? AppColors.primary
                            : AppColors.darkBorder,
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _Step1(
                    nameController: _nameController,
                    selectedGoal: _selectedGoal,
                    onGoalChanged: (g) => setState(() => _selectedGoal = g),
                  ),
                  _Step2(
                    ageController: _ageController,
                    weightController: _weightController,
                    heightController: _heightController,
                    selectedGender: _selectedGender,
                    onGenderChanged: (g) => setState(() => _selectedGender = g),
                  ),
                  _Step3(
                    selectedSport: _selectedSport,
                    onSportChanged: (s) => setState(() => _selectedSport = s),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canProceed ? _next : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _currentPage == 2
                                  ? "Let's Forge! 🔥"
                                  : 'Continue',
                              style: GoogleFonts.rajdhani(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                  if (_currentPage > 0) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.inter(color: AppColors.textMuted),
                      ),
                    ),
                  ],
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
// STEP 1: Name + Goal
// ─────────────────────────────────────────
class _Step1 extends StatelessWidget {
  final TextEditingController nameController;
  final FitnessGoal selectedGoal;
  final ValueChanged<FitnessGoal> onGoalChanged;

  const _Step1({
    required this.nameController,
    required this.selectedGoal,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Welcome to\nFitForge 🔥',
            style: GoogleFonts.rajdhani(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Let's personalise your training experience",
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 36),
          Text(
            'Your Name',
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            style: GoogleFonts.inter(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. Alex',
              prefixIcon:
                  const Icon(Icons.person_outline, color: AppColors.textMuted),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 32),
          Text(
            'Your Goal',
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...FitnessGoal.values.map((goal) {
            final isSelected = goal == selectedGoal;
            return GestureDetector(
              onTap: () => onGoalChanged(goal),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.darkCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.darkBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(goal.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        goal.displayName,
                        style: GoogleFonts.rajdhani(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// STEP 2: Body Stats
// ─────────────────────────────────────────
class _Step2 extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final Gender selectedGender;
  final ValueChanged<Gender> onGenderChanged;

  const _Step2({
    required this.ageController,
    required this.weightController,
    required this.heightController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Your Body Stats',
            style: GoogleFonts.rajdhani(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Used to calculate your personalised calorie & macro targets',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Gender
          Text(
            'Gender',
            style: GoogleFonts.rajdhani(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            children: Gender.values.map((g) {
              final isSelected = g == selectedGender;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onGenderChanged(g),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: g != Gender.other ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.darkBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        g.displayName,
                        style: GoogleFonts.rajdhani(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatField(
                  controller: ageController,
                  label: 'Age',
                  suffix: 'yrs',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatField(
                  controller: weightController,
                  label: 'Weight',
                  suffix: 'kg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StatField(
            controller: heightController,
            label: 'Height',
            suffix: 'cm',
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We use the Mifflin-St Jeor formula to calculate your personalised TDEE and macro targets.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
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

class _StatField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;

  const _StatField({
    required this.controller,
    required this.label,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.rajdhani(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle:
                GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// STEP 3: Sport Type
// ─────────────────────────────────────────
class _Step3 extends StatelessWidget {
  final SportType selectedSport;
  final ValueChanged<SportType> onSportChanged;

  const _Step3({
    required this.selectedSport,
    required this.onSportChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Your Sport',
            style: GoogleFonts.rajdhani(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We will tailor your workouts and programs accordingly',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: SportType.values.map((sport) {
              final isSelected = sport == selectedSport;
              return GestureDetector(
                onTap: () => onSportChanged(sport),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.darkBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(sport.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(
                        sport.displayName,
                        style: GoogleFonts.rajdhani(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
