import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/forgot_password_screen.dart';
import '../../features/authentication/login_screen.dart';
import '../../features/authentication/register_screen.dart';
import '../../features/authentication/welcome_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/friends/friends_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/missions/missions_screen.dart';
import '../../features/navigation/main_shell_scaffold.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/workout/workout_active_screen.dart';
import '../../features/workout/workout_detail_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Splash Route
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding & Auth Routes
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Workout Flow Routes
    GoRoute(
      path: '/workout/prep/:exerciseId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final exerciseId = state.pathParameters['exerciseId'] ?? 'push_up';
        return WorkoutDetailScreen(exerciseId: exerciseId);
      },
    ),
    GoRoute(
      path: '/workout/active/:exerciseId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final exerciseId = state.pathParameters['exerciseId'] ?? 'push_up';
        return WorkoutActiveScreen(exerciseId: exerciseId);
      },
    ),

    // Main 5-Tab Persistent Shell Navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home / Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        // Tab 1: Missions
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/missions',
              builder: (context, state) => const MissionsScreen(),
            ),
          ],
        ),

        // Tab 2: Leaderboard / Ranks
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/leaderboard',
              builder: (context, state) => const LeaderboardScreen(),
            ),
          ],
        ),

        // Tab 3: Friends
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/friends',
              builder: (context, state) => const FriendsScreen(),
            ),
          ],
        ),

        // Tab 4: Profile & Character Sheet
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

