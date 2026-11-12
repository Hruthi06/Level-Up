class FitnessPreferences {
  final String experience; // beginner, intermediate, advanced
  final String primaryGoal; // strength, endurance, consistency
  final int weeklyWorkoutDays;
  final String preferredDifficulty;

  const FitnessPreferences({
    this.experience = 'Beginner',
    this.primaryGoal = 'Strength & Muscle',
    this.weeklyWorkoutDays = 5,
    this.preferredDifficulty = 'Warrior',
  });

  FitnessPreferences copyWith({
    String? experience,
    String? primaryGoal,
    int? weeklyWorkoutDays,
    String? preferredDifficulty,
  }) {
    return FitnessPreferences(
      experience: experience ?? this.experience,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      weeklyWorkoutDays: weeklyWorkoutDays ?? this.weeklyWorkoutDays,
      preferredDifficulty: preferredDifficulty ?? this.preferredDifficulty,
    );
  }
}

class UserStats {
  final int totalWorkouts;
  final int totalValidReps;
  final int totalMinutes;
  final double formAccuracy;

  const UserStats({
    this.totalWorkouts = 45,
    this.totalValidReps = 1420,
    this.totalMinutes = 304,
    this.formAccuracy = 92.4,
  });

  UserStats copyWith({
    int? totalWorkouts,
    int? totalValidReps,
    int? totalMinutes,
    double? formAccuracy,
  }) {
    return UserStats(
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalValidReps: totalValidReps ?? this.totalValidReps,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      formAccuracy: formAccuracy ?? this.formAccuracy,
    );
  }
}

class UserProfile {
  final String uid;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final int level;
  final int currentXp;
  final int xpToNextLevel;
  final String rankTitle;
  final int currentStreak;
  final int longestStreak;
  final FitnessPreferences preferences;
  final UserStats stats;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.level = 8,
    this.currentXp = 1250,
    this.xpToNextLevel = 1500,
    this.rankTitle = 'Warrior',
    this.currentStreak = 12,
    this.longestStreak = 18,
    this.preferences = const FitnessPreferences(),
    this.stats = const UserStats(),
  });

  double get xpProgressPercentage {
    if (xpToNextLevel <= 0) return 1.0;
    final pct = currentXp / xpToNextLevel;
    return pct.clamp(0.0, 1.0);
  }

  UserProfile copyWith({
    String? uid,
    String? username,
    String? displayName,
    String? avatarUrl,
    int? level,
    int? currentXp,
    int? xpToNextLevel,
    String? rankTitle,
    int? currentStreak,
    int? longestStreak,
    FitnessPreferences? preferences,
    UserStats? stats,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      rankTitle: rankTitle ?? this.rankTitle,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

