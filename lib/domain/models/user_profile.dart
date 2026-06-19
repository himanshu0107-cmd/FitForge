import 'package:fitforge/core/constants/app_enums.dart';

class UserProfile {
  final String id;
  final String name;
  final int age;
  final double weightKg;
  final double heightCm;
  final Gender gender;
  final FitnessGoal goal;
  final SportType sportType;
  final int calorieGoal;
  final int proteinGoal;
  final int carbGoal;
  final int fatGoal;
  final String? workoutReminderTime; // HH:mm
  final bool waterReminderEnabled;
  final bool notificationsEnabled;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.gender,
    required this.goal,
    required this.sportType,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbGoal,
    required this.fatGoal,
    this.workoutReminderTime,
    this.waterReminderEnabled = true,
    this.notificationsEnabled = true,
    required this.createdAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    double? weightKg,
    double? heightCm,
    Gender? gender,
    FitnessGoal? goal,
    SportType? sportType,
    int? calorieGoal,
    int? proteinGoal,
    int? carbGoal,
    int? fatGoal,
    String? workoutReminderTime,
    bool? waterReminderEnabled,
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      sportType: sportType ?? this.sportType,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbGoal: carbGoal ?? this.carbGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      workoutReminderTime: workoutReminderTime ?? this.workoutReminderTime,
      waterReminderEnabled: waterReminderEnabled ?? this.waterReminderEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'gender': gender.index,
        'goal': goal.index,
        'sportType': sportType.index,
        'calorieGoal': calorieGoal,
        'proteinGoal': proteinGoal,
        'carbGoal': carbGoal,
        'fatGoal': fatGoal,
        'workoutReminderTime': workoutReminderTime,
        'waterReminderEnabled': waterReminderEnabled,
        'notificationsEnabled': notificationsEnabled,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        age: json['age'] as int,
        weightKg: (json['weightKg'] as num).toDouble(),
        heightCm: (json['heightCm'] as num).toDouble(),
        gender: Gender.values[json['gender'] as int],
        goal: FitnessGoal.values[json['goal'] as int],
        sportType: SportType.values[json['sportType'] as int],
        calorieGoal: json['calorieGoal'] as int,
        proteinGoal: json['proteinGoal'] as int,
        carbGoal: json['carbGoal'] as int,
        fatGoal: json['fatGoal'] as int,
        workoutReminderTime: json['workoutReminderTime'] as String?,
        waterReminderEnabled: json['waterReminderEnabled'] as bool? ?? true,
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
