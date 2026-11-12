import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum NeonButtonVariant { primary, secondary, outline, destructive }

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NeonButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.variant = NeonButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Border? border;
    List<BoxShadow> shadows = [];

    switch (variant) {
      case NeonButtonVariant.primary:
        bg = AppColors.neonLime;
        fg = Colors.black;
        shadows = [
          BoxShadow(
            color: AppColors.neonLime.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ];
        break;
      case NeonButtonVariant.secondary:
        bg = AppColors.surfaceElevated;
        fg = AppColors.textPrimary;
        border = Border.all(color: AppColors.border, width: 1.2);
        break;
      case NeonButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.neonLime;
        border = Border.all(color: AppColors.neonLime, width: 1.5);
        shadows = [
          BoxShadow(
            color: AppColors.neonLime.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ];
        break;
      case NeonButtonVariant.destructive:
        bg = AppColors.alertRed.withOpacity(0.15);
        fg = AppColors.alertRed;
        border = Border.all(color: AppColors.alertRed.withOpacity(0.5), width: 1.2);
        break;
    }

    final isEnabled = onPressed != null && !isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isEnabled ? bg : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: border,
        boxShadow: isEnabled ? shadows : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isEnabled ? onPressed : null,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: fg, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text.toUpperCase(),
                        style: AppTypography.headlineSmall.copyWith(
                          color: isEnabled ? fg : AppColors.textDisabled,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

