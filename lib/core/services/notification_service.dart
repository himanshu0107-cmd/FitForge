import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:fitforge/core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: iOS),
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Create notification channels (Android)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            AppConstants.workoutChannelId,
            'Workout Reminders',
            description: 'Daily workout reminder notifications',
            importance: Importance.high,
          ),
        );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            AppConstants.timerChannelId,
            'Timer Alerts',
            description: 'Rest timer completion alerts',
            importance: Importance.max,
          ),
        );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            AppConstants.waterChannelId,
            'Water Reminders',
            description: 'Hydration reminder notifications',
            importance: Importance.defaultImportance,
          ),
        );

    _initialized = true;
  }

  // ─────────────────────────────────────────
  // REST TIMER NOTIFICATION
  // ─────────────────────────────────────────

  Future<void> showRestTimerComplete() async {
    await _plugin.show(
      AppConstants.restTimerNotifId,
      '⏱️ Rest Complete!',
      'Time to get back to work. Next set ready!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.timerChannelId,
          'Timer Alerts',
          channelDescription: 'Rest timer completion alerts',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // DAILY WORKOUT REMINDER
  // ─────────────────────────────────────────

  Future<void> scheduleWorkoutReminder({
    required int hour,
    required int minute,
  }) async {
    await _plugin.cancelAll(); // Cancel existing workout reminders

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      AppConstants.workoutReminderId,
      '🔥 Time to FitForge!',
      'Your daily workout is waiting. Let\'s crush it!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.workoutChannelId,
          'Workout Reminders',
          channelDescription: 'Daily workout reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ─────────────────────────────────────────
  // WATER REMINDERS (every 2 hours)
  // ─────────────────────────────────────────

  Future<void> scheduleWaterReminders() async {
    // Cancel any existing water reminders
    for (int i = 0; i < 8; i++) {
      await _plugin.cancel(AppConstants.waterReminderBaseId + i);
    }

    final now = tz.TZDateTime.now(tz.local);
    // Schedule from 8am to 10pm every 2 hours
    final hours = [8, 10, 12, 14, 16, 18, 20, 22];

    for (int i = 0; i < hours.length; i++) {
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hours[i],
        0,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        AppConstants.waterReminderBaseId + i,
        '💧 Hydration Reminder',
        'Don\'t forget to drink water! Staying hydrated boosts performance.',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.waterChannelId,
            'Water Reminders',
            channelDescription: 'Hydration reminder notifications',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelWaterReminders() async {
    for (int i = 0; i < 8; i++) {
      await _plugin.cancel(AppConstants.waterReminderBaseId + i);
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? true;
  }
}
