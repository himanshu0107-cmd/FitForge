class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final List<WorkoutDay> days;
  final String? programId;
  final int weekNumber;
  final DateTime? scheduledDate;
  final bool isTemplate;

  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.days,
    this.programId,
    this.weekNumber = 1,
    this.scheduledDate,
    this.isTemplate = false,
  });

  WorkoutPlan copyWith({
    String? id,
    String? name,
    String? description,
    List<WorkoutDay>? days,
    String? programId,
    int? weekNumber,
    DateTime? scheduledDate,
    bool? isTemplate,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      days: days ?? this.days,
      programId: programId ?? this.programId,
      weekNumber: weekNumber ?? this.weekNumber,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      isTemplate: isTemplate ?? this.isTemplate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'days': days.map((d) => d.toJson()).toList(),
        'programId': programId,
        'weekNumber': weekNumber,
        'scheduledDate': scheduledDate?.toIso8601String(),
        'isTemplate': isTemplate,
      };

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => WorkoutPlan(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        days: (json['days'] as List<dynamic>? ?? [])
            .map((d) => WorkoutDay.fromJson(d as Map<String, dynamic>))
            .toList(),
        programId: json['programId'] as String?,
        weekNumber: json['weekNumber'] as int? ?? 1,
        scheduledDate: json['scheduledDate'] != null
            ? DateTime.parse(json['scheduledDate'] as String)
            : null,
        isTemplate: json['isTemplate'] as bool? ?? false,
      );
}

class WorkoutDay {
  final String id;
  final String name;
  final int dayNumber;
  final List<PlannedExercise> exercises;
  final bool isRestDay;

  const WorkoutDay({
    required this.id,
    required this.name,
    required this.dayNumber,
    required this.exercises,
    this.isRestDay = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dayNumber': dayNumber,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'isRestDay': isRestDay,
      };

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => WorkoutDay(
        id: json['id'] as String,
        name: json['name'] as String,
        dayNumber: json['dayNumber'] as int,
        exercises: (json['exercises'] as List<dynamic>? ?? [])
            .map((e) => PlannedExercise.fromJson(e as Map<String, dynamic>))
            .toList(),
        isRestDay: json['isRestDay'] as bool? ?? false,
      );
}

class PlannedExercise {
  final String exerciseId;
  final String exerciseName;
  final int sets;
  final int reps;
  final int restSeconds;
  final double? targetWeight;
  final String? notes;
  final int order;

  const PlannedExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.targetWeight,
    this.notes,
    required this.order,
  });

  PlannedExercise copyWith({
    String? exerciseId,
    String? exerciseName,
    int? sets,
    int? reps,
    int? restSeconds,
    double? targetWeight,
    String? notes,
    int? order,
  }) {
    return PlannedExercise(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      targetWeight: targetWeight ?? this.targetWeight,
      notes: notes ?? this.notes,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'sets': sets,
        'reps': reps,
        'restSeconds': restSeconds,
        'targetWeight': targetWeight,
        'notes': notes,
        'order': order,
      };

  factory PlannedExercise.fromJson(Map<String, dynamic> json) => PlannedExercise(
        exerciseId: json['exerciseId'] as String,
        exerciseName: json['exerciseName'] as String,
        sets: json['sets'] as int,
        reps: json['reps'] as int,
        restSeconds: json['restSeconds'] as int? ?? 90,
        targetWeight: (json['targetWeight'] as num?)?.toDouble(),
        notes: json['notes'] as String?,
        order: json['order'] as int? ?? 0,
      );
}

class WorkoutSession {
  final String id;
  final String workoutPlanId;
  final String workoutName;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ExerciseLog> exerciseLogs;
  final bool isCompleted;
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.workoutPlanId,
    required this.workoutName,
    required this.startTime,
    this.endTime,
    this.exerciseLogs = const [],
    this.isCompleted = false,
    this.notes,
  });

  int get durationMinutes {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }

  double get totalVolumeKg {
    return exerciseLogs.fold(0.0, (sum, log) => sum + log.totalVolume);
  }

  int get totalSetsCompleted {
    return exerciseLogs.fold(0, (sum, log) => sum + log.sets.length);
  }

  WorkoutSession copyWith({
    String? id,
    String? workoutPlanId,
    String? workoutName,
    DateTime? startTime,
    DateTime? endTime,
    List<ExerciseLog>? exerciseLogs,
    bool? isCompleted,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      workoutPlanId: workoutPlanId ?? this.workoutPlanId,
      workoutName: workoutName ?? this.workoutName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      exerciseLogs: exerciseLogs ?? this.exerciseLogs,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workoutPlanId': workoutPlanId,
        'workoutName': workoutName,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'exerciseLogs': exerciseLogs.map((l) => l.toJson()).toList(),
        'isCompleted': isCompleted,
        'notes': notes,
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        id: json['id'] as String,
        workoutPlanId: json['workoutPlanId'] as String,
        workoutName: json['workoutName'] as String,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'] as String)
            : null,
        exerciseLogs: (json['exerciseLogs'] as List<dynamic>? ?? [])
            .map((l) => ExerciseLog.fromJson(l as Map<String, dynamic>))
            .toList(),
        isCompleted: json['isCompleted'] as bool? ?? false,
        notes: json['notes'] as String?,
      );
}

class ExerciseLog {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final List<SetLog> sets;
  final bool isSkipped;

  const ExerciseLog({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    this.isSkipped = false,
  });

  double get totalVolume {
    return sets.fold(0.0, (sum, set) => sum + (set.weightKg * set.reps));
  }

  SetLog? get bestSet {
    if (sets.isEmpty) return null;
    return sets.reduce((a, b) => (a.weightKg * a.reps) > (b.weightKg * b.reps) ? a : b);
  }

  ExerciseLog copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    List<SetLog>? sets,
    bool? isSkipped,
  }) {
    return ExerciseLog(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      isSkipped: isSkipped ?? this.isSkipped,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'sets': sets.map((s) => s.toJson()).toList(),
        'isSkipped': isSkipped,
      };

  factory ExerciseLog.fromJson(Map<String, dynamic> json) => ExerciseLog(
        id: json['id'] as String,
        exerciseId: json['exerciseId'] as String,
        exerciseName: json['exerciseName'] as String,
        sets: (json['sets'] as List<dynamic>? ?? [])
            .map((s) => SetLog.fromJson(s as Map<String, dynamic>))
            .toList(),
        isSkipped: json['isSkipped'] as bool? ?? false,
      );
}

class SetLog {
  final String id;
  final int setNumber;
  final int reps;
  final double weightKg;
  final bool isCompleted;
  final bool isPR;
  final DateTime completedAt;

  const SetLog({
    required this.id,
    required this.setNumber,
    required this.reps,
    required this.weightKg,
    this.isCompleted = false,
    this.isPR = false,
    required this.completedAt,
  });

  SetLog copyWith({
    String? id,
    int? setNumber,
    int? reps,
    double? weightKg,
    bool? isCompleted,
    bool? isPR,
    DateTime? completedAt,
  }) {
    return SetLog(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      isCompleted: isCompleted ?? this.isCompleted,
      isPR: isPR ?? this.isPR,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'setNumber': setNumber,
        'reps': reps,
        'weightKg': weightKg,
        'isCompleted': isCompleted,
        'isPR': isPR,
        'completedAt': completedAt.toIso8601String(),
      };

  factory SetLog.fromJson(Map<String, dynamic> json) => SetLog(
        id: json['id'] as String,
        setNumber: json['setNumber'] as int,
        reps: json['reps'] as int,
        weightKg: (json['weightKg'] as num).toDouble(),
        isCompleted: json['isCompleted'] as bool? ?? false,
        isPR: json['isPR'] as bool? ?? false,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
}

class PersonalRecord {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final double weightKg;
  final int reps;
  final DateTime achievedAt;
  final String? sessionId;

  const PersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.weightKg,
    required this.reps,
    required this.achievedAt,
    this.sessionId,
  });

  double get oneRepMax => weightKg * (1 + reps / 30.0); // Epley formula

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'weightKg': weightKg,
        'reps': reps,
        'achievedAt': achievedAt.toIso8601String(),
        'sessionId': sessionId,
      };

  factory PersonalRecord.fromJson(Map<String, dynamic> json) => PersonalRecord(
        id: json['id'] as String,
        exerciseId: json['exerciseId'] as String,
        exerciseName: json['exerciseName'] as String,
        weightKg: (json['weightKg'] as num).toDouble(),
        reps: json['reps'] as int,
        achievedAt: DateTime.parse(json['achievedAt'] as String),
        sessionId: json['sessionId'] as String?,
      );
}
