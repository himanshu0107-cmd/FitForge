import 'package:fitforge/core/constants/app_enums.dart';

class MealPlan {
  final String id;
  final String name;
  final MealPlanType type;
  final int totalCalories;
  final int proteinGrams;
  final int carbGrams;
  final int fatGrams;
  final List<DailyMeal> meals;
  final String description;

  const MealPlan({
    required this.id,
    required this.name,
    required this.type,
    required this.totalCalories,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
    required this.meals,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'totalCalories': totalCalories,
        'proteinGrams': proteinGrams,
        'carbGrams': carbGrams,
        'fatGrams': fatGrams,
        'meals': meals.map((m) => m.toJson()).toList(),
        'description': description,
      };

  factory MealPlan.fromJson(Map<String, dynamic> json) => MealPlan(
        id: json['id'] as String,
        name: json['name'] as String,
        type: MealPlanType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => MealPlanType.maintenance,
        ),
        totalCalories: json['totalCalories'] as int,
        proteinGrams: json['proteinGrams'] as int,
        carbGrams: json['carbGrams'] as int,
        fatGrams: json['fatGrams'] as int,
        meals: (json['meals'] as List<dynamic>? ?? [])
            .map((m) => DailyMeal.fromJson(m as Map<String, dynamic>))
            .toList(),
        description: json['description'] as String? ?? '',
      );
}

enum MealPlanType { bulking, cutting, maintenance }

extension MealPlanTypeExtension on MealPlanType {
  String get displayName {
    switch (this) {
      case MealPlanType.bulking:
        return 'Bulking';
      case MealPlanType.cutting:
        return 'Cutting';
      case MealPlanType.maintenance:
        return 'Maintenance';
    }
  }
}

class DailyMeal {
  final String id;
  final String name;
  final MealType type;
  final int calories;
  final int proteinGrams;
  final int carbGrams;
  final int fatGrams;
  final List<MealIngredient> ingredients;
  final String time; // e.g. "07:30"

  const DailyMeal({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
    required this.ingredients,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'calories': calories,
        'proteinGrams': proteinGrams,
        'carbGrams': carbGrams,
        'fatGrams': fatGrams,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'time': time,
      };

  factory DailyMeal.fromJson(Map<String, dynamic> json) => DailyMeal(
        id: json['id'] as String,
        name: json['name'] as String,
        type: MealType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => MealType.breakfast,
        ),
        calories: json['calories'] as int,
        proteinGrams: json['proteinGrams'] as int,
        carbGrams: json['carbGrams'] as int,
        fatGrams: json['fatGrams'] as int,
        ingredients: (json['ingredients'] as List<dynamic>? ?? [])
            .map((i) => MealIngredient.fromJson(i as Map<String, dynamic>))
            .toList(),
        time: json['time'] as String,
      );
}

class MealIngredient {
  final String name;
  final double grams;
  final int calories;
  final double proteinGrams;
  final double carbGrams;
  final double fatGrams;

  const MealIngredient({
    required this.name,
    required this.grams,
    required this.calories,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'grams': grams,
        'calories': calories,
        'proteinGrams': proteinGrams,
        'carbGrams': carbGrams,
        'fatGrams': fatGrams,
      };

  factory MealIngredient.fromJson(Map<String, dynamic> json) => MealIngredient(
        name: json['name'] as String,
        grams: (json['grams'] as num).toDouble(),
        calories: json['calories'] as int,
        proteinGrams: (json['proteinGrams'] as num).toDouble(),
        carbGrams: (json['carbGrams'] as num).toDouble(),
        fatGrams: (json['fatGrams'] as num).toDouble(),
      );
}

class FoodLog {
  final String id;
  final String foodName;
  final double grams;
  final int calories;
  final double proteinGrams;
  final double carbGrams;
  final double fatGrams;
  final MealType mealType;
  final DateTime loggedAt;

  const FoodLog({
    required this.id,
    required this.foodName,
    required this.grams,
    required this.calories,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
    required this.mealType,
    required this.loggedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'foodName': foodName,
        'grams': grams,
        'calories': calories,
        'proteinGrams': proteinGrams,
        'carbGrams': carbGrams,
        'fatGrams': fatGrams,
        'mealType': mealType.name,
        'loggedAt': loggedAt.toIso8601String(),
      };

  factory FoodLog.fromJson(Map<String, dynamic> json) => FoodLog(
        id: json['id'] as String,
        foodName: json['foodName'] as String,
        grams: (json['grams'] as num).toDouble(),
        calories: json['calories'] as int,
        proteinGrams: (json['proteinGrams'] as num).toDouble(),
        carbGrams: (json['carbGrams'] as num).toDouble(),
        fatGrams: (json['fatGrams'] as num).toDouble(),
        mealType: MealType.values.firstWhere(
          (t) => t.name == json['mealType'],
          orElse: () => MealType.snack,
        ),
        loggedAt: DateTime.parse(json['loggedAt'] as String),
      );
}

typedef FoodEntry = FoodLog;

class WeightLog {
  final String id;
  final double weightKg;
  final DateTime loggedAt;
  final String? notes;

  const WeightLog({
    required this.id,
    required this.weightKg,
    required this.loggedAt,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'weightKg': weightKg,
        'loggedAt': loggedAt.toIso8601String(),
        'notes': notes,
      };

  factory WeightLog.fromJson(Map<String, dynamic> json) => WeightLog(
        id: json['id'] as String,
        weightKg: (json['weightKg'] as num).toDouble(),
        loggedAt: DateTime.parse(json['loggedAt'] as String),
        notes: json['notes'] as String?,
      );
}

class TrainingProgram {
  final String id;
  final String name;
  final String description;
  final String sport;
  final int daysPerWeek;
  final int durationWeeks;
  final String level; // beginner, intermediate, advanced
  final List<ProgramWeek> weeks;
  final String? thumbnailUrl;

  const TrainingProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.daysPerWeek,
    required this.durationWeeks,
    required this.level,
    required this.weeks,
    this.thumbnailUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'sport': sport,
        'daysPerWeek': daysPerWeek,
        'durationWeeks': durationWeeks,
        'level': level,
        'weeks': weeks.map((w) => w.toJson()).toList(),
        'thumbnailUrl': thumbnailUrl,
      };

  factory TrainingProgram.fromJson(Map<String, dynamic> json) => TrainingProgram(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        sport: json['sport'] as String,
        daysPerWeek: json['daysPerWeek'] as int,
        durationWeeks: json['durationWeeks'] as int,
        level: json['level'] as String,
        weeks: (json['weeks'] as List<dynamic>? ?? [])
            .map((w) => ProgramWeek.fromJson(w as Map<String, dynamic>))
            .toList(),
        thumbnailUrl: json['thumbnailUrl'] as String?,
      );
}

class ProgramWeek {
  final int weekNumber;
  final String focus;
  final List<ProgramDay> days;

  const ProgramWeek({
    required this.weekNumber,
    required this.focus,
    required this.days,
  });

  Map<String, dynamic> toJson() => {
        'weekNumber': weekNumber,
        'focus': focus,
        'days': days.map((d) => d.toJson()).toList(),
      };

  factory ProgramWeek.fromJson(Map<String, dynamic> json) => ProgramWeek(
        weekNumber: json['weekNumber'] as int,
        focus: json['focus'] as String,
        days: (json['days'] as List<dynamic>? ?? [])
            .map((d) => ProgramDay.fromJson(d as Map<String, dynamic>))
            .toList(),
      );
}

class ProgramDay {
  final int dayNumber;
  final String name;
  final bool isRestDay;
  final List<PlannedProgramExercise> exercises;
  final String? notes;

  const ProgramDay({
    required this.dayNumber,
    required this.name,
    this.isRestDay = false,
    this.exercises = const [],
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'name': name,
        'isRestDay': isRestDay,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'notes': notes,
      };

  factory ProgramDay.fromJson(Map<String, dynamic> json) => ProgramDay(
        dayNumber: json['dayNumber'] as int,
        name: json['name'] as String,
        isRestDay: json['isRestDay'] as bool? ?? false,
        exercises: (json['exercises'] as List<dynamic>? ?? [])
            .map((e) =>
                PlannedProgramExercise.fromJson(e as Map<String, dynamic>))
            .toList(),
        notes: json['notes'] as String?,
      );
}

class PlannedProgramExercise {
  final String exerciseId;
  final String exerciseName;
  final String setsReps; // e.g. "4x8", "3x12", "20min"
  final int restSeconds;
  final String? notes;

  const PlannedProgramExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.setsReps,
    this.restSeconds = 90,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'setsReps': setsReps,
        'restSeconds': restSeconds,
        'notes': notes,
      };

  factory PlannedProgramExercise.fromJson(Map<String, dynamic> json) =>
      PlannedProgramExercise(
        exerciseId: json['exerciseId'] as String,
        exerciseName: json['exerciseName'] as String,
        setsReps: json['setsReps'] as String,
        restSeconds: json['restSeconds'] as int? ?? 90,
        notes: json['notes'] as String?,
      );
}
