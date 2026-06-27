// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
      'gender', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<int> goal = GeneratedColumn<int>(
      'goal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sportTypeMeta =
      const VerificationMeta('sportType');
  @override
  late final GeneratedColumn<int> sportType = GeneratedColumn<int>(
      'sport_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _calorieGoalMeta =
      const VerificationMeta('calorieGoal');
  @override
  late final GeneratedColumn<int> calorieGoal = GeneratedColumn<int>(
      'calorie_goal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _proteinGoalMeta =
      const VerificationMeta('proteinGoal');
  @override
  late final GeneratedColumn<int> proteinGoal = GeneratedColumn<int>(
      'protein_goal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _carbGoalMeta =
      const VerificationMeta('carbGoal');
  @override
  late final GeneratedColumn<int> carbGoal = GeneratedColumn<int>(
      'carb_goal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fatGoalMeta =
      const VerificationMeta('fatGoal');
  @override
  late final GeneratedColumn<int> fatGoal = GeneratedColumn<int>(
      'fat_goal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _workoutReminderTimeMeta =
      const VerificationMeta('workoutReminderTime');
  @override
  late final GeneratedColumn<String> workoutReminderTime =
      GeneratedColumn<String>('workout_reminder_time', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _waterReminderEnabledMeta =
      const VerificationMeta('waterReminderEnabled');
  @override
  late final GeneratedColumn<bool> waterReminderEnabled = GeneratedColumn<bool>(
      'water_reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("water_reminder_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        age,
        weightKg,
        heightCm,
        gender,
        goal,
        sportType,
        calorieGoal,
        proteinGoal,
        carbGoal,
        fatGoal,
        workoutReminderTime,
        waterReminderEnabled,
        notificationsEnabled,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
          _goalMeta, goal.isAcceptableOrUnknown(data['goal']!, _goalMeta));
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('sport_type')) {
      context.handle(_sportTypeMeta,
          sportType.isAcceptableOrUnknown(data['sport_type']!, _sportTypeMeta));
    } else if (isInserting) {
      context.missing(_sportTypeMeta);
    }
    if (data.containsKey('calorie_goal')) {
      context.handle(
          _calorieGoalMeta,
          calorieGoal.isAcceptableOrUnknown(
              data['calorie_goal']!, _calorieGoalMeta));
    } else if (isInserting) {
      context.missing(_calorieGoalMeta);
    }
    if (data.containsKey('protein_goal')) {
      context.handle(
          _proteinGoalMeta,
          proteinGoal.isAcceptableOrUnknown(
              data['protein_goal']!, _proteinGoalMeta));
    } else if (isInserting) {
      context.missing(_proteinGoalMeta);
    }
    if (data.containsKey('carb_goal')) {
      context.handle(_carbGoalMeta,
          carbGoal.isAcceptableOrUnknown(data['carb_goal']!, _carbGoalMeta));
    } else if (isInserting) {
      context.missing(_carbGoalMeta);
    }
    if (data.containsKey('fat_goal')) {
      context.handle(_fatGoalMeta,
          fatGoal.isAcceptableOrUnknown(data['fat_goal']!, _fatGoalMeta));
    } else if (isInserting) {
      context.missing(_fatGoalMeta);
    }
    if (data.containsKey('workout_reminder_time')) {
      context.handle(
          _workoutReminderTimeMeta,
          workoutReminderTime.isAcceptableOrUnknown(
              data['workout_reminder_time']!, _workoutReminderTimeMeta));
    }
    if (data.containsKey('water_reminder_enabled')) {
      context.handle(
          _waterReminderEnabledMeta,
          waterReminderEnabled.isAcceptableOrUnknown(
              data['water_reminder_enabled']!, _waterReminderEnabledMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!,
      goal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goal'])!,
      sportType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sport_type'])!,
      calorieGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calorie_goal'])!,
      proteinGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}protein_goal'])!,
      carbGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carb_goal'])!,
      fatGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fat_goal'])!,
      workoutReminderTime: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}workout_reminder_time']),
      waterReminderEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}water_reminder_enabled'])!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String name;
  final int age;
  final double weightKg;
  final double heightCm;
  final int gender;
  final int goal;
  final int sportType;
  final int calorieGoal;
  final int proteinGoal;
  final int carbGoal;
  final int fatGoal;
  final String? workoutReminderTime;
  final bool waterReminderEnabled;
  final bool notificationsEnabled;
  final DateTime createdAt;
  const UserProfile(
      {required this.id,
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
      required this.waterReminderEnabled,
      required this.notificationsEnabled,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['weight_kg'] = Variable<double>(weightKg);
    map['height_cm'] = Variable<double>(heightCm);
    map['gender'] = Variable<int>(gender);
    map['goal'] = Variable<int>(goal);
    map['sport_type'] = Variable<int>(sportType);
    map['calorie_goal'] = Variable<int>(calorieGoal);
    map['protein_goal'] = Variable<int>(proteinGoal);
    map['carb_goal'] = Variable<int>(carbGoal);
    map['fat_goal'] = Variable<int>(fatGoal);
    if (!nullToAbsent || workoutReminderTime != null) {
      map['workout_reminder_time'] = Variable<String>(workoutReminderTime);
    }
    map['water_reminder_enabled'] = Variable<bool>(waterReminderEnabled);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      weightKg: Value(weightKg),
      heightCm: Value(heightCm),
      gender: Value(gender),
      goal: Value(goal),
      sportType: Value(sportType),
      calorieGoal: Value(calorieGoal),
      proteinGoal: Value(proteinGoal),
      carbGoal: Value(carbGoal),
      fatGoal: Value(fatGoal),
      workoutReminderTime: workoutReminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutReminderTime),
      waterReminderEnabled: Value(waterReminderEnabled),
      notificationsEnabled: Value(notificationsEnabled),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      gender: serializer.fromJson<int>(json['gender']),
      goal: serializer.fromJson<int>(json['goal']),
      sportType: serializer.fromJson<int>(json['sportType']),
      calorieGoal: serializer.fromJson<int>(json['calorieGoal']),
      proteinGoal: serializer.fromJson<int>(json['proteinGoal']),
      carbGoal: serializer.fromJson<int>(json['carbGoal']),
      fatGoal: serializer.fromJson<int>(json['fatGoal']),
      workoutReminderTime:
          serializer.fromJson<String?>(json['workoutReminderTime']),
      waterReminderEnabled:
          serializer.fromJson<bool>(json['waterReminderEnabled']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double>(heightCm),
      'gender': serializer.toJson<int>(gender),
      'goal': serializer.toJson<int>(goal),
      'sportType': serializer.toJson<int>(sportType),
      'calorieGoal': serializer.toJson<int>(calorieGoal),
      'proteinGoal': serializer.toJson<int>(proteinGoal),
      'carbGoal': serializer.toJson<int>(carbGoal),
      'fatGoal': serializer.toJson<int>(fatGoal),
      'workoutReminderTime': serializer.toJson<String?>(workoutReminderTime),
      'waterReminderEnabled': serializer.toJson<bool>(waterReminderEnabled),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserProfile copyWith(
          {String? id,
          String? name,
          int? age,
          double? weightKg,
          double? heightCm,
          int? gender,
          int? goal,
          int? sportType,
          int? calorieGoal,
          int? proteinGoal,
          int? carbGoal,
          int? fatGoal,
          Value<String?> workoutReminderTime = const Value.absent(),
          bool? waterReminderEnabled,
          bool? notificationsEnabled,
          DateTime? createdAt}) =>
      UserProfile(
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
        workoutReminderTime: workoutReminderTime.present
            ? workoutReminderTime.value
            : this.workoutReminderTime,
        waterReminderEnabled: waterReminderEnabled ?? this.waterReminderEnabled,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        createdAt: createdAt ?? this.createdAt,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      gender: data.gender.present ? data.gender.value : this.gender,
      goal: data.goal.present ? data.goal.value : this.goal,
      sportType: data.sportType.present ? data.sportType.value : this.sportType,
      calorieGoal:
          data.calorieGoal.present ? data.calorieGoal.value : this.calorieGoal,
      proteinGoal:
          data.proteinGoal.present ? data.proteinGoal.value : this.proteinGoal,
      carbGoal: data.carbGoal.present ? data.carbGoal.value : this.carbGoal,
      fatGoal: data.fatGoal.present ? data.fatGoal.value : this.fatGoal,
      workoutReminderTime: data.workoutReminderTime.present
          ? data.workoutReminderTime.value
          : this.workoutReminderTime,
      waterReminderEnabled: data.waterReminderEnabled.present
          ? data.waterReminderEnabled.value
          : this.waterReminderEnabled,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('gender: $gender, ')
          ..write('goal: $goal, ')
          ..write('sportType: $sportType, ')
          ..write('calorieGoal: $calorieGoal, ')
          ..write('proteinGoal: $proteinGoal, ')
          ..write('carbGoal: $carbGoal, ')
          ..write('fatGoal: $fatGoal, ')
          ..write('workoutReminderTime: $workoutReminderTime, ')
          ..write('waterReminderEnabled: $waterReminderEnabled, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      age,
      weightKg,
      heightCm,
      gender,
      goal,
      sportType,
      calorieGoal,
      proteinGoal,
      carbGoal,
      fatGoal,
      workoutReminderTime,
      waterReminderEnabled,
      notificationsEnabled,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.gender == this.gender &&
          other.goal == this.goal &&
          other.sportType == this.sportType &&
          other.calorieGoal == this.calorieGoal &&
          other.proteinGoal == this.proteinGoal &&
          other.carbGoal == this.carbGoal &&
          other.fatGoal == this.fatGoal &&
          other.workoutReminderTime == this.workoutReminderTime &&
          other.waterReminderEnabled == this.waterReminderEnabled &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.createdAt == this.createdAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> age;
  final Value<double> weightKg;
  final Value<double> heightCm;
  final Value<int> gender;
  final Value<int> goal;
  final Value<int> sportType;
  final Value<int> calorieGoal;
  final Value<int> proteinGoal;
  final Value<int> carbGoal;
  final Value<int> fatGoal;
  final Value<String?> workoutReminderTime;
  final Value<bool> waterReminderEnabled;
  final Value<bool> notificationsEnabled;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.gender = const Value.absent(),
    this.goal = const Value.absent(),
    this.sportType = const Value.absent(),
    this.calorieGoal = const Value.absent(),
    this.proteinGoal = const Value.absent(),
    this.carbGoal = const Value.absent(),
    this.fatGoal = const Value.absent(),
    this.workoutReminderTime = const Value.absent(),
    this.waterReminderEnabled = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required String name,
    required int age,
    required double weightKg,
    required double heightCm,
    required int gender,
    required int goal,
    required int sportType,
    required int calorieGoal,
    required int proteinGoal,
    required int carbGoal,
    required int fatGoal,
    this.workoutReminderTime = const Value.absent(),
    this.waterReminderEnabled = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        age = Value(age),
        weightKg = Value(weightKg),
        heightCm = Value(heightCm),
        gender = Value(gender),
        goal = Value(goal),
        sportType = Value(sportType),
        calorieGoal = Value(calorieGoal),
        proteinGoal = Value(proteinGoal),
        carbGoal = Value(carbGoal),
        fatGoal = Value(fatGoal),
        createdAt = Value(createdAt);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<int>? gender,
    Expression<int>? goal,
    Expression<int>? sportType,
    Expression<int>? calorieGoal,
    Expression<int>? proteinGoal,
    Expression<int>? carbGoal,
    Expression<int>? fatGoal,
    Expression<String>? workoutReminderTime,
    Expression<bool>? waterReminderEnabled,
    Expression<bool>? notificationsEnabled,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (gender != null) 'gender': gender,
      if (goal != null) 'goal': goal,
      if (sportType != null) 'sport_type': sportType,
      if (calorieGoal != null) 'calorie_goal': calorieGoal,
      if (proteinGoal != null) 'protein_goal': proteinGoal,
      if (carbGoal != null) 'carb_goal': carbGoal,
      if (fatGoal != null) 'fat_goal': fatGoal,
      if (workoutReminderTime != null)
        'workout_reminder_time': workoutReminderTime,
      if (waterReminderEnabled != null)
        'water_reminder_enabled': waterReminderEnabled,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? age,
      Value<double>? weightKg,
      Value<double>? heightCm,
      Value<int>? gender,
      Value<int>? goal,
      Value<int>? sportType,
      Value<int>? calorieGoal,
      Value<int>? proteinGoal,
      Value<int>? carbGoal,
      Value<int>? fatGoal,
      Value<String?>? workoutReminderTime,
      Value<bool>? waterReminderEnabled,
      Value<bool>? notificationsEnabled,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UserProfilesCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(goal.value);
    }
    if (sportType.present) {
      map['sport_type'] = Variable<int>(sportType.value);
    }
    if (calorieGoal.present) {
      map['calorie_goal'] = Variable<int>(calorieGoal.value);
    }
    if (proteinGoal.present) {
      map['protein_goal'] = Variable<int>(proteinGoal.value);
    }
    if (carbGoal.present) {
      map['carb_goal'] = Variable<int>(carbGoal.value);
    }
    if (fatGoal.present) {
      map['fat_goal'] = Variable<int>(fatGoal.value);
    }
    if (workoutReminderTime.present) {
      map['workout_reminder_time'] =
          Variable<String>(workoutReminderTime.value);
    }
    if (waterReminderEnabled.present) {
      map['water_reminder_enabled'] =
          Variable<bool>(waterReminderEnabled.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('gender: $gender, ')
          ..write('goal: $goal, ')
          ..write('sportType: $sportType, ')
          ..write('calorieGoal: $calorieGoal, ')
          ..write('proteinGoal: $proteinGoal, ')
          ..write('carbGoal: $carbGoal, ')
          ..write('fatGoal: $fatGoal, ')
          ..write('workoutReminderTime: $workoutReminderTime, ')
          ..write('waterReminderEnabled: $waterReminderEnabled, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTableTable extends ExercisesTable
    with TableInfo<$ExercisesTableTable, ExercisesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _primaryMuscleMeta =
      const VerificationMeta('primaryMuscle');
  @override
  late final GeneratedColumn<int> primaryMuscle = GeneratedColumn<int>(
      'primary_muscle', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _secondaryMusclesMeta =
      const VerificationMeta('secondaryMuscles');
  @override
  late final GeneratedColumn<String> secondaryMuscles = GeneratedColumn<String>(
      'secondary_muscles', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<int> equipment = GeneratedColumn<int>(
      'equipment', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _videoUrlMeta =
      const VerificationMeta('videoUrl');
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
      'video_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _thumbnailUrlMeta =
      const VerificationMeta('thumbnailUrl');
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
      'thumbnail_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultSetsMeta =
      const VerificationMeta('defaultSets');
  @override
  late final GeneratedColumn<int> defaultSets = GeneratedColumn<int>(
      'default_sets', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _defaultRepsMeta =
      const VerificationMeta('defaultReps');
  @override
  late final GeneratedColumn<int> defaultReps = GeneratedColumn<int>(
      'default_reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
      'default_rest_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(90));
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        primaryMuscle,
        secondaryMuscles,
        equipment,
        videoUrl,
        thumbnailUrl,
        defaultSets,
        defaultReps,
        defaultRestSeconds,
        instructions,
        isCustom
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<ExercisesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('primary_muscle')) {
      context.handle(
          _primaryMuscleMeta,
          primaryMuscle.isAcceptableOrUnknown(
              data['primary_muscle']!, _primaryMuscleMeta));
    } else if (isInserting) {
      context.missing(_primaryMuscleMeta);
    }
    if (data.containsKey('secondary_muscles')) {
      context.handle(
          _secondaryMusclesMeta,
          secondaryMuscles.isAcceptableOrUnknown(
              data['secondary_muscles']!, _secondaryMusclesMeta));
    } else if (isInserting) {
      context.missing(_secondaryMusclesMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('video_url')) {
      context.handle(_videoUrlMeta,
          videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta));
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
          _thumbnailUrlMeta,
          thumbnailUrl.isAcceptableOrUnknown(
              data['thumbnail_url']!, _thumbnailUrlMeta));
    }
    if (data.containsKey('default_sets')) {
      context.handle(
          _defaultSetsMeta,
          defaultSets.isAcceptableOrUnknown(
              data['default_sets']!, _defaultSetsMeta));
    }
    if (data.containsKey('default_reps')) {
      context.handle(
          _defaultRepsMeta,
          defaultReps.isAcceptableOrUnknown(
              data['default_reps']!, _defaultRepsMeta));
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
          _defaultRestSecondsMeta,
          defaultRestSeconds.isAcceptableOrUnknown(
              data['default_rest_seconds']!, _defaultRestSecondsMeta));
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExercisesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExercisesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      primaryMuscle: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}primary_muscle'])!,
      secondaryMuscles: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}secondary_muscles'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}equipment'])!,
      videoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}video_url']),
      thumbnailUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_url']),
      defaultSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_sets'])!,
      defaultReps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_reps'])!,
      defaultRestSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_rest_seconds'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $ExercisesTableTable createAlias(String alias) {
    return $ExercisesTableTable(attachedDatabase, alias);
  }
}

class ExercisesTableData extends DataClass
    implements Insertable<ExercisesTableData> {
  final String id;
  final String name;
  final String description;
  final int primaryMuscle;
  final String secondaryMuscles;
  final int equipment;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int defaultSets;
  final int defaultReps;
  final int defaultRestSeconds;
  final String instructions;
  final bool isCustom;
  const ExercisesTableData(
      {required this.id,
      required this.name,
      required this.description,
      required this.primaryMuscle,
      required this.secondaryMuscles,
      required this.equipment,
      this.videoUrl,
      this.thumbnailUrl,
      required this.defaultSets,
      required this.defaultReps,
      required this.defaultRestSeconds,
      required this.instructions,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['primary_muscle'] = Variable<int>(primaryMuscle);
    map['secondary_muscles'] = Variable<String>(secondaryMuscles);
    map['equipment'] = Variable<int>(equipment);
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['default_sets'] = Variable<int>(defaultSets);
    map['default_reps'] = Variable<int>(defaultReps);
    map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    map['instructions'] = Variable<String>(instructions);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  ExercisesTableCompanion toCompanion(bool nullToAbsent) {
    return ExercisesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      primaryMuscle: Value(primaryMuscle),
      secondaryMuscles: Value(secondaryMuscles),
      equipment: Value(equipment),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      defaultSets: Value(defaultSets),
      defaultReps: Value(defaultReps),
      defaultRestSeconds: Value(defaultRestSeconds),
      instructions: Value(instructions),
      isCustom: Value(isCustom),
    );
  }

  factory ExercisesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExercisesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      primaryMuscle: serializer.fromJson<int>(json['primaryMuscle']),
      secondaryMuscles: serializer.fromJson<String>(json['secondaryMuscles']),
      equipment: serializer.fromJson<int>(json['equipment']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      defaultSets: serializer.fromJson<int>(json['defaultSets']),
      defaultReps: serializer.fromJson<int>(json['defaultReps']),
      defaultRestSeconds: serializer.fromJson<int>(json['defaultRestSeconds']),
      instructions: serializer.fromJson<String>(json['instructions']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'primaryMuscle': serializer.toJson<int>(primaryMuscle),
      'secondaryMuscles': serializer.toJson<String>(secondaryMuscles),
      'equipment': serializer.toJson<int>(equipment),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'defaultSets': serializer.toJson<int>(defaultSets),
      'defaultReps': serializer.toJson<int>(defaultReps),
      'defaultRestSeconds': serializer.toJson<int>(defaultRestSeconds),
      'instructions': serializer.toJson<String>(instructions),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  ExercisesTableData copyWith(
          {String? id,
          String? name,
          String? description,
          int? primaryMuscle,
          String? secondaryMuscles,
          int? equipment,
          Value<String?> videoUrl = const Value.absent(),
          Value<String?> thumbnailUrl = const Value.absent(),
          int? defaultSets,
          int? defaultReps,
          int? defaultRestSeconds,
          String? instructions,
          bool? isCustom}) =>
      ExercisesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        primaryMuscle: primaryMuscle ?? this.primaryMuscle,
        secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
        equipment: equipment ?? this.equipment,
        videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
        thumbnailUrl:
            thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
        defaultSets: defaultSets ?? this.defaultSets,
        defaultReps: defaultReps ?? this.defaultReps,
        defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
        instructions: instructions ?? this.instructions,
        isCustom: isCustom ?? this.isCustom,
      );
  ExercisesTableData copyWithCompanion(ExercisesTableCompanion data) {
    return ExercisesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      primaryMuscle: data.primaryMuscle.present
          ? data.primaryMuscle.value
          : this.primaryMuscle,
      secondaryMuscles: data.secondaryMuscles.present
          ? data.secondaryMuscles.value
          : this.secondaryMuscles,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      defaultSets:
          data.defaultSets.present ? data.defaultSets.value : this.defaultSets,
      defaultReps:
          data.defaultReps.present ? data.defaultReps.value : this.defaultReps,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('instructions: $instructions, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      primaryMuscle,
      secondaryMuscles,
      equipment,
      videoUrl,
      thumbnailUrl,
      defaultSets,
      defaultReps,
      defaultRestSeconds,
      instructions,
      isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExercisesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.primaryMuscle == this.primaryMuscle &&
          other.secondaryMuscles == this.secondaryMuscles &&
          other.equipment == this.equipment &&
          other.videoUrl == this.videoUrl &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.defaultSets == this.defaultSets &&
          other.defaultReps == this.defaultReps &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.instructions == this.instructions &&
          other.isCustom == this.isCustom);
}

class ExercisesTableCompanion extends UpdateCompanion<ExercisesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<int> primaryMuscle;
  final Value<String> secondaryMuscles;
  final Value<int> equipment;
  final Value<String?> videoUrl;
  final Value<String?> thumbnailUrl;
  final Value<int> defaultSets;
  final Value<int> defaultReps;
  final Value<int> defaultRestSeconds;
  final Value<String> instructions;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const ExercisesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.primaryMuscle = const Value.absent(),
    this.secondaryMuscles = const Value.absent(),
    this.equipment = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.instructions = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesTableCompanion.insert({
    required String id,
    required String name,
    required String description,
    required int primaryMuscle,
    required String secondaryMuscles,
    required int equipment,
    this.videoUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    required String instructions,
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        primaryMuscle = Value(primaryMuscle),
        secondaryMuscles = Value(secondaryMuscles),
        equipment = Value(equipment),
        instructions = Value(instructions);
  static Insertable<ExercisesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? primaryMuscle,
    Expression<String>? secondaryMuscles,
    Expression<int>? equipment,
    Expression<String>? videoUrl,
    Expression<String>? thumbnailUrl,
    Expression<int>? defaultSets,
    Expression<int>? defaultReps,
    Expression<int>? defaultRestSeconds,
    Expression<String>? instructions,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (primaryMuscle != null) 'primary_muscle': primaryMuscle,
      if (secondaryMuscles != null) 'secondary_muscles': secondaryMuscles,
      if (equipment != null) 'equipment': equipment,
      if (videoUrl != null) 'video_url': videoUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (defaultSets != null) 'default_sets': defaultSets,
      if (defaultReps != null) 'default_reps': defaultReps,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (instructions != null) 'instructions': instructions,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<int>? primaryMuscle,
      Value<String>? secondaryMuscles,
      Value<int>? equipment,
      Value<String?>? videoUrl,
      Value<String?>? thumbnailUrl,
      Value<int>? defaultSets,
      Value<int>? defaultReps,
      Value<int>? defaultRestSeconds,
      Value<String>? instructions,
      Value<bool>? isCustom,
      Value<int>? rowid}) {
    return ExercisesTableCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (primaryMuscle.present) {
      map['primary_muscle'] = Variable<int>(primaryMuscle.value);
    }
    if (secondaryMuscles.present) {
      map['secondary_muscles'] = Variable<String>(secondaryMuscles.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<int>(equipment.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (defaultSets.present) {
      map['default_sets'] = Variable<int>(defaultSets.value);
    }
    if (defaultReps.present) {
      map['default_reps'] = Variable<int>(defaultReps.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('instructions: $instructions, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutPlanIdMeta =
      const VerificationMeta('workoutPlanId');
  @override
  late final GeneratedColumn<String> workoutPlanId = GeneratedColumn<String>(
      'workout_plan_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutNameMeta =
      const VerificationMeta('workoutName');
  @override
  late final GeneratedColumn<String> workoutName = GeneratedColumn<String>(
      'workout_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _exerciseLogsMeta =
      const VerificationMeta('exerciseLogs');
  @override
  late final GeneratedColumn<String> exerciseLogs = GeneratedColumn<String>(
      'exercise_logs', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workoutPlanId,
        workoutName,
        startTime,
        endTime,
        exerciseLogs,
        isCompleted,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_plan_id')) {
      context.handle(
          _workoutPlanIdMeta,
          workoutPlanId.isAcceptableOrUnknown(
              data['workout_plan_id']!, _workoutPlanIdMeta));
    } else if (isInserting) {
      context.missing(_workoutPlanIdMeta);
    }
    if (data.containsKey('workout_name')) {
      context.handle(
          _workoutNameMeta,
          workoutName.isAcceptableOrUnknown(
              data['workout_name']!, _workoutNameMeta));
    } else if (isInserting) {
      context.missing(_workoutNameMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('exercise_logs')) {
      context.handle(
          _exerciseLogsMeta,
          exerciseLogs.isAcceptableOrUnknown(
              data['exercise_logs']!, _exerciseLogsMeta));
    } else if (isInserting) {
      context.missing(_exerciseLogsMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutPlanId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}workout_plan_id'])!,
      workoutName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_name'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      exerciseLogs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_logs'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String workoutPlanId;
  final String workoutName;
  final DateTime startTime;
  final DateTime? endTime;
  final String exerciseLogs;
  final bool isCompleted;
  final String? notes;
  const WorkoutSession(
      {required this.id,
      required this.workoutPlanId,
      required this.workoutName,
      required this.startTime,
      this.endTime,
      required this.exerciseLogs,
      required this.isCompleted,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_plan_id'] = Variable<String>(workoutPlanId);
    map['workout_name'] = Variable<String>(workoutName);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['exercise_logs'] = Variable<String>(exerciseLogs);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      workoutPlanId: Value(workoutPlanId),
      workoutName: Value(workoutName),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      exerciseLogs: Value(exerciseLogs),
      isCompleted: Value(isCompleted),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      workoutPlanId: serializer.fromJson<String>(json['workoutPlanId']),
      workoutName: serializer.fromJson<String>(json['workoutName']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      exerciseLogs: serializer.fromJson<String>(json['exerciseLogs']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutPlanId': serializer.toJson<String>(workoutPlanId),
      'workoutName': serializer.toJson<String>(workoutName),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'exerciseLogs': serializer.toJson<String>(exerciseLogs),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutSession copyWith(
          {String? id,
          String? workoutPlanId,
          String? workoutName,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          String? exerciseLogs,
          bool? isCompleted,
          Value<String?> notes = const Value.absent()}) =>
      WorkoutSession(
        id: id ?? this.id,
        workoutPlanId: workoutPlanId ?? this.workoutPlanId,
        workoutName: workoutName ?? this.workoutName,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        exerciseLogs: exerciseLogs ?? this.exerciseLogs,
        isCompleted: isCompleted ?? this.isCompleted,
        notes: notes.present ? notes.value : this.notes,
      );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      workoutPlanId: data.workoutPlanId.present
          ? data.workoutPlanId.value
          : this.workoutPlanId,
      workoutName:
          data.workoutName.present ? data.workoutName.value : this.workoutName,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      exerciseLogs: data.exerciseLogs.present
          ? data.exerciseLogs.value
          : this.exerciseLogs,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('workoutPlanId: $workoutPlanId, ')
          ..write('workoutName: $workoutName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('exerciseLogs: $exerciseLogs, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutPlanId, workoutName, startTime,
      endTime, exerciseLogs, isCompleted, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.workoutPlanId == this.workoutPlanId &&
          other.workoutName == this.workoutName &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.exerciseLogs == this.exerciseLogs &&
          other.isCompleted == this.isCompleted &&
          other.notes == this.notes);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String> workoutPlanId;
  final Value<String> workoutName;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<String> exerciseLogs;
  final Value<bool> isCompleted;
  final Value<String?> notes;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.workoutPlanId = const Value.absent(),
    this.workoutName = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.exerciseLogs = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String workoutPlanId,
    required String workoutName,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    required String exerciseLogs,
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workoutPlanId = Value(workoutPlanId),
        workoutName = Value(workoutName),
        startTime = Value(startTime),
        exerciseLogs = Value(exerciseLogs);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? workoutPlanId,
    Expression<String>? workoutName,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? exerciseLogs,
    Expression<bool>? isCompleted,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutPlanId != null) 'workout_plan_id': workoutPlanId,
      if (workoutName != null) 'workout_name': workoutName,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (exerciseLogs != null) 'exercise_logs': exerciseLogs,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workoutPlanId,
      Value<String>? workoutName,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<String>? exerciseLogs,
      Value<bool>? isCompleted,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      workoutPlanId: workoutPlanId ?? this.workoutPlanId,
      workoutName: workoutName ?? this.workoutName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      exerciseLogs: exerciseLogs ?? this.exerciseLogs,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutPlanId.present) {
      map['workout_plan_id'] = Variable<String>(workoutPlanId.value);
    }
    if (workoutName.present) {
      map['workout_name'] = Variable<String>(workoutName.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (exerciseLogs.present) {
      map['exercise_logs'] = Variable<String>(exerciseLogs.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('workoutPlanId: $workoutPlanId, ')
          ..write('workoutName: $workoutName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('exerciseLogs: $exerciseLogs, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exerciseNameMeta =
      const VerificationMeta('exerciseName');
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
      'exercise_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _achievedAtMeta =
      const VerificationMeta('achievedAt');
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
      'achieved_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, exerciseId, exerciseName, weightKg, reps, achievedAt, sessionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(Insertable<PersonalRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
          _exerciseNameMeta,
          exerciseName.isAcceptableOrUnknown(
              data['exercise_name']!, _exerciseNameMeta));
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
          _achievedAtMeta,
          achievedAt.isAcceptableOrUnknown(
              data['achieved_at']!, _achievedAtMeta));
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      exerciseName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_name'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      achievedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}achieved_at'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }
}

class PersonalRecord extends DataClass implements Insertable<PersonalRecord> {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final double weightKg;
  final int reps;
  final DateTime achievedAt;
  final String? sessionId;
  const PersonalRecord(
      {required this.id,
      required this.exerciseId,
      required this.exerciseName,
      required this.weightKg,
      required this.reps,
      required this.achievedAt,
      this.sessionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      exerciseName: Value(exerciseName),
      weightKg: Value(weightKg),
      reps: Value(reps),
      achievedAt: Value(achievedAt),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
    );
  }

  factory PersonalRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecord(
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
      'sessionId': serializer.toJson<String?>(sessionId),
    };
  }

  PersonalRecord copyWith(
          {String? id,
          String? exerciseId,
          String? exerciseName,
          double? weightKg,
          int? reps,
          DateTime? achievedAt,
          Value<String?> sessionId = const Value.absent()}) =>
      PersonalRecord(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        exerciseName: exerciseName ?? this.exerciseName,
        weightKg: weightKg ?? this.weightKg,
        reps: reps ?? this.reps,
        achievedAt: achievedAt ?? this.achievedAt,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
      );
  PersonalRecord copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecord(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      achievedAt:
          data.achievedAt.present ? data.achievedAt.value : this.achievedAt,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecord(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, exerciseId, exerciseName, weightKg, reps, achievedAt, sessionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecord &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.exerciseName == this.exerciseName &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.achievedAt == this.achievedAt &&
          other.sessionId == this.sessionId);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecord> {
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<String> exerciseName;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<DateTime> achievedAt;
  final Value<String?> sessionId;
  final Value<int> rowid;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    required String id,
    required String exerciseId,
    required String exerciseName,
    required double weightKg,
    required int reps,
    required DateTime achievedAt,
    this.sessionId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        exerciseId = Value(exerciseId),
        exerciseName = Value(exerciseName),
        weightKg = Value(weightKg),
        reps = Value(reps),
        achievedAt = Value(achievedAt);
  static Insertable<PersonalRecord> custom({
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<String>? exerciseName,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<DateTime>? achievedAt,
    Expression<String>? sessionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (sessionId != null) 'session_id': sessionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? exerciseId,
      Value<String>? exerciseName,
      Value<double>? weightKg,
      Value<int>? reps,
      Value<DateTime>? achievedAt,
      Value<String?>? sessionId,
      Value<int>? rowid}) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      achievedAt: achievedAt ?? this.achievedAt,
      sessionId: sessionId ?? this.sessionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodLogsTable extends FoodLogs with TableInfo<$FoodLogsTable, FoodLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _foodNameMeta =
      const VerificationMeta('foodName');
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
      'food_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
      'grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
      'calories', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _proteinGramsMeta =
      const VerificationMeta('proteinGrams');
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
      'protein_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _carbGramsMeta =
      const VerificationMeta('carbGrams');
  @override
  late final GeneratedColumn<double> carbGrams = GeneratedColumn<double>(
      'carb_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fatGramsMeta =
      const VerificationMeta('fatGrams');
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
      'fat_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<int> mealType = GeneratedColumn<int>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        foodName,
        grams,
        calories,
        proteinGrams,
        carbGrams,
        fatGrams,
        mealType,
        loggedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_logs';
  @override
  VerificationContext validateIntegrity(Insertable<FoodLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(_foodNameMeta,
          foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta));
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
          _gramsMeta, grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta));
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
          _proteinGramsMeta,
          proteinGrams.isAcceptableOrUnknown(
              data['protein_grams']!, _proteinGramsMeta));
    } else if (isInserting) {
      context.missing(_proteinGramsMeta);
    }
    if (data.containsKey('carb_grams')) {
      context.handle(_carbGramsMeta,
          carbGrams.isAcceptableOrUnknown(data['carb_grams']!, _carbGramsMeta));
    } else if (isInserting) {
      context.missing(_carbGramsMeta);
    }
    if (data.containsKey('fat_grams')) {
      context.handle(_fatGramsMeta,
          fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta));
    } else if (isInserting) {
      context.missing(_fatGramsMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      foodName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}food_name'])!,
      grams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grams'])!,
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calories'])!,
      proteinGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein_grams'])!,
      carbGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carb_grams'])!,
      fatGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat_grams'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_type'])!,
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}logged_at'])!,
    );
  }

  @override
  $FoodLogsTable createAlias(String alias) {
    return $FoodLogsTable(attachedDatabase, alias);
  }
}

class FoodLog extends DataClass implements Insertable<FoodLog> {
  final String id;
  final String foodName;
  final double grams;
  final int calories;
  final double proteinGrams;
  final double carbGrams;
  final double fatGrams;
  final int mealType;
  final DateTime loggedAt;
  const FoodLog(
      {required this.id,
      required this.foodName,
      required this.grams,
      required this.calories,
      required this.proteinGrams,
      required this.carbGrams,
      required this.fatGrams,
      required this.mealType,
      required this.loggedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['food_name'] = Variable<String>(foodName);
    map['grams'] = Variable<double>(grams);
    map['calories'] = Variable<int>(calories);
    map['protein_grams'] = Variable<double>(proteinGrams);
    map['carb_grams'] = Variable<double>(carbGrams);
    map['fat_grams'] = Variable<double>(fatGrams);
    map['meal_type'] = Variable<int>(mealType);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  FoodLogsCompanion toCompanion(bool nullToAbsent) {
    return FoodLogsCompanion(
      id: Value(id),
      foodName: Value(foodName),
      grams: Value(grams),
      calories: Value(calories),
      proteinGrams: Value(proteinGrams),
      carbGrams: Value(carbGrams),
      fatGrams: Value(fatGrams),
      mealType: Value(mealType),
      loggedAt: Value(loggedAt),
    );
  }

  factory FoodLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLog(
      id: serializer.fromJson<String>(json['id']),
      foodName: serializer.fromJson<String>(json['foodName']),
      grams: serializer.fromJson<double>(json['grams']),
      calories: serializer.fromJson<int>(json['calories']),
      proteinGrams: serializer.fromJson<double>(json['proteinGrams']),
      carbGrams: serializer.fromJson<double>(json['carbGrams']),
      fatGrams: serializer.fromJson<double>(json['fatGrams']),
      mealType: serializer.fromJson<int>(json['mealType']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'foodName': serializer.toJson<String>(foodName),
      'grams': serializer.toJson<double>(grams),
      'calories': serializer.toJson<int>(calories),
      'proteinGrams': serializer.toJson<double>(proteinGrams),
      'carbGrams': serializer.toJson<double>(carbGrams),
      'fatGrams': serializer.toJson<double>(fatGrams),
      'mealType': serializer.toJson<int>(mealType),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  FoodLog copyWith(
          {String? id,
          String? foodName,
          double? grams,
          int? calories,
          double? proteinGrams,
          double? carbGrams,
          double? fatGrams,
          int? mealType,
          DateTime? loggedAt}) =>
      FoodLog(
        id: id ?? this.id,
        foodName: foodName ?? this.foodName,
        grams: grams ?? this.grams,
        calories: calories ?? this.calories,
        proteinGrams: proteinGrams ?? this.proteinGrams,
        carbGrams: carbGrams ?? this.carbGrams,
        fatGrams: fatGrams ?? this.fatGrams,
        mealType: mealType ?? this.mealType,
        loggedAt: loggedAt ?? this.loggedAt,
      );
  FoodLog copyWithCompanion(FoodLogsCompanion data) {
    return FoodLog(
      id: data.id.present ? data.id.value : this.id,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      grams: data.grams.present ? data.grams.value : this.grams,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      carbGrams: data.carbGrams.present ? data.carbGrams.value : this.carbGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodLog(')
          ..write('id: $id, ')
          ..write('foodName: $foodName, ')
          ..write('grams: $grams, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbGrams: $carbGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('mealType: $mealType, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, foodName, grams, calories, proteinGrams,
      carbGrams, fatGrams, mealType, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodLog &&
          other.id == this.id &&
          other.foodName == this.foodName &&
          other.grams == this.grams &&
          other.calories == this.calories &&
          other.proteinGrams == this.proteinGrams &&
          other.carbGrams == this.carbGrams &&
          other.fatGrams == this.fatGrams &&
          other.mealType == this.mealType &&
          other.loggedAt == this.loggedAt);
}

class FoodLogsCompanion extends UpdateCompanion<FoodLog> {
  final Value<String> id;
  final Value<String> foodName;
  final Value<double> grams;
  final Value<int> calories;
  final Value<double> proteinGrams;
  final Value<double> carbGrams;
  final Value<double> fatGrams;
  final Value<int> mealType;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const FoodLogsCompanion({
    this.id = const Value.absent(),
    this.foodName = const Value.absent(),
    this.grams = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.mealType = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodLogsCompanion.insert({
    required String id,
    required String foodName,
    required double grams,
    required int calories,
    required double proteinGrams,
    required double carbGrams,
    required double fatGrams,
    required int mealType,
    required DateTime loggedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        foodName = Value(foodName),
        grams = Value(grams),
        calories = Value(calories),
        proteinGrams = Value(proteinGrams),
        carbGrams = Value(carbGrams),
        fatGrams = Value(fatGrams),
        mealType = Value(mealType),
        loggedAt = Value(loggedAt);
  static Insertable<FoodLog> custom({
    Expression<String>? id,
    Expression<String>? foodName,
    Expression<double>? grams,
    Expression<int>? calories,
    Expression<double>? proteinGrams,
    Expression<double>? carbGrams,
    Expression<double>? fatGrams,
    Expression<int>? mealType,
    Expression<DateTime>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodName != null) 'food_name': foodName,
      if (grams != null) 'grams': grams,
      if (calories != null) 'calories': calories,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (carbGrams != null) 'carb_grams': carbGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (mealType != null) 'meal_type': mealType,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? foodName,
      Value<double>? grams,
      Value<int>? calories,
      Value<double>? proteinGrams,
      Value<double>? carbGrams,
      Value<double>? fatGrams,
      Value<int>? mealType,
      Value<DateTime>? loggedAt,
      Value<int>? rowid}) {
    return FoodLogsCompanion(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      grams: grams ?? this.grams,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbGrams: carbGrams ?? this.carbGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      mealType: mealType ?? this.mealType,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (carbGrams.present) {
      map['carb_grams'] = Variable<double>(carbGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<int>(mealType.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogsCompanion(')
          ..write('id: $id, ')
          ..write('foodName: $foodName, ')
          ..write('grams: $grams, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbGrams: $carbGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('mealType: $mealType, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightLogsTable extends WeightLogs
    with TableInfo<$WeightLogsTable, WeightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, weightKg, loggedAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_logs';
  @override
  VerificationContext validateIntegrity(Insertable<WeightLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}logged_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $WeightLogsTable createAlias(String alias) {
    return $WeightLogsTable(attachedDatabase, alias);
  }
}

class WeightLog extends DataClass implements Insertable<WeightLog> {
  final String id;
  final double weightKg;
  final DateTime loggedAt;
  final String? notes;
  const WeightLog(
      {required this.id,
      required this.weightKg,
      required this.loggedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['weight_kg'] = Variable<double>(weightKg);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WeightLogsCompanion toCompanion(bool nullToAbsent) {
    return WeightLogsCompanion(
      id: Value(id),
      weightKg: Value(weightKg),
      loggedAt: Value(loggedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WeightLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightLog(
      id: serializer.fromJson<String>(json['id']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weightKg': serializer.toJson<double>(weightKg),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WeightLog copyWith(
          {String? id,
          double? weightKg,
          DateTime? loggedAt,
          Value<String?> notes = const Value.absent()}) =>
      WeightLog(
        id: id ?? this.id,
        weightKg: weightKg ?? this.weightKg,
        loggedAt: loggedAt ?? this.loggedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  WeightLog copyWithCompanion(WeightLogsCompanion data) {
    return WeightLog(
      id: data.id.present ? data.id.value : this.id,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightLog(')
          ..write('id: $id, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weightKg, loggedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightLog &&
          other.id == this.id &&
          other.weightKg == this.weightKg &&
          other.loggedAt == this.loggedAt &&
          other.notes == this.notes);
}

class WeightLogsCompanion extends UpdateCompanion<WeightLog> {
  final Value<String> id;
  final Value<double> weightKg;
  final Value<DateTime> loggedAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const WeightLogsCompanion({
    this.id = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightLogsCompanion.insert({
    required String id,
    required double weightKg,
    required DateTime loggedAt,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        weightKg = Value(weightKg),
        loggedAt = Value(loggedAt);
  static Insertable<WeightLog> custom({
    Expression<String>? id,
    Expression<double>? weightKg,
    Expression<DateTime>? loggedAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightKg != null) 'weight_kg': weightKg,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightLogsCompanion copyWith(
      {Value<String>? id,
      Value<double>? weightKg,
      Value<DateTime>? loggedAt,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return WeightLogsCompanion(
      id: id ?? this.id,
      weightKg: weightKg ?? this.weightKg,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightLogsCompanion(')
          ..write('id: $id, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutStreaksTable extends WorkoutStreaks
    with TableInfo<$WorkoutStreaksTable, WorkoutStreak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutStreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentStreakMeta =
      const VerificationMeta('currentStreak');
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
      'current_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _longestStreakMeta =
      const VerificationMeta('longestStreak');
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
      'longest_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastWorkoutDateMeta =
      const VerificationMeta('lastWorkoutDate');
  @override
  late final GeneratedColumn<DateTime> lastWorkoutDate =
      GeneratedColumn<DateTime>('last_workout_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, currentStreak, longestStreak, lastWorkoutDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_streaks';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutStreak> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('current_streak')) {
      context.handle(
          _currentStreakMeta,
          currentStreak.isAcceptableOrUnknown(
              data['current_streak']!, _currentStreakMeta));
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
          _longestStreakMeta,
          longestStreak.isAcceptableOrUnknown(
              data['longest_streak']!, _longestStreakMeta));
    }
    if (data.containsKey('last_workout_date')) {
      context.handle(
          _lastWorkoutDateMeta,
          lastWorkoutDate.isAcceptableOrUnknown(
              data['last_workout_date']!, _lastWorkoutDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutStreak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutStreak(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      currentStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_streak'])!,
      longestStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_streak'])!,
      lastWorkoutDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_workout_date']),
    );
  }

  @override
  $WorkoutStreaksTable createAlias(String alias) {
    return $WorkoutStreaksTable(attachedDatabase, alias);
  }
}

class WorkoutStreak extends DataClass implements Insertable<WorkoutStreak> {
  final String id;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastWorkoutDate;
  const WorkoutStreak(
      {required this.id,
      required this.currentStreak,
      required this.longestStreak,
      this.lastWorkoutDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastWorkoutDate != null) {
      map['last_workout_date'] = Variable<DateTime>(lastWorkoutDate);
    }
    return map;
  }

  WorkoutStreaksCompanion toCompanion(bool nullToAbsent) {
    return WorkoutStreaksCompanion(
      id: Value(id),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastWorkoutDate: lastWorkoutDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWorkoutDate),
    );
  }

  factory WorkoutStreak.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutStreak(
      id: serializer.fromJson<String>(json['id']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastWorkoutDate: serializer.fromJson<DateTime?>(json['lastWorkoutDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastWorkoutDate': serializer.toJson<DateTime?>(lastWorkoutDate),
    };
  }

  WorkoutStreak copyWith(
          {String? id,
          int? currentStreak,
          int? longestStreak,
          Value<DateTime?> lastWorkoutDate = const Value.absent()}) =>
      WorkoutStreak(
        id: id ?? this.id,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastWorkoutDate: lastWorkoutDate.present
            ? lastWorkoutDate.value
            : this.lastWorkoutDate,
      );
  WorkoutStreak copyWithCompanion(WorkoutStreaksCompanion data) {
    return WorkoutStreak(
      id: data.id.present ? data.id.value : this.id,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastWorkoutDate: data.lastWorkoutDate.present
          ? data.lastWorkoutDate.value
          : this.lastWorkoutDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutStreak(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastWorkoutDate: $lastWorkoutDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currentStreak, longestStreak, lastWorkoutDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutStreak &&
          other.id == this.id &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastWorkoutDate == this.lastWorkoutDate);
}

class WorkoutStreaksCompanion extends UpdateCompanion<WorkoutStreak> {
  final Value<String> id;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime?> lastWorkoutDate;
  final Value<int> rowid;
  const WorkoutStreaksCompanion({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastWorkoutDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutStreaksCompanion.insert({
    required String id,
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastWorkoutDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<WorkoutStreak> custom({
    Expression<String>? id,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastWorkoutDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastWorkoutDate != null) 'last_workout_date': lastWorkoutDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutStreaksCompanion copyWith(
      {Value<String>? id,
      Value<int>? currentStreak,
      Value<int>? longestStreak,
      Value<DateTime?>? lastWorkoutDate,
      Value<int>? rowid}) {
    return WorkoutStreaksCompanion(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastWorkoutDate.present) {
      map['last_workout_date'] = Variable<DateTime>(lastWorkoutDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutStreaksCompanion(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastWorkoutDate: $lastWorkoutDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterLogsTable extends WaterLogs
    with TableInfo<$WaterLogsTable, WaterLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMlMeta =
      const VerificationMeta('amountMl');
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
      'amount_ml', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, amountMl, loggedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_logs';
  @override
  VerificationContext validateIntegrity(Insertable<WaterLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(_amountMlMeta,
          amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta));
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      amountMl: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_ml'])!,
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}logged_at'])!,
    );
  }

  @override
  $WaterLogsTable createAlias(String alias) {
    return $WaterLogsTable(attachedDatabase, alias);
  }
}

class WaterLog extends DataClass implements Insertable<WaterLog> {
  final String id;
  final int amountMl;
  final DateTime loggedAt;
  const WaterLog(
      {required this.id, required this.amountMl, required this.loggedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount_ml'] = Variable<int>(amountMl);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  WaterLogsCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsCompanion(
      id: Value(id),
      amountMl: Value(amountMl),
      loggedAt: Value(loggedAt),
    );
  }

  factory WaterLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLog(
      id: serializer.fromJson<String>(json['id']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amountMl': serializer.toJson<int>(amountMl),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  WaterLog copyWith({String? id, int? amountMl, DateTime? loggedAt}) =>
      WaterLog(
        id: id ?? this.id,
        amountMl: amountMl ?? this.amountMl,
        loggedAt: loggedAt ?? this.loggedAt,
      );
  WaterLog copyWithCompanion(WaterLogsCompanion data) {
    return WaterLog(
      id: data.id.present ? data.id.value : this.id,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLog(')
          ..write('id: $id, ')
          ..write('amountMl: $amountMl, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amountMl, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterLog &&
          other.id == this.id &&
          other.amountMl == this.amountMl &&
          other.loggedAt == this.loggedAt);
}

class WaterLogsCompanion extends UpdateCompanion<WaterLog> {
  final Value<String> id;
  final Value<int> amountMl;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const WaterLogsCompanion({
    this.id = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterLogsCompanion.insert({
    required String id,
    required int amountMl,
    required DateTime loggedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        amountMl = Value(amountMl),
        loggedAt = Value(loggedAt);
  static Insertable<WaterLog> custom({
    Expression<String>? id,
    Expression<int>? amountMl,
    Expression<DateTime>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountMl != null) 'amount_ml': amountMl,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterLogsCompanion copyWith(
      {Value<String>? id,
      Value<int>? amountMl,
      Value<DateTime>? loggedAt,
      Value<int>? rowid}) {
    return WaterLogsCompanion(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsCompanion(')
          ..write('id: $id, ')
          ..write('amountMl: $amountMl, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramEnrollmentsTable extends ProgramEnrollments
    with TableInfo<$ProgramEnrollmentsTable, ProgramEnrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramEnrollmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _programIdMeta =
      const VerificationMeta('programId');
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
      'program_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _programNameMeta =
      const VerificationMeta('programName');
  @override
  late final GeneratedColumn<String> programName = GeneratedColumn<String>(
      'program_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _currentWeekMeta =
      const VerificationMeta('currentWeek');
  @override
  late final GeneratedColumn<int> currentWeek = GeneratedColumn<int>(
      'current_week', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currentDayMeta =
      const VerificationMeta('currentDay');
  @override
  late final GeneratedColumn<int> currentDay = GeneratedColumn<int>(
      'current_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        programId,
        programName,
        startDate,
        currentWeek,
        currentDay,
        isActive,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_enrollments';
  @override
  VerificationContext validateIntegrity(Insertable<ProgramEnrollment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_id')) {
      context.handle(_programIdMeta,
          programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta));
    } else if (isInserting) {
      context.missing(_programIdMeta);
    }
    if (data.containsKey('program_name')) {
      context.handle(
          _programNameMeta,
          programName.isAcceptableOrUnknown(
              data['program_name']!, _programNameMeta));
    } else if (isInserting) {
      context.missing(_programNameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('current_week')) {
      context.handle(
          _currentWeekMeta,
          currentWeek.isAcceptableOrUnknown(
              data['current_week']!, _currentWeekMeta));
    }
    if (data.containsKey('current_day')) {
      context.handle(
          _currentDayMeta,
          currentDay.isAcceptableOrUnknown(
              data['current_day']!, _currentDayMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramEnrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramEnrollment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      programId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}program_id'])!,
      programName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}program_name'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      currentWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_week'])!,
      currentDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_day'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $ProgramEnrollmentsTable createAlias(String alias) {
    return $ProgramEnrollmentsTable(attachedDatabase, alias);
  }
}

class ProgramEnrollment extends DataClass
    implements Insertable<ProgramEnrollment> {
  final String id;
  final String programId;
  final String programName;
  final DateTime startDate;
  final int currentWeek;
  final int currentDay;
  final bool isActive;
  final DateTime? completedAt;
  const ProgramEnrollment(
      {required this.id,
      required this.programId,
      required this.programName,
      required this.startDate,
      required this.currentWeek,
      required this.currentDay,
      required this.isActive,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_id'] = Variable<String>(programId);
    map['program_name'] = Variable<String>(programName);
    map['start_date'] = Variable<DateTime>(startDate);
    map['current_week'] = Variable<int>(currentWeek);
    map['current_day'] = Variable<int>(currentDay);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  ProgramEnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return ProgramEnrollmentsCompanion(
      id: Value(id),
      programId: Value(programId),
      programName: Value(programName),
      startDate: Value(startDate),
      currentWeek: Value(currentWeek),
      currentDay: Value(currentDay),
      isActive: Value(isActive),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory ProgramEnrollment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramEnrollment(
      id: serializer.fromJson<String>(json['id']),
      programId: serializer.fromJson<String>(json['programId']),
      programName: serializer.fromJson<String>(json['programName']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      currentWeek: serializer.fromJson<int>(json['currentWeek']),
      currentDay: serializer.fromJson<int>(json['currentDay']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programId': serializer.toJson<String>(programId),
      'programName': serializer.toJson<String>(programName),
      'startDate': serializer.toJson<DateTime>(startDate),
      'currentWeek': serializer.toJson<int>(currentWeek),
      'currentDay': serializer.toJson<int>(currentDay),
      'isActive': serializer.toJson<bool>(isActive),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  ProgramEnrollment copyWith(
          {String? id,
          String? programId,
          String? programName,
          DateTime? startDate,
          int? currentWeek,
          int? currentDay,
          bool? isActive,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      ProgramEnrollment(
        id: id ?? this.id,
        programId: programId ?? this.programId,
        programName: programName ?? this.programName,
        startDate: startDate ?? this.startDate,
        currentWeek: currentWeek ?? this.currentWeek,
        currentDay: currentDay ?? this.currentDay,
        isActive: isActive ?? this.isActive,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  ProgramEnrollment copyWithCompanion(ProgramEnrollmentsCompanion data) {
    return ProgramEnrollment(
      id: data.id.present ? data.id.value : this.id,
      programId: data.programId.present ? data.programId.value : this.programId,
      programName:
          data.programName.present ? data.programName.value : this.programName,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      currentWeek:
          data.currentWeek.present ? data.currentWeek.value : this.currentWeek,
      currentDay:
          data.currentDay.present ? data.currentDay.value : this.currentDay,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramEnrollment(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('programName: $programName, ')
          ..write('startDate: $startDate, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentDay: $currentDay, ')
          ..write('isActive: $isActive, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, programId, programName, startDate,
      currentWeek, currentDay, isActive, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramEnrollment &&
          other.id == this.id &&
          other.programId == this.programId &&
          other.programName == this.programName &&
          other.startDate == this.startDate &&
          other.currentWeek == this.currentWeek &&
          other.currentDay == this.currentDay &&
          other.isActive == this.isActive &&
          other.completedAt == this.completedAt);
}

class ProgramEnrollmentsCompanion extends UpdateCompanion<ProgramEnrollment> {
  final Value<String> id;
  final Value<String> programId;
  final Value<String> programName;
  final Value<DateTime> startDate;
  final Value<int> currentWeek;
  final Value<int> currentDay;
  final Value<bool> isActive;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const ProgramEnrollmentsCompanion({
    this.id = const Value.absent(),
    this.programId = const Value.absent(),
    this.programName = const Value.absent(),
    this.startDate = const Value.absent(),
    this.currentWeek = const Value.absent(),
    this.currentDay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramEnrollmentsCompanion.insert({
    required String id,
    required String programId,
    required String programName,
    required DateTime startDate,
    this.currentWeek = const Value.absent(),
    this.currentDay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        programId = Value(programId),
        programName = Value(programName),
        startDate = Value(startDate);
  static Insertable<ProgramEnrollment> custom({
    Expression<String>? id,
    Expression<String>? programId,
    Expression<String>? programName,
    Expression<DateTime>? startDate,
    Expression<int>? currentWeek,
    Expression<int>? currentDay,
    Expression<bool>? isActive,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programId != null) 'program_id': programId,
      if (programName != null) 'program_name': programName,
      if (startDate != null) 'start_date': startDate,
      if (currentWeek != null) 'current_week': currentWeek,
      if (currentDay != null) 'current_day': currentDay,
      if (isActive != null) 'is_active': isActive,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramEnrollmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? programId,
      Value<String>? programName,
      Value<DateTime>? startDate,
      Value<int>? currentWeek,
      Value<int>? currentDay,
      Value<bool>? isActive,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return ProgramEnrollmentsCompanion(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      programName: programName ?? this.programName,
      startDate: startDate ?? this.startDate,
      currentWeek: currentWeek ?? this.currentWeek,
      currentDay: currentDay ?? this.currentDay,
      isActive: isActive ?? this.isActive,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (programName.present) {
      map['program_name'] = Variable<String>(programName.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (currentWeek.present) {
      map['current_week'] = Variable<int>(currentWeek.value);
    }
    if (currentDay.present) {
      map['current_day'] = Variable<int>(currentDay.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramEnrollmentsCompanion(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('programName: $programName, ')
          ..write('startDate: $startDate, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentDay: $currentDay, ')
          ..write('isActive: $isActive, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $ExercisesTableTable exercisesTable = $ExercisesTableTable(this);
  late final $WorkoutSessionsTable workoutSessions =
      $WorkoutSessionsTable(this);
  late final $PersonalRecordsTable personalRecords =
      $PersonalRecordsTable(this);
  late final $FoodLogsTable foodLogs = $FoodLogsTable(this);
  late final $WeightLogsTable weightLogs = $WeightLogsTable(this);
  late final $WorkoutStreaksTable workoutStreaks = $WorkoutStreaksTable(this);
  late final $WaterLogsTable waterLogs = $WaterLogsTable(this);
  late final $ProgramEnrollmentsTable programEnrollments =
      $ProgramEnrollmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userProfiles,
        exercisesTable,
        workoutSessions,
        personalRecords,
        foodLogs,
        weightLogs,
        workoutStreaks,
        waterLogs,
        programEnrollments
      ];
}

typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  required String id,
  required String name,
  required int age,
  required double weightKg,
  required double heightCm,
  required int gender,
  required int goal,
  required int sportType,
  required int calorieGoal,
  required int proteinGoal,
  required int carbGoal,
  required int fatGoal,
  Value<String?> workoutReminderTime,
  Value<bool> waterReminderEnabled,
  Value<bool> notificationsEnabled,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> age,
  Value<double> weightKg,
  Value<double> heightCm,
  Value<int> gender,
  Value<int> goal,
  Value<int> sportType,
  Value<int> calorieGoal,
  Value<int> proteinGoal,
  Value<int> carbGoal,
  Value<int> fatGoal,
  Value<String?> workoutReminderTime,
  Value<bool> waterReminderEnabled,
  Value<bool> notificationsEnabled,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get goal => $composableBuilder(
      column: $table.goal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sportType => $composableBuilder(
      column: $table.sportType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calorieGoal => $composableBuilder(
      column: $table.calorieGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get proteinGoal => $composableBuilder(
      column: $table.proteinGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carbGoal => $composableBuilder(
      column: $table.carbGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fatGoal => $composableBuilder(
      column: $table.fatGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workoutReminderTime => $composableBuilder(
      column: $table.workoutReminderTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get waterReminderEnabled => $composableBuilder(
      column: $table.waterReminderEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get goal => $composableBuilder(
      column: $table.goal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sportType => $composableBuilder(
      column: $table.sportType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calorieGoal => $composableBuilder(
      column: $table.calorieGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get proteinGoal => $composableBuilder(
      column: $table.proteinGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carbGoal => $composableBuilder(
      column: $table.carbGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fatGoal => $composableBuilder(
      column: $table.fatGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workoutReminderTime => $composableBuilder(
      column: $table.workoutReminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get waterReminderEnabled => $composableBuilder(
      column: $table.waterReminderEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<int> get sportType =>
      $composableBuilder(column: $table.sportType, builder: (column) => column);

  GeneratedColumn<int> get calorieGoal => $composableBuilder(
      column: $table.calorieGoal, builder: (column) => column);

  GeneratedColumn<int> get proteinGoal => $composableBuilder(
      column: $table.proteinGoal, builder: (column) => column);

  GeneratedColumn<int> get carbGoal =>
      $composableBuilder(column: $table.carbGoal, builder: (column) => column);

  GeneratedColumn<int> get fatGoal =>
      $composableBuilder(column: $table.fatGoal, builder: (column) => column);

  GeneratedColumn<String> get workoutReminderTime => $composableBuilder(
      column: $table.workoutReminderTime, builder: (column) => column);

  GeneratedColumn<bool> get waterReminderEnabled => $composableBuilder(
      column: $table.waterReminderEnabled, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> age = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<double> heightCm = const Value.absent(),
            Value<int> gender = const Value.absent(),
            Value<int> goal = const Value.absent(),
            Value<int> sportType = const Value.absent(),
            Value<int> calorieGoal = const Value.absent(),
            Value<int> proteinGoal = const Value.absent(),
            Value<int> carbGoal = const Value.absent(),
            Value<int> fatGoal = const Value.absent(),
            Value<String?> workoutReminderTime = const Value.absent(),
            Value<bool> waterReminderEnabled = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            id: id,
            name: name,
            age: age,
            weightKg: weightKg,
            heightCm: heightCm,
            gender: gender,
            goal: goal,
            sportType: sportType,
            calorieGoal: calorieGoal,
            proteinGoal: proteinGoal,
            carbGoal: carbGoal,
            fatGoal: fatGoal,
            workoutReminderTime: workoutReminderTime,
            waterReminderEnabled: waterReminderEnabled,
            notificationsEnabled: notificationsEnabled,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int age,
            required double weightKg,
            required double heightCm,
            required int gender,
            required int goal,
            required int sportType,
            required int calorieGoal,
            required int proteinGoal,
            required int carbGoal,
            required int fatGoal,
            Value<String?> workoutReminderTime = const Value.absent(),
            Value<bool> waterReminderEnabled = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfilesCompanion.insert(
            id: id,
            name: name,
            age: age,
            weightKg: weightKg,
            heightCm: heightCm,
            gender: gender,
            goal: goal,
            sportType: sportType,
            calorieGoal: calorieGoal,
            proteinGoal: proteinGoal,
            carbGoal: carbGoal,
            fatGoal: fatGoal,
            workoutReminderTime: workoutReminderTime,
            waterReminderEnabled: waterReminderEnabled,
            notificationsEnabled: notificationsEnabled,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()>;
typedef $$ExercisesTableTableCreateCompanionBuilder = ExercisesTableCompanion
    Function({
  required String id,
  required String name,
  required String description,
  required int primaryMuscle,
  required String secondaryMuscles,
  required int equipment,
  Value<String?> videoUrl,
  Value<String?> thumbnailUrl,
  Value<int> defaultSets,
  Value<int> defaultReps,
  Value<int> defaultRestSeconds,
  required String instructions,
  Value<bool> isCustom,
  Value<int> rowid,
});
typedef $$ExercisesTableTableUpdateCompanionBuilder = ExercisesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<int> primaryMuscle,
  Value<String> secondaryMuscles,
  Value<int> equipment,
  Value<String?> videoUrl,
  Value<String?> thumbnailUrl,
  Value<int> defaultSets,
  Value<int> defaultReps,
  Value<int> defaultRestSeconds,
  Value<String> instructions,
  Value<bool> isCustom,
  Value<int> rowid,
});

class $$ExercisesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get primaryMuscle => $composableBuilder(
      column: $table.primaryMuscle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secondaryMuscles => $composableBuilder(
      column: $table.secondaryMuscles,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoUrl => $composableBuilder(
      column: $table.videoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));
}

class $$ExercisesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get primaryMuscle => $composableBuilder(
      column: $table.primaryMuscle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondaryMuscles => $composableBuilder(
      column: $table.secondaryMuscles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoUrl => $composableBuilder(
      column: $table.videoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get primaryMuscle => $composableBuilder(
      column: $table.primaryMuscle, builder: (column) => column);

  GeneratedColumn<String> get secondaryMuscles => $composableBuilder(
      column: $table.secondaryMuscles, builder: (column) => column);

  GeneratedColumn<int> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => column);

  GeneratedColumn<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => column);

  GeneratedColumn<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => column);

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$ExercisesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTableTable,
    ExercisesTableData,
    $$ExercisesTableTableFilterComposer,
    $$ExercisesTableTableOrderingComposer,
    $$ExercisesTableTableAnnotationComposer,
    $$ExercisesTableTableCreateCompanionBuilder,
    $$ExercisesTableTableUpdateCompanionBuilder,
    (
      ExercisesTableData,
      BaseReferences<_$AppDatabase, $ExercisesTableTable, ExercisesTableData>
    ),
    ExercisesTableData,
    PrefetchHooks Function()> {
  $$ExercisesTableTableTableManager(
      _$AppDatabase db, $ExercisesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> primaryMuscle = const Value.absent(),
            Value<String> secondaryMuscles = const Value.absent(),
            Value<int> equipment = const Value.absent(),
            Value<String?> videoUrl = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<int> defaultSets = const Value.absent(),
            Value<int> defaultReps = const Value.absent(),
            Value<int> defaultRestSeconds = const Value.absent(),
            Value<String> instructions = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesTableCompanion(
            id: id,
            name: name,
            description: description,
            primaryMuscle: primaryMuscle,
            secondaryMuscles: secondaryMuscles,
            equipment: equipment,
            videoUrl: videoUrl,
            thumbnailUrl: thumbnailUrl,
            defaultSets: defaultSets,
            defaultReps: defaultReps,
            defaultRestSeconds: defaultRestSeconds,
            instructions: instructions,
            isCustom: isCustom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required int primaryMuscle,
            required String secondaryMuscles,
            required int equipment,
            Value<String?> videoUrl = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<int> defaultSets = const Value.absent(),
            Value<int> defaultReps = const Value.absent(),
            Value<int> defaultRestSeconds = const Value.absent(),
            required String instructions,
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            primaryMuscle: primaryMuscle,
            secondaryMuscles: secondaryMuscles,
            equipment: equipment,
            videoUrl: videoUrl,
            thumbnailUrl: thumbnailUrl,
            defaultSets: defaultSets,
            defaultReps: defaultReps,
            defaultRestSeconds: defaultRestSeconds,
            instructions: instructions,
            isCustom: isCustom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExercisesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTableTable,
    ExercisesTableData,
    $$ExercisesTableTableFilterComposer,
    $$ExercisesTableTableOrderingComposer,
    $$ExercisesTableTableAnnotationComposer,
    $$ExercisesTableTableCreateCompanionBuilder,
    $$ExercisesTableTableUpdateCompanionBuilder,
    (
      ExercisesTableData,
      BaseReferences<_$AppDatabase, $ExercisesTableTable, ExercisesTableData>
    ),
    ExercisesTableData,
    PrefetchHooks Function()>;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  required String id,
  required String workoutPlanId,
  required String workoutName,
  required DateTime startTime,
  Value<DateTime?> endTime,
  required String exerciseLogs,
  Value<bool> isCompleted,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<String> id,
  Value<String> workoutPlanId,
  Value<String> workoutName,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<String> exerciseLogs,
  Value<bool> isCompleted,
  Value<String?> notes,
  Value<int> rowid,
});

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workoutPlanId => $composableBuilder(
      column: $table.workoutPlanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workoutName => $composableBuilder(
      column: $table.workoutName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseLogs => $composableBuilder(
      column: $table.exerciseLogs, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workoutPlanId => $composableBuilder(
      column: $table.workoutPlanId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workoutName => $composableBuilder(
      column: $table.workoutName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseLogs => $composableBuilder(
      column: $table.exerciseLogs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workoutPlanId => $composableBuilder(
      column: $table.workoutPlanId, builder: (column) => column);

  GeneratedColumn<String> get workoutName => $composableBuilder(
      column: $table.workoutName, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get exerciseLogs => $composableBuilder(
      column: $table.exerciseLogs, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WorkoutSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (
      WorkoutSession,
      BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession>
    ),
    WorkoutSession,
    PrefetchHooks Function()> {
  $$WorkoutSessionsTableTableManager(
      _$AppDatabase db, $WorkoutSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workoutPlanId = const Value.absent(),
            Value<String> workoutName = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<String> exerciseLogs = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion(
            id: id,
            workoutPlanId: workoutPlanId,
            workoutName: workoutName,
            startTime: startTime,
            endTime: endTime,
            exerciseLogs: exerciseLogs,
            isCompleted: isCompleted,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String workoutPlanId,
            required String workoutName,
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            required String exerciseLogs,
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion.insert(
            id: id,
            workoutPlanId: workoutPlanId,
            workoutName: workoutName,
            startTime: startTime,
            endTime: endTime,
            exerciseLogs: exerciseLogs,
            isCompleted: isCompleted,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkoutSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (
      WorkoutSession,
      BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession>
    ),
    WorkoutSession,
    PrefetchHooks Function()>;
typedef $$PersonalRecordsTableCreateCompanionBuilder = PersonalRecordsCompanion
    Function({
  required String id,
  required String exerciseId,
  required String exerciseName,
  required double weightKg,
  required int reps,
  required DateTime achievedAt,
  Value<String?> sessionId,
  Value<int> rowid,
});
typedef $$PersonalRecordsTableUpdateCompanionBuilder = PersonalRecordsCompanion
    Function({
  Value<String> id,
  Value<String> exerciseId,
  Value<String> exerciseName,
  Value<double> weightKg,
  Value<int> reps,
  Value<DateTime> achievedAt,
  Value<String?> sessionId,
  Value<int> rowid,
});

class $$PersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseName => $composableBuilder(
      column: $table.exerciseName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
      column: $table.achievedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));
}

class $$PersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseName => $composableBuilder(
      column: $table.exerciseName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
      column: $table.achievedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));
}

class $$PersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
      column: $table.exerciseName, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
      column: $table.achievedAt, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);
}

class $$PersonalRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonalRecordsTable,
    PersonalRecord,
    $$PersonalRecordsTableFilterComposer,
    $$PersonalRecordsTableOrderingComposer,
    $$PersonalRecordsTableAnnotationComposer,
    $$PersonalRecordsTableCreateCompanionBuilder,
    $$PersonalRecordsTableUpdateCompanionBuilder,
    (
      PersonalRecord,
      BaseReferences<_$AppDatabase, $PersonalRecordsTable, PersonalRecord>
    ),
    PersonalRecord,
    PrefetchHooks Function()> {
  $$PersonalRecordsTableTableManager(
      _$AppDatabase db, $PersonalRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<String> exerciseName = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<DateTime> achievedAt = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonalRecordsCompanion(
            id: id,
            exerciseId: exerciseId,
            exerciseName: exerciseName,
            weightKg: weightKg,
            reps: reps,
            achievedAt: achievedAt,
            sessionId: sessionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String exerciseId,
            required String exerciseName,
            required double weightKg,
            required int reps,
            required DateTime achievedAt,
            Value<String?> sessionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonalRecordsCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            exerciseName: exerciseName,
            weightKg: weightKg,
            reps: reps,
            achievedAt: achievedAt,
            sessionId: sessionId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonalRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonalRecordsTable,
    PersonalRecord,
    $$PersonalRecordsTableFilterComposer,
    $$PersonalRecordsTableOrderingComposer,
    $$PersonalRecordsTableAnnotationComposer,
    $$PersonalRecordsTableCreateCompanionBuilder,
    $$PersonalRecordsTableUpdateCompanionBuilder,
    (
      PersonalRecord,
      BaseReferences<_$AppDatabase, $PersonalRecordsTable, PersonalRecord>
    ),
    PersonalRecord,
    PrefetchHooks Function()>;
typedef $$FoodLogsTableCreateCompanionBuilder = FoodLogsCompanion Function({
  required String id,
  required String foodName,
  required double grams,
  required int calories,
  required double proteinGrams,
  required double carbGrams,
  required double fatGrams,
  required int mealType,
  required DateTime loggedAt,
  Value<int> rowid,
});
typedef $$FoodLogsTableUpdateCompanionBuilder = FoodLogsCompanion Function({
  Value<String> id,
  Value<String> foodName,
  Value<double> grams,
  Value<int> calories,
  Value<double> proteinGrams,
  Value<double> carbGrams,
  Value<double> fatGrams,
  Value<int> mealType,
  Value<DateTime> loggedAt,
  Value<int> rowid,
});

class $$FoodLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodName => $composableBuilder(
      column: $table.foodName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grams => $composableBuilder(
      column: $table.grams, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinGrams => $composableBuilder(
      column: $table.proteinGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbGrams => $composableBuilder(
      column: $table.carbGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatGrams => $composableBuilder(
      column: $table.fatGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));
}

class $$FoodLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodName => $composableBuilder(
      column: $table.foodName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grams => $composableBuilder(
      column: $table.grams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
      column: $table.proteinGrams,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbGrams => $composableBuilder(
      column: $table.carbGrams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatGrams => $composableBuilder(
      column: $table.fatGrams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));
}

class $$FoodLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
      column: $table.proteinGrams, builder: (column) => column);

  GeneratedColumn<double> get carbGrams =>
      $composableBuilder(column: $table.carbGrams, builder: (column) => column);

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);

  GeneratedColumn<int> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$FoodLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodLogsTable,
    FoodLog,
    $$FoodLogsTableFilterComposer,
    $$FoodLogsTableOrderingComposer,
    $$FoodLogsTableAnnotationComposer,
    $$FoodLogsTableCreateCompanionBuilder,
    $$FoodLogsTableUpdateCompanionBuilder,
    (FoodLog, BaseReferences<_$AppDatabase, $FoodLogsTable, FoodLog>),
    FoodLog,
    PrefetchHooks Function()> {
  $$FoodLogsTableTableManager(_$AppDatabase db, $FoodLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> foodName = const Value.absent(),
            Value<double> grams = const Value.absent(),
            Value<int> calories = const Value.absent(),
            Value<double> proteinGrams = const Value.absent(),
            Value<double> carbGrams = const Value.absent(),
            Value<double> fatGrams = const Value.absent(),
            Value<int> mealType = const Value.absent(),
            Value<DateTime> loggedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FoodLogsCompanion(
            id: id,
            foodName: foodName,
            grams: grams,
            calories: calories,
            proteinGrams: proteinGrams,
            carbGrams: carbGrams,
            fatGrams: fatGrams,
            mealType: mealType,
            loggedAt: loggedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String foodName,
            required double grams,
            required int calories,
            required double proteinGrams,
            required double carbGrams,
            required double fatGrams,
            required int mealType,
            required DateTime loggedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FoodLogsCompanion.insert(
            id: id,
            foodName: foodName,
            grams: grams,
            calories: calories,
            proteinGrams: proteinGrams,
            carbGrams: carbGrams,
            fatGrams: fatGrams,
            mealType: mealType,
            loggedAt: loggedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FoodLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodLogsTable,
    FoodLog,
    $$FoodLogsTableFilterComposer,
    $$FoodLogsTableOrderingComposer,
    $$FoodLogsTableAnnotationComposer,
    $$FoodLogsTableCreateCompanionBuilder,
    $$FoodLogsTableUpdateCompanionBuilder,
    (FoodLog, BaseReferences<_$AppDatabase, $FoodLogsTable, FoodLog>),
    FoodLog,
    PrefetchHooks Function()>;
typedef $$WeightLogsTableCreateCompanionBuilder = WeightLogsCompanion Function({
  required String id,
  required double weightKg,
  required DateTime loggedAt,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$WeightLogsTableUpdateCompanionBuilder = WeightLogsCompanion Function({
  Value<String> id,
  Value<double> weightKg,
  Value<DateTime> loggedAt,
  Value<String?> notes,
  Value<int> rowid,
});

class $$WeightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$WeightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$WeightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WeightLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeightLogsTable,
    WeightLog,
    $$WeightLogsTableFilterComposer,
    $$WeightLogsTableOrderingComposer,
    $$WeightLogsTableAnnotationComposer,
    $$WeightLogsTableCreateCompanionBuilder,
    $$WeightLogsTableUpdateCompanionBuilder,
    (WeightLog, BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>),
    WeightLog,
    PrefetchHooks Function()> {
  $$WeightLogsTableTableManager(_$AppDatabase db, $WeightLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<DateTime> loggedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeightLogsCompanion(
            id: id,
            weightKg: weightKg,
            loggedAt: loggedAt,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required double weightKg,
            required DateTime loggedAt,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeightLogsCompanion.insert(
            id: id,
            weightKg: weightKg,
            loggedAt: loggedAt,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeightLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeightLogsTable,
    WeightLog,
    $$WeightLogsTableFilterComposer,
    $$WeightLogsTableOrderingComposer,
    $$WeightLogsTableAnnotationComposer,
    $$WeightLogsTableCreateCompanionBuilder,
    $$WeightLogsTableUpdateCompanionBuilder,
    (WeightLog, BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>),
    WeightLog,
    PrefetchHooks Function()>;
typedef $$WorkoutStreaksTableCreateCompanionBuilder = WorkoutStreaksCompanion
    Function({
  required String id,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastWorkoutDate,
  Value<int> rowid,
});
typedef $$WorkoutStreaksTableUpdateCompanionBuilder = WorkoutStreaksCompanion
    Function({
  Value<String> id,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastWorkoutDate,
  Value<int> rowid,
});

class $$WorkoutStreaksTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutStreaksTable> {
  $$WorkoutStreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastWorkoutDate => $composableBuilder(
      column: $table.lastWorkoutDate,
      builder: (column) => ColumnFilters(column));
}

class $$WorkoutStreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutStreaksTable> {
  $$WorkoutStreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastWorkoutDate => $composableBuilder(
      column: $table.lastWorkoutDate,
      builder: (column) => ColumnOrderings(column));
}

class $$WorkoutStreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutStreaksTable> {
  $$WorkoutStreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => column);

  GeneratedColumn<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastWorkoutDate => $composableBuilder(
      column: $table.lastWorkoutDate, builder: (column) => column);
}

class $$WorkoutStreaksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutStreaksTable,
    WorkoutStreak,
    $$WorkoutStreaksTableFilterComposer,
    $$WorkoutStreaksTableOrderingComposer,
    $$WorkoutStreaksTableAnnotationComposer,
    $$WorkoutStreaksTableCreateCompanionBuilder,
    $$WorkoutStreaksTableUpdateCompanionBuilder,
    (
      WorkoutStreak,
      BaseReferences<_$AppDatabase, $WorkoutStreaksTable, WorkoutStreak>
    ),
    WorkoutStreak,
    PrefetchHooks Function()> {
  $$WorkoutStreaksTableTableManager(
      _$AppDatabase db, $WorkoutStreaksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutStreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutStreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutStreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastWorkoutDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutStreaksCompanion(
            id: id,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastWorkoutDate: lastWorkoutDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastWorkoutDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutStreaksCompanion.insert(
            id: id,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastWorkoutDate: lastWorkoutDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkoutStreaksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutStreaksTable,
    WorkoutStreak,
    $$WorkoutStreaksTableFilterComposer,
    $$WorkoutStreaksTableOrderingComposer,
    $$WorkoutStreaksTableAnnotationComposer,
    $$WorkoutStreaksTableCreateCompanionBuilder,
    $$WorkoutStreaksTableUpdateCompanionBuilder,
    (
      WorkoutStreak,
      BaseReferences<_$AppDatabase, $WorkoutStreaksTable, WorkoutStreak>
    ),
    WorkoutStreak,
    PrefetchHooks Function()>;
typedef $$WaterLogsTableCreateCompanionBuilder = WaterLogsCompanion Function({
  required String id,
  required int amountMl,
  required DateTime loggedAt,
  Value<int> rowid,
});
typedef $$WaterLogsTableUpdateCompanionBuilder = WaterLogsCompanion Function({
  Value<String> id,
  Value<int> amountMl,
  Value<DateTime> loggedAt,
  Value<int> rowid,
});

class $$WaterLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMl => $composableBuilder(
      column: $table.amountMl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));
}

class $$WaterLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMl => $composableBuilder(
      column: $table.amountMl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));
}

class $$WaterLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$WaterLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WaterLogsTable,
    WaterLog,
    $$WaterLogsTableFilterComposer,
    $$WaterLogsTableOrderingComposer,
    $$WaterLogsTableAnnotationComposer,
    $$WaterLogsTableCreateCompanionBuilder,
    $$WaterLogsTableUpdateCompanionBuilder,
    (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
    WaterLog,
    PrefetchHooks Function()> {
  $$WaterLogsTableTableManager(_$AppDatabase db, $WaterLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> amountMl = const Value.absent(),
            Value<DateTime> loggedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WaterLogsCompanion(
            id: id,
            amountMl: amountMl,
            loggedAt: loggedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int amountMl,
            required DateTime loggedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WaterLogsCompanion.insert(
            id: id,
            amountMl: amountMl,
            loggedAt: loggedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WaterLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WaterLogsTable,
    WaterLog,
    $$WaterLogsTableFilterComposer,
    $$WaterLogsTableOrderingComposer,
    $$WaterLogsTableAnnotationComposer,
    $$WaterLogsTableCreateCompanionBuilder,
    $$WaterLogsTableUpdateCompanionBuilder,
    (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
    WaterLog,
    PrefetchHooks Function()>;
typedef $$ProgramEnrollmentsTableCreateCompanionBuilder
    = ProgramEnrollmentsCompanion Function({
  required String id,
  required String programId,
  required String programName,
  required DateTime startDate,
  Value<int> currentWeek,
  Value<int> currentDay,
  Value<bool> isActive,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$ProgramEnrollmentsTableUpdateCompanionBuilder
    = ProgramEnrollmentsCompanion Function({
  Value<String> id,
  Value<String> programId,
  Value<String> programName,
  Value<DateTime> startDate,
  Value<int> currentWeek,
  Value<int> currentDay,
  Value<bool> isActive,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$ProgramEnrollmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramEnrollmentsTable> {
  $$ProgramEnrollmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get programId => $composableBuilder(
      column: $table.programId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get programName => $composableBuilder(
      column: $table.programName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentDay => $composableBuilder(
      column: $table.currentDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$ProgramEnrollmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramEnrollmentsTable> {
  $$ProgramEnrollmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get programId => $composableBuilder(
      column: $table.programId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get programName => $composableBuilder(
      column: $table.programName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentDay => $composableBuilder(
      column: $table.currentDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProgramEnrollmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramEnrollmentsTable> {
  $$ProgramEnrollmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get programId =>
      $composableBuilder(column: $table.programId, builder: (column) => column);

  GeneratedColumn<String> get programName => $composableBuilder(
      column: $table.programName, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => column);

  GeneratedColumn<int> get currentDay => $composableBuilder(
      column: $table.currentDay, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$ProgramEnrollmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgramEnrollmentsTable,
    ProgramEnrollment,
    $$ProgramEnrollmentsTableFilterComposer,
    $$ProgramEnrollmentsTableOrderingComposer,
    $$ProgramEnrollmentsTableAnnotationComposer,
    $$ProgramEnrollmentsTableCreateCompanionBuilder,
    $$ProgramEnrollmentsTableUpdateCompanionBuilder,
    (
      ProgramEnrollment,
      BaseReferences<_$AppDatabase, $ProgramEnrollmentsTable, ProgramEnrollment>
    ),
    ProgramEnrollment,
    PrefetchHooks Function()> {
  $$ProgramEnrollmentsTableTableManager(
      _$AppDatabase db, $ProgramEnrollmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramEnrollmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramEnrollmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramEnrollmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> programId = const Value.absent(),
            Value<String> programName = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<int> currentWeek = const Value.absent(),
            Value<int> currentDay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgramEnrollmentsCompanion(
            id: id,
            programId: programId,
            programName: programName,
            startDate: startDate,
            currentWeek: currentWeek,
            currentDay: currentDay,
            isActive: isActive,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String programId,
            required String programName,
            required DateTime startDate,
            Value<int> currentWeek = const Value.absent(),
            Value<int> currentDay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgramEnrollmentsCompanion.insert(
            id: id,
            programId: programId,
            programName: programName,
            startDate: startDate,
            currentWeek: currentWeek,
            currentDay: currentDay,
            isActive: isActive,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProgramEnrollmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgramEnrollmentsTable,
    ProgramEnrollment,
    $$ProgramEnrollmentsTableFilterComposer,
    $$ProgramEnrollmentsTableOrderingComposer,
    $$ProgramEnrollmentsTableAnnotationComposer,
    $$ProgramEnrollmentsTableCreateCompanionBuilder,
    $$ProgramEnrollmentsTableUpdateCompanionBuilder,
    (
      ProgramEnrollment,
      BaseReferences<_$AppDatabase, $ProgramEnrollmentsTable, ProgramEnrollment>
    ),
    ProgramEnrollment,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$ExercisesTableTableTableManager get exercisesTable =>
      $$ExercisesTableTableTableManager(_db, _db.exercisesTable);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
  $$FoodLogsTableTableManager get foodLogs =>
      $$FoodLogsTableTableManager(_db, _db.foodLogs);
  $$WeightLogsTableTableManager get weightLogs =>
      $$WeightLogsTableTableManager(_db, _db.weightLogs);
  $$WorkoutStreaksTableTableManager get workoutStreaks =>
      $$WorkoutStreaksTableTableManager(_db, _db.workoutStreaks);
  $$WaterLogsTableTableManager get waterLogs =>
      $$WaterLogsTableTableManager(_db, _db.waterLogs);
  $$ProgramEnrollmentsTableTableManager get programEnrollments =>
      $$ProgramEnrollmentsTableTableManager(_db, _db.programEnrollments);
}
