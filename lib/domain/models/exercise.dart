import 'package:fitforge/core/constants/app_enums.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final Equipment equipment;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int defaultSets;
  final int defaultReps;
  final int defaultRestSeconds;
  final List<String> instructions;
  final bool isCustom;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryMuscle,
    this.secondaryMuscles = const [],
    required this.equipment,
    this.videoUrl,
    this.thumbnailUrl,
    this.defaultSets = 3,
    this.defaultReps = 10,
    this.defaultRestSeconds = 90,
    this.instructions = const [],
    this.isCustom = false,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    MuscleGroup? primaryMuscle,
    List<MuscleGroup>? secondaryMuscles,
    Equipment? equipment,
    String? videoUrl,
    String? thumbnailUrl,
    int? defaultSets,
    int? defaultReps,
    int? defaultRestSeconds,
    List<String>? instructions,
    bool? isCustom,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      equipment: equipment ?? this.equipment,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultReps: defaultReps ?? this.defaultReps,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      instructions: instructions ?? this.instructions,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'primaryMuscle': primaryMuscle.name,
        'secondaryMuscles': secondaryMuscles.map((m) => m.name).toList(),
        'equipment': equipment.name,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'defaultSets': defaultSets,
        'defaultReps': defaultReps,
        'defaultRestSeconds': defaultRestSeconds,
        'instructions': instructions,
        'isCustom': isCustom,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        primaryMuscle: MuscleGroup.values.firstWhere(
          (m) => m.name == json['primaryMuscle'],
          orElse: () => MuscleGroup.fullBody,
        ),
        secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>? ?? [])
            .map((m) => MuscleGroup.values.firstWhere(
                  (mg) => mg.name == m,
                  orElse: () => MuscleGroup.fullBody,
                ))
            .toList(),
        equipment: Equipment.values.firstWhere(
          (e) => e.name == json['equipment'],
          orElse: () => Equipment.none,
        ),
        videoUrl: json['videoUrl'] as String?,
        thumbnailUrl: json['thumbnailUrl'] as String?,
        defaultSets: json['defaultSets'] as int? ?? 3,
        defaultReps: json['defaultReps'] as int? ?? 10,
        defaultRestSeconds: json['defaultRestSeconds'] as int? ?? 90,
        instructions: (json['instructions'] as List<dynamic>? ?? [])
            .map((i) => i as String)
            .toList(),
        isCustom: json['isCustom'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Exercise && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
