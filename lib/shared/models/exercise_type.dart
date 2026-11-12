import 'package:flutter/material.dart';

enum ExerciseType {
  pushUp(
    id: 'push_up',
    displayName: 'Push-ups',
    unit: 'reps',
    defaultTarget: 15,
    xpReward: 20,
    icon: Icons.fitness_center_rounded,
    description: 'Arm angle tracking, chest downward stroke to 90 degrees and full lock-out.',
  ),
  squat(
    id: 'squat',
    displayName: 'Squats',
    unit: 'reps',
    defaultTarget: 25,
    xpReward: 20,
    icon: Icons.airline_seat_legroom_extra_rounded,
    description: 'Hip, knee and ankle tracking. Thighs parallel to floor for full rep.',
  ),
  sitUp(
    id: 'sit_up',
    displayName: 'Sit-ups',
    unit: 'reps',
    defaultTarget: 20,
    xpReward: 20,
    icon: Icons.accessibility_new_rounded,
    description: 'Torso flexion tracking from flat back to 70-degree upward peak.',
  ),
  plank(
    id: 'plank',
    displayName: 'Plank',
    unit: 'sec',
    defaultTarget: 30,
    xpReward: 15,
    icon: Icons.horizontal_rule_rounded,
    description: 'Continuous shoulder-hip-ankle linear alignment hold timer.',
  ),
  jumpingJack(
    id: 'jumping_jack',
    displayName: 'Jumping Jacks',
    unit: 'reps',
    defaultTarget: 30,
    xpReward: 15,
    icon: Icons.directions_run_rounded,
    description: 'Simultaneous arm and leg lateral abduction and return cycle.',
  );

  const ExerciseType({
    required this.id,
    required this.displayName,
    required this.unit,
    required this.defaultTarget,
    required this.xpReward,
    required this.icon,
    required this.description,
  });

  final String id;
  final String displayName;
  final String unit;
  final int defaultTarget;
  final int xpReward;
  final IconData icon;
  final String description;

  static ExerciseType fromId(String id) {
    return ExerciseType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => ExerciseType.pushUp,
    );
  }
}

