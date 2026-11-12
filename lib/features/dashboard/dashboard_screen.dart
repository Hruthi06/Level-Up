import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/models/mission_model.dart';
import '../../shared/widgets/neon_card.dart';
import '../../shared/widgets/streak_badge.dart';
import '../../shared/widgets/xp_progress_bar.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fitnessProvider);
    final user = state.profile;
    final dailyMissions = state.dailyMissions;
    final completedCount = dailyMissions.where((m) => m.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.neonLime,
          backgroundColor: AppColors.surfaceElevated,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top App Header
                _buildTopHeader(user),
                const SizedBox(height: 20),

                // Hero Player Status Card
                _buildHeroCard(context, user),
                const SizedBox(height: 20),

                // Quick Action Banner: Next Workout CTA
                _buildNextWorkoutBanner(context, dailyMissions),
                const SizedBox(height: 24),

                // Daily Missions Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TODAY'S MISSIONS", style: AppTypography.headlineSmall),
                        const SizedBox(height: 2),
                        Text(
                          '$completedCount / ${dailyMissions.length} COMPLETED',
                          style: AppTypography.labelLarge.copyWith(
                            fontSize: 12,
                            color: AppColors.neonLime,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.go('/missions'),
                      child: Row(
                        children: [
                          Text(
                            'VIEW ALL',
                            style: AppTypography.labelLarge.copyWith(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.neonLime),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Missions List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dailyMissions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mission = dailyMissions[index];
                    return _buildMissionTile(context, mission);
                  },
                ),

                const SizedBox(height: 24),

                // Weekly Progress Summary Card
                _buildWeeklyProgressCard(state),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(user) {
    return Row(
      children: [
        // Avatar with neon ring
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceElevated,
            border: Border.all(color: AppColors.neonLime, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonLime.withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.person_rounded, color: AppColors.neonLime, size: 26),
          ),
        ),
        const SizedBox(width: 14),

        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WELCOME BACK',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                user.displayName.toUpperCase(),
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Streak Pill
        StreakBadge(streakDays: user.currentStreak, isCompact: true),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, user) {
    return NeonCard(
      hasGlow: true,
      gradient: AppColors.heroGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neonLime.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.neonLime.withOpacity(0.5)),
                    ),
                    child: Text(
                      'RANK: ${user.rankTitle.toUpperCase()}',
                      style: AppTypography.labelLarge.copyWith(fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'LEVEL ${user.level.toString().padLeft(2, '0')}',
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 34,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              // Level Trophy Graphic
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neonLime, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonLime.withOpacity(0.25),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: AppColors.neonLime,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // XP Progress Bar
          XpProgressBar(
            currentXp: user.currentXp,
            maxXp: user.xpToNextLevel,
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildNextWorkoutBanner(BuildContext context, List<MissionModel> dailyMissions) {
    // Find next pending mission
    final nextPending = dailyMissions.firstWhere(
      (m) => !m.isCompleted,
      orElse: () => dailyMissions.first,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.neonLime.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(nextPending.exerciseType.icon, color: AppColors.neonLime, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXT UP: ${nextPending.exerciseType.displayName.toUpperCase()}',
                  style: AppTypography.headlineSmall.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  'Target: ${nextPending.target} ${nextPending.exerciseType.unit} • +${nextPending.xpReward} XP',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonLime,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onPressed: () {
              context.push('/workout/prep/${nextPending.exerciseType.id}');
            },
            child: Text(
              'START',
              style: AppTypography.labelLarge.copyWith(color: Colors.black, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionTile(BuildContext context, MissionModel mission) {
    final isDone = mission.isCompleted;

    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderColor: isDone ? AppColors.neonEmerald.withOpacity(0.5) : AppColors.border,
      onTap: () {
        context.push('/workout/prep/${mission.exerciseType.id}');
      },
      child: Row(
        children: [
          // Exercise Icon with Status Ring
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDone ? AppColors.neonEmerald.withOpacity(0.15) : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDone ? AppColors.neonEmerald : AppColors.border,
              ),
            ),
            child: Icon(
              isDone ? Icons.check_circle_rounded : mission.exerciseType.icon,
              color: isDone ? AppColors.neonEmerald : AppColors.neonLime,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Exercise Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.exerciseType.displayName,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${mission.target} ${mission.exerciseType.unit} • +${mission.xpReward} XP',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDone ? AppColors.textMuted : AppColors.neonLime,
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.neonEmerald.withOpacity(0.15)
                  : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDone ? AppColors.neonEmerald : AppColors.border,
              ),
            ),
            child: Text(
              isDone ? 'VERIFIED' : 'PENDING',
              style: AppTypography.labelLarge.copyWith(
                fontSize: 10,
                color: isDone ? AppColors.neonEmerald : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressCard(MockFitnessState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('WEEKLY CADENCE', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
              Text(
                '5 / 5 DAYS ACTIVE',
                style: AppTypography.labelLarge.copyWith(fontSize: 12, color: AppColors.neonLime),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayCircle('M', true),
              _buildDayCircle('T', true),
              _buildDayCircle('W', true),
              _buildDayCircle('T', true),
              _buildDayCircle('F', true),
              _buildDayCircle('S', false, isRest: true),
              _buildDayCircle('S', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCircle(String day, bool isDone, {bool isRest = false}) {
    Color bg = AppColors.surfaceElevated;
    Color border = AppColors.border;
    Color textCol = AppColors.textMuted;

    if (isDone) {
      bg = AppColors.neonLime.withOpacity(0.15);
      border = AppColors.neonLime;
      textCol = AppColors.neonLime;
    } else if (isRest) {
      bg = AppColors.electricCyan.withOpacity(0.1);
      border = AppColors.electricCyan.withOpacity(0.5);
      textCol = AppColors.electricCyan;
    }

    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 1.2),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 18, color: AppColors.neonLime)
                : isRest
                    ? const Icon(Icons.shield_outlined, size: 16, color: AppColors.electricCyan)
                    : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: AppTypography.bodySmall.copyWith(color: textCol, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

