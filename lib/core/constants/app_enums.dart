enum Gender { male, female, other }

enum FitnessGoal {
  muscleGain,
  fatLoss,
  sportSpecific,
  endurance,
}

enum SportType {
  gym,
  football,
  cricket,
  boxing,
  running,
  cycling,
  mma,
}

enum MuscleGroup {
  chest,
  back,
  legs,
  shoulders,
  arms,
  core,
  cardio,
  fullBody,
}

enum Equipment {
  barbell,
  dumbbell,
  cable,
  machine,
  bodyweight,
  kettlebell,
  resistanceBand,
  pullupBar,
  bench,
  none,
}

enum MealType {
  breakfast,
  midMorning,
  lunch,
  preWorkout,
  dinner,
  snack,
}

enum ProgramType {
  gym,
  football,
  boxing,
  running,
  cycling,
  mma,
  crossfit,
}

enum TimerMode {
  rest,
  hiit,
  tabata,
  stopwatch,
}

enum TimerPhase {
  work,
  rest,
  idle,
}

// Extensions for display strings
extension FitnessGoalExtension on FitnessGoal {
  String get displayName {
    switch (this) {
      case FitnessGoal.muscleGain:
        return 'Muscle Gain';
      case FitnessGoal.fatLoss:
        return 'Fat Loss';
      case FitnessGoal.sportSpecific:
        return 'Sport-Specific';
      case FitnessGoal.endurance:
        return 'Endurance';
    }
  }

  String get emoji {
    switch (this) {
      case FitnessGoal.muscleGain:
        return '💪';
      case FitnessGoal.fatLoss:
        return '🔥';
      case FitnessGoal.sportSpecific:
        return '⚽';
      case FitnessGoal.endurance:
        return '🏃';
    }
  }
}

extension SportTypeExtension on SportType {
  String get displayName {
    switch (this) {
      case SportType.gym:
        return 'Gym';
      case SportType.football:
        return 'Football';
      case SportType.cricket:
        return 'Cricket';
      case SportType.boxing:
        return 'Boxing';
      case SportType.running:
        return 'Running';
      case SportType.cycling:
        return 'Cycling';
      case SportType.mma:
        return 'MMA';
    }
  }

  String get emoji {
    switch (this) {
      case SportType.gym:
        return '🏋️';
      case SportType.football:
        return '⚽';
      case SportType.cricket:
        return '🏏';
      case SportType.boxing:
        return '🥊';
      case SportType.running:
        return '🏃';
      case SportType.cycling:
        return '🚴';
      case SportType.mma:
        return '🥋';
    }
  }
}

extension MuscleGroupExtension on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.arms:
        return 'Arms';
      case MuscleGroup.core:
        return 'Core';
      case MuscleGroup.cardio:
        return 'Cardio';
      case MuscleGroup.fullBody:
        return 'Full Body';
    }
  }
}

extension EquipmentExtension on Equipment {
  String get displayName {
    switch (this) {
      case Equipment.barbell:
        return 'Barbell';
      case Equipment.dumbbell:
        return 'Dumbbell';
      case Equipment.cable:
        return 'Cable';
      case Equipment.machine:
        return 'Machine';
      case Equipment.bodyweight:
        return 'Bodyweight';
      case Equipment.kettlebell:
        return 'Kettlebell';
      case Equipment.resistanceBand:
        return 'Resistance Band';
      case Equipment.pullupBar:
        return 'Pull-up Bar';
      case Equipment.bench:
        return 'Bench';
      case Equipment.none:
        return 'None';
    }
  }
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.midMorning:
        return 'Mid-Morning';
      case MealType.lunch:
        return 'Lunch';
      case MealType.preWorkout:
        return 'Pre-Workout';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }

  String get emoji {
    switch (this) {
      case MealType.breakfast:
        return '🌅';
      case MealType.midMorning:
        return '☀️';
      case MealType.lunch:
        return '🍽️';
      case MealType.preWorkout:
        return '⚡';
      case MealType.dinner:
        return '🌙';
      case MealType.snack:
        return '🍎';
    }
  }
}
