import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class XpProgressBar extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final double height;
  final bool showLabels;

  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.maxXp,
    this.height = 10,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxXp <= 0 ? 1.0 : (currentXp / maxXp).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabels) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'XP PROGRESS',
                style: AppTypography.labelLarge.copyWith(fontSize: 12),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$currentXp ',
                      style: AppTypography.titleMedium.copyWith(color: AppColors.neonLime),
                    ),
                    TextSpan(
                      text: '/ $maxXp XP',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Stack(
          children: [
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(height / 2),
                border: Border.all(color: AppColors.border, width: 0.8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: AppColors.neonGreenGradient,
                  borderRadius: BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonLime.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

