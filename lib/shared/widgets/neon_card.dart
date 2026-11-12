import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool hasGlow;
  final Gradient? gradient;

  const NeonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.borderColor,
    this.hasGlow = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? (hasGlow ? AppColors.neonLime.withOpacity(0.5) : AppColors.border);

    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.surfaceCard : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: effectiveBorderColor,
          width: hasGlow ? 1.5 : 1.0,
        ),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: AppColors.neonLime.withOpacity(0.18),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(18),
            child: child,
          ),
        ),
      ),
    );
  }
}

