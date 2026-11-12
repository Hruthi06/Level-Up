import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/models/exercise_type.dart';
import '../../shared/widgets/neon_button.dart';
import '../../shared/widgets/neon_card.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const WorkoutDetailScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = ExerciseType.fromId(exerciseId);
    final state = ref.watch(fitnessProvider);
    final mission = state.dailyMissions.firstWhere(
      (m) => m.exerciseType == exercise,
      orElse: () => state.dailyMissions.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(exercise.displayName.toUpperCase(), style: AppTypography.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Exercise Hero Banner
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonLime.withOpacity(0.4)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        exercise.icon,
                        size: 80,
                        color: AppColors.neonLime.withOpacity(0.85),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.neonLime),
                        ),
                        child: Text(
                          '+${mission.xpReward} XP REWARD',
                          style: AppTypography.labelLarge.copyWith(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Target Summary Metrics
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'MISSION TARGET',
                      value: '${mission.target}',
                      unit: exercise.unit.toUpperCase(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'VERIFICATION',
                      value: 'AI VISION',
                      unit: 'MEDIAPIPE',
                      isHighlight: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form Requirements
              Text('BIOMECHANICAL STANDARDS', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
              const SizedBox(height: 10),
              NeonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckItem('Full Depth / Extension', 'Arm elbows must bend to <= 90° for valid depth credit.'),
                    const SizedBox(height: 12),
                    _buildCheckItem('Full Lock-Out', 'Must return fully to top position (>= 160°) to close the rep cycle.'),
                    const SizedBox(height: 12),
                    _buildCheckItem('Spine Alignment', 'Torso and hips must stay in a straight rigid plane.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Camera Setup Guidance
              Text('CAMERA POSITIONING PROTOCOL', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildGuidelineRow(Icons.straighten_rounded, 'Distance', 'Place phone 6 to 8 feet away so entire body is in frame.'),
                    const Divider(height: 24),
                    _buildGuidelineRow(Icons.wb_sunny_outlined, 'Lighting', 'Ensure room is well-lit; avoid strong backlighting.'),
                    const Divider(height: 24),
                    _buildGuidelineRow(Icons.crop_rotate_rounded, 'Orientation', 'Place device in horizontal or upright portrait angle.'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Launch Workout Button
              NeonButton(
                text: 'LAUNCH AI WORKOUT TRACKER',
                icon: Icons.videocam_rounded,
                onPressed: () {
                  context.push('/workout/active/${exercise.id}');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String unit,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlight ? AppColors.neonLime.withOpacity(0.5) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelLarge.copyWith(fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.statNumber.copyWith(
                  fontSize: 22,
                  color: isHighlight ? AppColors.neonLime : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(unit, style: AppTypography.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline_rounded, color: AppColors.neonLime, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(desc, style: AppTypography.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelineRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.neonLime, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.titleMedium.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(value, style: AppTypography.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

