import 'package:fitforge/core/constants/app_enums.dart';

class TdeeCalculator {
  /// Mifflin-St Jeor BMR formula
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == Gender.male ? base + 5 : base - 161;
  }

  /// Multiply BMR by activity multiplier
  static double calculateTDEE({
    required double bmr,
    required ActivityLevel activityLevel,
  }) {
    return bmr * activityLevel.multiplier;
  }

  /// Full calculation in one call — returns TDEE + macro breakdown
  static TdeeResult calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
    required FitnessGoal goal,
  }) {
    final bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
    );
    final tdee = calculateTDEE(bmr: bmr, activityLevel: activityLevel);

    // Adjust for goal
    final targetCalories = switch (goal) {
      FitnessGoal.muscleGain => tdee + 300,
      FitnessGoal.fatLoss => tdee - 500,
      FitnessGoal.sportSpecific => tdee + 100,
      FitnessGoal.endurance => tdee + 200,
    };

    // Macros: protein 2g/kg, fat 25% of target, rest carbs
    final proteinGrams = weightKg * 2.0;
    final proteinCals = proteinGrams * 4;
    final fatCals = targetCalories * 0.25;
    final fatGrams = fatCals / 9;
    final carbCals = targetCalories - proteinCals - fatCals;
    final carbGrams = carbCals / 4;

    return TdeeResult(
      bmr: bmr.round(),
      tdee: tdee.round(),
      targetCalories: targetCalories.round(),
      proteinGrams: proteinGrams.round(),
      carbGrams: carbGrams.clamp(0, 9999).round(),
      fatGrams: fatGrams.round(),
    );
  }
}

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extremelyActive,
}

extension ActivityLevelExtension on ActivityLevel {
  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extremelyActive:
        return 1.9;
    }
  }

  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary (desk job)';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active (1-3 days/wk)';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active (3-5 days/wk)';
      case ActivityLevel.veryActive:
        return 'Very Active (6-7 days/wk)';
      case ActivityLevel.extremelyActive:
        return 'Extremely Active (athlete)';
    }
  }
}

class TdeeResult {
  final int bmr;
  final int tdee;
  final int targetCalories;
  final int proteinGrams;
  final int carbGrams;
  final int fatGrams;

  const TdeeResult({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
  });
}
