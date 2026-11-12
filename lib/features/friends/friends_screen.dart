import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/mock/mock_fitness_repository.dart';
import '../../shared/widgets/neon_card.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fitnessProvider);
    final friends = state.friends;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('FRIENDS & DUELS', style: AppTypography.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.neonLime),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Friend request system will activate with Firebase Auth sync.'),
                  backgroundColor: AppColors.surfaceElevated,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Active 1v1 Duel Card
          _buildActiveDuelCard(context),
          const SizedBox(height: 24),

          // Search Field
          TextField(
            style: AppTypography.titleMedium,
            decoration: const InputDecoration(
              hintText: 'Search player username...',
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.neonLime),
            ),
          ),
          const SizedBox(height: 24),

          // Section Header
          Text('ALLIES ONLINE (${friends.length})', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 12),

          ...friends.map((friend) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFriendTile(context, friend),
              )),
        ],
      ),
    );
  }

  Widget _buildActiveDuelCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mythicPurple.withOpacity(0.2),
            AppColors.surfaceCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mythicPurple.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sports_kabaddi_rounded, color: AppColors.mythicPurple, size: 24),
                  const SizedBox(width: 8),
                  Text('ACTIVE DUEL', style: AppTypography.headlineSmall.copyWith(fontSize: 15, color: AppColors.mythicPurple)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('14h 22m LEFT', style: AppTypography.labelLarge.copyWith(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '50 Squats Challenge vs Alex_Blade',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Both players verify squats with AI. Winner claims +100 Bonus XP.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('YOU: 25 / 50', style: AppTypography.labelLarge.copyWith(fontSize: 11)),
                    const SizedBox(height: 4),
                    const LinearProgressIndicator(value: 0.5, backgroundColor: AppColors.surfaceElevated, color: AppColors.neonLime),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ALEX: 30 / 50', style: AppTypography.labelLarge.copyWith(fontSize: 11, color: AppColors.mythicPurple)),
                    const SizedBox(height: 4),
                    const LinearProgressIndicator(value: 0.6, backgroundColor: AppColors.surfaceElevated, color: AppColors.mythicPurple),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFriendTile(BuildContext context, Map<String, dynamic> friend) {
    final isOnline = friend['isOnline'] as bool;

    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Avatar with online dot
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.textSecondary, size: 24),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isOnline ? AppColors.neonLime : AppColors.textDisabled,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceCard, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Friend Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['username'],
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'LVL ${friend['level']} • ${friend['rank']} • 🔥 ${friend['streak']} Days',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),

          // Duel CTA Button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.neonLime),
              foregroundColor: AppColors.neonLime,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Challenged ${friend['username']} to a 50 Squats duel!'),
                  backgroundColor: AppColors.surfaceElevated,
                ),
              );
            },
            child: Text('DUEL', style: AppTypography.labelLarge.copyWith(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

