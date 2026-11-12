import 'exercise_type.dart';

enum MissionCategory {
  daily,
  weekly,
  bonus,
  challenge,
}

enum MissionStatus {
  pending,
  inProgress,
  completed,
}

class MissionModel {
  final String id;
  final String title;
  final String description;
  final ExerciseType exerciseType;
  final int target;
  final int progress;
  final int xpReward;
  final MissionCategory category;
  final MissionStatus status;
  final bool verifiedByAi;
  final DateTime? completedAt;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.exerciseType,
    required this.target,
    this.progress = 0,
    required this.xpReward,
    this.category = MissionCategory.daily,
    this.status = MissionStatus.pending,
    this.verifiedByAi = true,
    this.completedAt,
  });

  bool get isCompleted => status == MissionStatus.completed || progress >= target;

  double get progressPercentage {
    if (target <= 0) return 0.0;
    final val = progress / target;
    return val > 1.0 ? 1.0 : val;
  }

  MissionModel copyWith({
    String? id,
    String? title,
    String? description,
    ExerciseType? exerciseType,
    int? target,
    int? progress,
    int? xpReward,
    MissionCategory? category,
    MissionStatus? status,
    bool? verifiedByAi,
    DateTime? completedAt,
  }) {
    return MissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      exerciseType: exerciseType ?? this.exerciseType,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      xpReward: xpReward ?? this.xpReward,
      category: category ?? this.category,
      status: status ?? this.status,
      verifiedByAi: verifiedByAi ?? this.verifiedByAi,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

