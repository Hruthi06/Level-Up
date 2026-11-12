import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/widgets/neon_card.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fitnessProvider);
    final leaderboard = state.leaderboard;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('RANKINGS & ARENA', style: AppTypography.headlineMedium),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.neonLime,
          indicatorWeight: 3,
          labelColor: AppColors.neonLime,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.headlineSmall.copyWith(fontSize: 14),
          tabs: const [
            Tab(text: 'GLOBAL TIER'),
            Tab(text: 'FRIENDS LEAGUE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardList(leaderboard),
          _buildLeaderboardList(leaderboard.reversed.toList()),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final rank = item['rank'] as int;
        final isUser = item['isUser'] as bool;

        Color rankColor = AppColors.textSecondary;
        if (rank == 1) rankColor = AppColors.gold;
        if (rank == 2) rankColor = const Color(0xFFC0C0C0);
        if (rank == 3) rankColor = const Color(0xFFCD7F32);

        return NeonCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          borderColor: isUser ? AppColors.neonLime : AppColors.border,
          hasGlow: isUser,
          child: Row(
            children: [
              // Rank Number
              SizedBox(
                width: 34,
                child: Text(
                  '#$rank',
                  style: AppTypography.headlineSmall.copyWith(
                    color: rankColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Player Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUser ? AppColors.neonLime : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: isUser ? AppColors.neonLime : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Player Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['username'],
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isUser ? AppColors.neonLime : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'LVL ${item['level']} • 🔥 ${item['streak']} Days',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),

              // XP
              Text(
                '${item['xp']} XP',
                style: AppTypography.statNumber.copyWith(fontSize: 16, color: AppColors.neonLime),
              ),
            ],
          ),
        );
      },
    );
  }
}

