import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/neon_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),

              // Hero Visual
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.neonLime, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonLime.withOpacity(0.3),
                        blurRadius: 36,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.fitness_center_rounded,
                      size: 64,
                      color: AppColors.neonLime,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              Text(
                'WELCOME TO\n${AppConstants.appName}',
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge.copyWith(height: 1.1),
              ),
              const SizedBox(height: 16),

              Text(
                'Transform your real-world workouts into RPG level progression. Powered by on-device computer vision verification.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge,
              ),

              const Spacer(flex: 2),

              // Feature Highlights Row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFeatureItem(Icons.videocam_rounded, 'AI VISION'),
                    Container(height: 28, width: 1, color: AppColors.border),
                    _buildFeatureItem(Icons.military_tech_rounded, 'RPG RANKS'),
                    Container(height: 28, width: 1, color: AppColors.border),
                    _buildFeatureItem(Icons.local_fire_department_rounded, 'STREAKS'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              NeonButton(
                text: 'START NEW GAME',
                icon: Icons.play_arrow_rounded,
                onPressed: () => context.push('/register'),
              ),
              const SizedBox(height: 14),

              NeonButton(
                text: 'LOGIN EXISTING ACCOUNT',
                variant: NeonButtonVariant.secondary,
                onPressed: () => context.push('/login'),
              ),
              const SizedBox(height: 14),

              // Instant Demo Mode option (allows instant evaluation without credentials)
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: Text(
                  'ENTER QUICK DEMO MODE (SKIP AUTH)',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.neonLime, size: 22),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            fontSize: 11,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

