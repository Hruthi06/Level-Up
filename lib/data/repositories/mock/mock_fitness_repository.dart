import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../shared/models/achievement_model.dart';
import '../../../shared/models/exercise_type.dart';
import '../../../shared/models/mission_model.dart';
import '../../../shared/models/user_profile.dart';

class MockFitnessState {
  final UserProfile profile;
  final List<MissionModel> dailyMissions;
  final List<MissionModel> weeklyMissions;
  final List<AchievementModel> achievements;
  final List<Map<String, dynamic>> leaderboard;
  final List<Map<String, dynamic>> friends;

  const MockFitnessState({
    required this.profile,
    required this.dailyMissions,
    required this.weeklyMissions,
    required this.achievements,
    required this.leaderboard,
    required this.friends,
  });

  MockFitnessState copyWith({
    UserProfile? profile,
    List<MissionModel>? dailyMissions,
    List<MissionModel>? weeklyMissions,
    List<AchievementModel>? achievements,
    List<Map<String, dynamic>>? leaderboard,
    List<Map<String, dynamic>>? friends,
  }) {
    return MockFitnessState(
      profile: profile ?? this.profile,
      dailyMissions: dailyMissions ?? this.dailyMissions,
      weeklyMissions: weeklyMissions ?? this.weeklyMissions,
      achievements: achievements ?? this.achievements,
      leaderboard: leaderboard ?? this.leaderboard,
      friends: friends ?? this.friends,
    );
  }
}

class MockFitnessNotifier extends StateNotifier<MockFitnessState> {
  MockFitnessNotifier() : super(_initialState);

  static final MockFitnessState _initialState = MockFitnessState(
    profile: const UserProfile(
      uid: 'demo_user_1',
      username: 'PlayerOne',
      displayName: 'Hruthik',
      level: 8,
      currentXp: 1250,
      xpToNextLevel: 1500,
      rankTitle: 'Warrior',
      currentStreak: 12,
      longestStreak: 15,
      preferences: FitnessPreferences(
        experience: 'Beginner',
        primaryGoal: 'Strength & Stamina',
        weeklyWorkoutDays: 5,
        preferredDifficulty: 'Heroic',
      ),
      stats: UserStats(
        totalWorkouts: 45,
        totalValidReps: 1420,
        totalMinutes: 304,
        formAccuracy: 91.8,
      ),
    ),
    dailyMissions: [
      const MissionModel(
        id: 'm1',
        title: 'Morning Upper Body',
        description: 'Perform 15 clean push-ups verified with AI form tracking.',
        exerciseType: ExerciseType.pushUp,
        target: 15,
        progress: 15,
        xpReward: 20,
        status: MissionStatus.completed,
      ),
      const MissionModel(
        id: 'm2',
        title: 'Leg Power Foundation',
        description: 'Complete 25 deep bodyweight squats with 90-degree knee bend.',
        exerciseType: ExerciseType.squat,
        target: 25,
        progress: 25,
        xpReward: 20,
        status: MissionStatus.completed,
      ),
      const MissionModel(
        id: 'm3',
        title: 'Core Fortress',
        description: 'Execute 20 full-range sit-ups with shoulders elevating to 70 degrees.',
        exerciseType: ExerciseType.sitUp,
        target: 20,
        progress: 0,
        xpReward: 20,
        status: MissionStatus.pending,
      ),
      const MissionModel(
        id: 'm4',
        title: 'Isometric Shield',
        description: 'Hold a verified straight plank pose for 30 consecutive seconds.',
        exerciseType: ExerciseType.plank,
        target: 30,
        progress: 0,
        xpReward: 15,
        status: MissionStatus.pending,
      ),
      const MissionModel(
        id: 'm5',
        title: 'Cardio Ignition',
        description: 'Perform 30 explosive jumping jacks with full lateral arm extension.',
        exerciseType: ExerciseType.jumpingJack,
        target: 30,
        progress: 0,
        xpReward: 15,
        status: MissionStatus.pending,
      ),
    ],
    weeklyMissions: [
      const MissionModel(
        id: 'w1',
        title: 'Iron Legion (150 Push-ups)',
        description: 'Accumulate 150 verified push-ups across the week.',
        exerciseType: ExerciseType.pushUp,
        target: 150,
        progress: 95,
        xpReward: 120,
        category: MissionCategory.weekly,
      ),
      const MissionModel(
        id: 'w2',
        title: 'Century Squat Challenge',
        description: 'Crush 200 squats over 7 days.',
        exerciseType: ExerciseType.squat,
        target: 200,
        progress: 140,
        xpReward: 150,
        category: MissionCategory.weekly,
      ),
    ],
    achievements: [
      const AchievementModel(
        id: 'ach_1',
        title: 'First Blood',
        description: 'Complete your first AI-verified workout session.',
        icon: Icons.flash_on_rounded,
        isUnlocked: true,
        xpBonus: 50,
      ),
      const AchievementModel(
        id: 'ach_2',
        title: 'Iron Discipline',
        description: 'Maintain an uninterrupted 7-day workout streak.',
        icon: Icons.local_fire_department_rounded,
        isUnlocked: true,
        xpBonus: 100,
      ),
      const AchievementModel(
        id: 'ach_3',
        title: 'Centurion',
        description: 'Log over 1,000 total valid repetitions.',
        icon: Icons.military_tech_rounded,
        isUnlocked: true,
        xpBonus: 200,
      ),
      const AchievementModel(
        id: 'ach_4',
        title: 'Discipline Master',
        description: 'Reach a consecutive 30-day workout streak.',
        icon: Icons.shield_rounded,
        isUnlocked: false,
        xpBonus: 500,
      ),
      const AchievementModel(
        id: 'ach_5',
        title: 'Mythic Vanguard',
        description: 'Ascend to Level 50 and claim the Legend title.',
        icon: Icons.workspace_premium_rounded,
        isUnlocked: false,
        xpBonus: 1000,
      ),
    ],
    leaderboard: [
      {'rank': 1, 'username': 'Valkyrie99', 'level': 14, 'xp': 4890, 'streak': 24, 'isUser': false},
      {'rank': 2, 'username': 'KageShadow', 'level': 12, 'xp': 3910, 'streak': 19, 'isUser': false},
      {'rank': 3, 'username': 'PlayerOne (You)', 'level': 8, 'xp': 1250, 'streak': 12, 'isUser': true},
      {'rank': 4, 'username': 'ZenithBlade', 'level': 7, 'xp': 980, 'streak': 9, 'isUser': false},
      {'rank': 5, 'username': 'RoninFit', 'level': 6, 'xp': 760, 'streak': 5, 'isUser': false},
    ],
    friends: [
      {'username': 'Alex_Blade', 'level': 9, 'rank': 'Warrior', 'streak': 14, 'isOnline': true},
      {'username': 'MayaRaptor', 'level': 11, 'rank': 'Champion', 'streak': 21, 'isOnline': true},
      {'username': 'DavidGym', 'level': 5, 'rank': 'Beginner', 'streak': 4, 'isOnline': false},
    ],
  );

  void completeMission(String missionId) {
    final updatedMissions = state.dailyMissions.map((m) {
      if (m.id == missionId) {
        return m.copyWith(
          progress: m.target,
          status: MissionStatus.completed,
          completedAt: DateTime.now(),
        );
      }
      return m;
    }).toList();

    final targetMission = state.dailyMissions.firstWhere((m) => m.id == missionId);
    final earnedXp = targetMission.xpReward;

    var newXp = state.profile.currentXp + earnedXp;
    var newLevel = state.profile.level;
    var newXpToNext = state.profile.xpToNextLevel;
    var newRank = state.profile.rankTitle;

    if (newXp >= newXpToNext) {
      newLevel += 1;
      newXp = newXp - newXpToNext;
      newXpToNext = (100 * (newLevel * 1.35)).round();
      if (newLevel >= 10) newRank = 'Warrior';
      if (newLevel >= 20) newRank = 'Champion';
      if (newLevel >= 30) newRank = 'Elite';
    }

    final updatedProfile = state.profile.copyWith(
      currentXp: newXp,
      level: newLevel,
      xpToNextLevel: newXpToNext,
      rankTitle: newRank,
      stats: state.profile.stats.copyWith(
        totalValidReps: state.profile.stats.totalValidReps + targetMission.target,
        totalWorkouts: state.profile.stats.totalWorkouts + 1,
      ),
    );

    state = state.copyWith(
      dailyMissions: updatedMissions,
      profile: updatedProfile,
    );
  }

  void updateProfilePreferences(FitnessPreferences prefs) {
    state = state.copyWith(
      profile: state.profile.copyWith(preferences: prefs),
    );
  }
}

final fitnessProvider = StateNotifierProvider<MockFitnessNotifier, MockFitnessState>((ref) {
  return MockFitnessNotifier();
});

