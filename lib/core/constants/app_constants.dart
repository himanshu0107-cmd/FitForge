// App-wide constants
class AppConstants {
  AppConstants._();

  static const appName = 'FitForge';
  static const appVersion = '1.0.0';

  // SharedPreferences Keys
  static const kOnboardingComplete = 'onboarding_complete';
  static const kUserId = 'user_id';
  static const kThemeMode = 'theme_mode';
  static const kNotificationsEnabled = 'notifications_enabled';
  static const kWaterReminderEnabled = 'water_reminder_enabled';
  static const kWorkoutReminderTime = 'workout_reminder_time';

  // Default values
  static const defaultRestSeconds = 90;
  static const defaultSets = 3;
  static const defaultReps = 10;

  // Notification IDs
  static const workoutReminderId = 1001;
  static const restTimerNotifId = 1002;
  static const waterReminderBaseId = 2000;

  // Notification channel IDs
  static const workoutChannelId = 'workout_channel';
  static const timerChannelId = 'timer_channel';
  static const waterChannelId = 'water_channel';

  // Assets
  static const exercisesAsset = 'assets/exercises.json';
  static const pplProgramAsset = 'assets/programs/ppl.json';
  static const fullBodyProgramAsset = 'assets/programs/full_body.json';
  static const footballProgramAsset = 'assets/programs/football.json';
  static const boxingProgramAsset = 'assets/programs/boxing.json';
  static const runningProgramAsset = 'assets/programs/running_5k.json';
  static const bulkingMealAsset = 'assets/meal_plans/bulking.json';
  static const cuttingMealAsset = 'assets/meal_plans/cutting.json';
  static const maintenanceMealAsset = 'assets/meal_plans/maintenance.json';
}

// Route names
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const exercises = '/exercises';
  static const exerciseDetail = '/exercises/:id';
  static const workoutSession = '/workout/session';
  static const workoutSummary = '/workout/summary';
  static const timer = '/timer';
  static const diet = '/diet';
  static const progress = '/progress';
  static const programs = '/programs';
  static const programDetail = '/programs/:id';
  static const profile = '/profile';
}
