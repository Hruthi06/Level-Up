import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/models/user_profile.dart';
import '../../shared/widgets/neon_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;

  // Selected values
  String _selectedExperience = 'Beginner';
  String _selectedGoal = 'Strength & Stamina';
  int _selectedDays = 5;
  String _selectedDifficulty = 'Warrior';

  final List<String> _experiences = ['Beginner (0-6 months)', 'Intermediate (6-24 months)', 'Advanced (2+ years)'];
  final List<String> _goals = ['Strength & Stamina', 'Core Definition & Abs', 'Daily Consistency', 'Calorie Burn & Weight Cut'];
  final List<int> _daysList = [3, 4, 5, 6];
  final List<String> _difficulties = ['Standard (Rookie)', 'Challenging (Warrior)', 'Intense (Heroic)'];

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Save preferences to provider and proceed to main app
      final updatedPrefs = FitnessPreferences(
        experience: _selectedExperience,
        primaryGoal: _selectedGoal,
        weeklyWorkoutDays: _selectedDays,
        preferredDifficulty: _selectedDifficulty,
      );
      ref.read(fitnessProvider.notifier).updateProfilePreferences(updatedPrefs);
      context.go('/dashboard');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('FITNESS PROTOCOL', style: AppTypography.headlineSmall),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step Progress Dots
              Row(
                children: List.generate(4, (index) {
                  final isActive = index <= _currentStep;
                  return Expanded(
                    child: Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.neonLime : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.neonLime.withOpacity(0.5),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Step Title & Content
              Expanded(
                child: _buildCurrentStepView(),
              ),

              // Navigation Controls
              NeonButton(
                text: _currentStep == 3 ? 'LOCK IN & LAUNCH QUEST' : 'NEXT STEP',
                icon: _currentStep == 3 ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                onPressed: _nextStep,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 0:
        return _buildOptionStep(
          title: 'WHAT IS YOUR CURRENT FITNESS LEVEL?',
          subtitle: 'Used to scale daily mission repetition targets and rest cadence.',
          options: _experiences,
          selected: _selectedExperience,
          onSelect: (val) => setState(() => _selectedExperience = val),
          icon: Icons.fitness_center_rounded,
        );
      case 1:
        return _buildOptionStep(
          title: 'WHAT IS YOUR PRIMARY OBJECTIVE?',
          subtitle: 'Determines the balance of calisthenics, core holds, and cardio missions.',
          options: _goals,
          selected: _selectedGoal,
          onSelect: (val) => setState(() => _selectedGoal = val),
          icon: Icons.track_changes_rounded,
        );
      case 2:
        return _buildDaysStep();
      case 3:
        return _buildOptionStep(
          title: 'CHOOSE YOUR INTENSITY RANK',
          subtitle: 'Higher ranks award bonus XP multipliers but enforce stricter AI repetition verification.',
          options: _difficulties,
          selected: _selectedDifficulty,
          onSelect: (val) => setState(() => _selectedDifficulty = val),
          icon: Icons.military_tech_rounded,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOptionStep({
    required String title,
    required String subtitle,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelect,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppTypography.displaySmall),
        const SizedBox(height: 8),
        Text(subtitle, style: AppTypography.bodyMedium),
        const SizedBox(height: 28),
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = option == selected;

              return GestureDetector(
                onTap: () => onSelect(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surfaceElevated : AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.neonLime : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.neonLime.withOpacity(0.18),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? AppColors.neonLime : AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: AppTypography.titleMedium.copyWith(
                            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: AppColors.neonLime, size: 22),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDaysStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('WEEKLY TRAINING FREQUENCY', style: AppTypography.displaySmall),
        const SizedBox(height: 8),
        Text(
          'Target workout days per 7-day cycle. Remaining days are automatically marked as Rest Days with streak protection.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _daysList.map((days) {
            final isSelected = days == _selectedDays;
            return GestureDetector(
              onTap: () => setState(() => _selectedDays = days),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 68,
                height: 90,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surfaceElevated : AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.neonLime : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.neonLime.withOpacity(0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$days',
                      style: AppTypography.statNumber.copyWith(
                        color: isSelected ? AppColors.neonLime : AppColors.textPrimary,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      'DAYS',
                      style: AppTypography.labelLarge.copyWith(
                        fontSize: 10,
                        color: isSelected ? AppColors.neonLime : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 36),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.neonLime, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Streak Protection: You receive 2 Rest Day Shields per week. Your streak will never break on planned recovery days.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

