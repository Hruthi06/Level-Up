import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/models/achievement_model.dart';
import '../../shared/widgets/neon_card.dart';
import '../../shared/widgets/streak_badge.dart';
import '../../shared/widgets/xp_progress_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fitnessProvider);
    final user = state.profile;
    final achievements = state.achievements;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('PLAYER DOSSIER', style: AppTypography.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () => _showSettingsModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Character Card
            _buildCharacterCard(user),
            const SizedBox(height: 20),

            // Streak & Rest Day Shield Banner
            StreakBadge(streakDays: user.currentStreak),
            const SizedBox(height: 24),

            // Lifetime Combat Fitness Stats
            Text('FITNESS COMBAT ANALYTICS', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            _buildLifetimeStatsGrid(user),
            const SizedBox(height: 28),

            // Achievement Badges Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ACHIEVEMENT TROPHIES', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
                Text(
                  '${achievements.where((a) => a.isUnlocked).length} / ${achievements.length} UNLOCKED',
                  style: AppTypography.labelLarge.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAchievementsGrid(achievements),

            const SizedBox(height: 28),

            // Training Configuration Preferences
            Text('TRAINING PROTOCOL', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            _buildPreferencesCard(context, user.preferences),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(user) {
    return NeonCard(
      hasGlow: true,
      gradient: AppColors.heroGradient,
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceElevated,
                  border: Border.all(color: AppColors.neonLime, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonLime.withOpacity(0.3),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const Icon(Icons.person_rounded, size: 42, color: AppColors.neonLime),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.neonLime.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.neonLime.withOpacity(0.5)),
                      ),
                      child: Text(
                        'RANK: ${user.rankTitle.toUpperCase()}',
                        style: AppTypography.labelLarge.copyWith(fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.displayName,
                      style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '@${user.username} • UID: ${user.uid}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          XpProgressBar(
            currentXp: user.currentXp,
            maxXp: user.xpToNextLevel,
          ),
        ],
      ),
    );
  }

  Widget _buildLifetimeStatsGrid(user) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatTile('TOTAL WORKOUTS', '${user.stats.totalWorkouts}', 'SESSIONS', Icons.fitness_center_rounded),
        _buildStatTile('VERIFIED REPS', '${user.stats.totalValidReps}', 'REPETITIONS', Icons.check_circle_outline_rounded),
        _buildStatTile('ACTIVE TIME', '${user.stats.totalMinutes}', 'MINUTES', Icons.timer_outlined),
        _buildStatTile('FORM ACCURACY', '${user.stats.formAccuracy}%', 'AI VERIFIED', Icons.auto_awesome_rounded, isNeon: true),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, String unit, IconData icon, {bool isNeon = false}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNeon ? AppColors.neonLime.withOpacity(0.5) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.labelLarge.copyWith(fontSize: 10, color: AppColors.textSecondary)),
              Icon(icon, size: 16, color: isNeon ? AppColors.neonLime : AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.statNumber.copyWith(
              fontSize: 22,
              color: isNeon ? AppColors.neonLime : AppColors.textPrimary,
            ),
          ),
          Text(unit, style: AppTypography.bodySmall.copyWith(fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(List<AchievementModel> achievements) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final ach = achievements[index];
        final isUnlocked = ach.isUnlocked;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isUnlocked ? AppColors.surfaceCard : AppColors.surfaceElevated.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isUnlocked ? AppColors.neonLime.withOpacity(0.4) : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isUnlocked ? AppColors.neonLime.withOpacity(0.15) : AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  ach.icon,
                  color: isUnlocked ? AppColors.neonLime : AppColors.textDisabled,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ach.title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(ach.description, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              Text(
                '+${ach.xpBonus} XP',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 11,
                  color: isUnlocked ? AppColors.neonLime : AppColors.textDisabled,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreferencesCard(BuildContext context, prefs) {
    return NeonCard(
      child: Column(
        children: [
          _buildPrefRow('Experience Level', prefs.experience),
          const Divider(height: 20),
          _buildPrefRow('Primary Goal', prefs.primaryGoal),
          const Divider(height: 20),
          _buildPrefRow('Weekly Cadence', '${prefs.weeklyWorkoutDays} Days / Week'),
          const Divider(height: 20),
          _buildPrefRow('Difficulty Tier', prefs.preferredDifficulty),
        ],
      ),
    );
  }

  Widget _buildPrefRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.titleMedium.copyWith(color: AppColors.neonLime, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SETTINGS & DATA', style: AppTypography.headlineSmall),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.neonLime),
                  title: Text('Privacy Policy & Camera Permissions', style: AppTypography.titleMedium),
                  subtitle: Text('All camera frames processed locally on device.', style: AppTypography.bodySmall),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.refresh_rounded, color: AppColors.streakOrange),
                  title: Text('Reset Demo Data', style: AppTypography.titleMedium),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.go('/welcome');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.alertRed),
                  title: Text('Log Out', style: AppTypography.titleMedium.copyWith(color: AppColors.alertRed)),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.go('/welcome');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

