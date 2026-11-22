import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Liquid Glass / frosted glass button with blur, transparency, border, and light reflection.
class LiquidGlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool primary;
  final bool outline;
  final double width;
  final double height;
  final double borderRadius;

  const LiquidGlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.primary = false,
    this.outline = false,
    this.width = double.infinity,
    this.height = 52,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orange = AppColors.primaryOrange;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: primary
            ? const LinearGradient(
                colors: [AppColors.primaryOrangeLight, AppColors.primaryOrange],
              )
            : AppColors.liquidGlassGradient,
        border: outline
            ? Border.all(color: orange.withOpacity(0.6), width: 1.5)
            : Border.all(
                color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
                width: 1,
              ),
        boxShadow: primary
            ? [
                BoxShadow(
                  color: orange.withOpacity(0.45),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x22FFFFFF), Color(0x0AFFFFFF)],
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
