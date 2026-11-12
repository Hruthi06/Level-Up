import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/models/mission_model.dart';
import '../../shared/widgets/neon_card.dart';

class MissionsScreen extends ConsumerStatefulWidget {
  const MissionsScreen({super.key});

  @override
  ConsumerState<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends ConsumerState<MissionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fitnessProvider);
    final dailyMissions = state.dailyMissions;
    final weeklyMissions = state.weeklyMissions;
    final allDailyCompleted = dailyMissions.every((m) => m.isCompleted);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('MISSION HUB', style: AppTypography.headlineMedium),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.neonLime,
          indicatorWeight: 3,
          labelColor: AppColors.neonLime,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.headlineSmall.copyWith(fontSize: 14),
          tabs: const [
            Tab(text: 'DAILY QUESTS'),
            Tab(text: 'WEEKLY'),
            Tab(text: 'SPECIAL'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Daily Quests Tab
          _buildDailyTab(dailyMissions, allDailyCompleted),

          // Weekly Missions Tab
          _buildWeeklyTab(weeklyMissions),

          // Special Events & Challenges Tab
          _buildSpecialTab(),
        ],
      ),
    );
  }

  Widget _buildDailyTab(List<MissionModel> dailyMissions, bool allDailyCompleted) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      children: [
        // Daily Clear Bonus Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.neonLime.withOpacity(0.18),
                AppColors.surfaceElevated,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.neonLime.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.stars_rounded, color: AppColors.neonLime, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY CLEAR BONUS',
                      style: AppTypography.headlineSmall.copyWith(fontSize: 15, color: AppColors.neonLime),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      allDailyCompleted
                          ? 'Bonus unlocked! +50 XP awarded.'
                          : 'Complete all 5 daily exercises to claim +50 Bonus XP.',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Mission Items
        ...dailyMissions.map((mission) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildDetailedMissionCard(mission),
            )),
      ],
    );
  }

  Widget _buildWeeklyTab(List<MissionModel> weeklyMissions) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      children: [
        Text(
          '7-DAY MILESTONE CONTRACTS',
          style: AppTypography.headlineSmall.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          'Longer term workout volume goals with substantial XP payouts.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 18),
        ...weeklyMissions.map((mission) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildDetailedMissionCard(mission),
            )),
      ],
    );
  }

  Widget _buildSpecialTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      children: [
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on_rounded, color: AppColors.electricCyan, size: 24),
                  const SizedBox(width: 10),
                  Text('WEEKEND BOSS RAID', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock conditions: Clear 15 daily missions during the week to challenge the Weekend Titan.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('LOCKED • OPENS SATURDAY', style: AppTypography.labelLarge.copyWith(fontSize: 11, color: AppColors.textMuted)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedMissionCard(MissionModel mission) {
    final isDone = mission.isCompleted;

    return NeonCard(
      borderColor: isDone ? AppColors.neonEmerald.withOpacity(0.5) : AppColors.border,
      onTap: () {
        context.push('/workout/prep/${mission.exerciseType.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDone ? AppColors.neonEmerald.withOpacity(0.15) : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  mission.exerciseType.icon,
                  color: isDone ? AppColors.neonEmerald : AppColors.neonLime,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mission.title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
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
              if (isDone)
                const Icon(Icons.check_circle_rounded, color: AppColors.neonEmerald, size: 24)
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonLime,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    context.push('/workout/prep/${mission.exerciseType.id}');
                  },
                  child: Text('START', style: AppTypography.labelLarge.copyWith(color: Colors.black, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(mission.description, style: AppTypography.bodySmall),
          const SizedBox(height: 12),
          // Progress Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: mission.progressPercentage,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? AppColors.neonEmerald : AppColors.neonLime,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

