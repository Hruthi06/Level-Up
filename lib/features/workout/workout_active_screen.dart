import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/models/exercise_type.dart';
import '../../shared/widgets/neon_button.dart';

class WorkoutActiveScreen extends ConsumerStatefulWidget {
  final String exerciseId;

  const WorkoutActiveScreen({super.key, required this.exerciseId});

  @override
  ConsumerState<WorkoutActiveScreen> createState() => _WorkoutActiveScreenState();
}

class _WorkoutActiveScreenState extends ConsumerState<WorkoutActiveScreen> {
  late ExerciseType _exercise;
  int _targetReps = 15;
  int _completedReps = 0;
  int _rejectedReps = 0;
  int _currentAngle = 168; // Joint angle in degrees
  String _currentPhase = 'READY';
  String _coachFeedback = 'Body detected! Align shoulders and begin.';
  bool _isFinished = false;
  Timer? _simulationTimer;
  int _elapsedSeconds = 0;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    _exercise = ExerciseType.fromId(widget.exerciseId);
    _targetReps = _exercise.defaultTarget;

    // Start workout duration timer
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_isFinished) {
        setState(() => _elapsedSeconds++);
      }
    });

    // Start simulated AI pose estimation stream for realistic interactive verification
    _startSimulatedPoseStream();
  }

  void _startSimulatedPoseStream() {
    // Biomechanical cycle simulator: simulates descending -> bottom threshold -> ascending -> rep count
    int angleStep = 0;
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 140), (timer) {
      if (!mounted || _isFinished) return;

      setState(() {
        angleStep++;
        final cyclePosition = angleStep % 24;

        if (cyclePosition < 10) {
          // Downward stroke: angle decreases from 165 to 85
          _currentAngle = 165 - (cyclePosition * 8);
          _currentPhase = 'DESCENDING';
          _coachFeedback = 'Lower down steadily...';
        } else if (cyclePosition == 10 || cyclePosition == 11) {
          // Bottom inflection point
          _currentAngle = 84;
          _currentPhase = 'DEPTH REACHED (84°)';
          _coachFeedback = 'Good depth! Press back up!';
        } else if (cyclePosition < 22) {
          // Upward stroke: angle increases from 85 to 165
          _currentAngle = 84 + ((cyclePosition - 11) * 8);
          _currentPhase = 'ASCENDING';
          _coachFeedback = 'Power up to full extension!';
        } else {
          // Rep completed at full lock-out
          _currentAngle = 166;
          _currentPhase = 'REP VERIFIED!';
          _coachFeedback = 'Great repetition! Keep your cadence.';
          if (cyclePosition == 22) {
            _onRepetitionVerified();
          }
        }
      });
    });
  }

  void _onRepetitionVerified() {
    _completedReps++;
    if (_completedReps >= _targetReps) {
      _isFinished = true;
      _simulationTimer?.cancel();
      _durationTimer?.cancel();

      // Find mission and complete it in repository
      final state = ref.read(fitnessProvider);
      final mission = state.dailyMissions.firstWhere(
        (m) => m.exerciseType == _exercise,
        orElse: () => state.dailyMissions.first,
      );
      ref.read(fitnessProvider.notifier).completeMission(mission.id);

      // Show celebration dialog
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppColors.neonLime, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonLime.withOpacity(0.3),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: AppColors.neonLime, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'MISSION COMPLETED!',
                style: AppTypography.displaySmall.copyWith(color: AppColors.neonLime),
              ),
              const SizedBox(height: 6),
              Text(
                'AI Form Verification: 100% Validated',
                style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 14),
              Text(
                'You completed $_completedReps ${_exercise.unit} of ${_exercise.displayName} in $_elapsedSeconds seconds and earned +${_exercise.xpReward} XP!',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              NeonButton(
                text: 'CLAIM REWARD & RETURN',
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go('/dashboard');
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _durationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera Mock Background (Cyber Grid & Body Pose Skeleton)
            _buildCameraViewfinder(),

            // Top HUD: Timer, Exercise Name, Quit Button
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildTopHud(),
            ),

            // Center Dynamic Pose Guidance & Angle Indicator
            Center(
              child: _buildPoseLandmarkOverlay(),
            ),

            // Bottom HUD: Big Rep Counter, Phase Tag, Coach Feedback Banner
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: _buildBottomHud(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraViewfinder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=1200&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: CustomPaint(
        painter: CyberGridPainter(),
      ),
    );
  }

  Widget _buildTopHud() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Exercise Name & Live Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.alertRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AI LIVE • ${_exercise.displayName.toUpperCase()}',
                style: AppTypography.labelLarge.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),

        // Session Time
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.timer_outlined, color: AppColors.neonLime, size: 16),
              const SizedBox(width: 6),
              Text(
                '${(_elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
                style: AppTypography.statNumber.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),

        // Stop Button
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.7),
            side: const BorderSide(color: AppColors.border),
          ),
          icon: const Icon(Icons.close, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  Widget _buildPoseLandmarkOverlay() {
    return Container(
      width: 280,
      height: 340,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.electricCyan.withOpacity(0.4), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Corner Targeting Reticles
          Positioned(top: 8, left: 8, child: _cornerIcon()),
          Positioned(top: 8, right: 8, child: _cornerIcon()),
          Positioned(bottom: 8, left: 8, child: _cornerIcon()),
          Positioned(bottom: 8, right: 8, child: _cornerIcon()),

          // Angle Badge Floating in FOV
          Positioned(
            top: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _currentAngle <= 90 ? AppColors.neonLime : AppColors.electricCyan,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.straighten_rounded,
                    color: _currentAngle <= 90 ? AppColors.neonLime : AppColors.electricCyan,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'JOINT ANGLE: $_currentAngle°',
                    style: AppTypography.labelLarge.copyWith(
                      color: _currentAngle <= 90 ? AppColors.neonLime : AppColors.electricCyan,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Skeleton Stick Figure Visualization
          CustomPaint(
            size: const Size(220, 220),
            painter: SkeletonPainter(angle: _currentAngle),
          ),
        ],
      ),
    );
  }

  Widget _cornerIcon() {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neonLime, width: 2),
      ),
    );
  }

  Widget _buildBottomHud() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // AI Coach Message Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.neonLime.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.smart_toy_rounded, color: AppColors.neonLime, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _coachFeedback,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Rep Counter and Phase Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.neonLime, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonLime.withOpacity(0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MOVEMENT PHASE',
                    style: AppTypography.labelLarge.copyWith(fontSize: 10, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentPhase,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.neonLime,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$_completedReps',
                    style: AppTypography.statNumber.copyWith(fontSize: 48),
                  ),
                  Text(
                    ' / $_targetReps',
                    style: AppTypography.displaySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonLime.withOpacity(0.05)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SkeletonPainter extends CustomPainter {
  final int angle;

  SkeletonPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final jointPaint = Paint()
      ..color = AppColors.neonLime
      ..style = PaintingStyle.fill;

    final bonePaint = Paint()
      ..color = AppColors.electricCyan
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    // Dynamic elbow flexion based on angle
    final flexFraction = (180 - angle) / 90.0;
    final elbowOffset = Offset(center.dx - 40 - (flexFraction * 20), center.dy + 10);
    final wristOffset = Offset(center.dx - 30, center.dy + 60);
    final shoulderOffset = Offset(center.dx - 10, center.dy - 30);

    // Draw arm bones
    canvas.drawLine(shoulderOffset, elbowOffset, bonePaint);
    canvas.drawLine(elbowOffset, wristOffset, bonePaint);

    // Draw joints
    canvas.drawCircle(shoulderOffset, 6, jointPaint);
    canvas.drawCircle(elbowOffset, 6, jointPaint);
    canvas.drawCircle(wristOffset, 6, jointPaint);
  }

  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) => oldDelegate.angle != angle;
}

