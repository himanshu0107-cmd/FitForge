import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/features/onboarding/screens/onboarding_screen.dart';
import 'package:fitforge/features/home/screens/home_screen.dart';
import 'package:fitforge/features/workout/screens/exercise_library_screen.dart';
import 'package:fitforge/features/workout/screens/exercise_detail_screen.dart';
import 'package:fitforge/features/workout/screens/workout_session_screen.dart';
import 'package:fitforge/features/workout/screens/workout_summary_screen.dart';
import 'package:fitforge/features/timer/screens/timer_hub_screen.dart';
import 'package:fitforge/features/diet/screens/diet_screen.dart';
import 'package:fitforge/features/progress/screens/progress_screen.dart';
import 'package:fitforge/features/programs/screens/programs_screen.dart';
import 'package:fitforge/features/programs/screens/program_detail_screen.dart';
import 'package:fitforge/features/profile/screens/profile_screen.dart';
import 'package:fitforge/features/shell/main_shell.dart';
import 'package:fitforge/features/shell/splash_screen.dart';
import 'package:fitforge/domain/models/workout.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // Splash — checks onboarding and redirects
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding — full screen
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Main shell with bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'exercises',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const ExerciseLibraryScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => ExerciseDetailScreen(
                    exerciseId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.timer,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TimerHubScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.diet,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DietScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.progress,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProgressScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.programs,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProgramsScreen(),
          ),
        ),
      ],
    ),

    // Full-screen routes (no shell)
    GoRoute(
      path: AppRoutes.workoutSession,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return WorkoutSessionScreen(
          workoutName: extra?['workoutName'] as String? ?? 'Workout',
          exercises: (extra?['exercises'] as List<dynamic>?)
                  ?.cast<PlannedExercise>() ??
              [],
          planId: extra?['planId'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.workoutSummary,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final session = state.extra as WorkoutSession?;
        return WorkoutSummaryScreen(session: session);
      },
    ),
    GoRoute(
      path: '/programs/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => ProgramDetailScreen(
        programId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
