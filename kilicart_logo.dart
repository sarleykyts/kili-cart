import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// KiliCart logo: orange shopping cart + lightning bolt
/// Placed in the top-left corner of every product & collection card.
class KiliCartLogo extends StatelessWidget {
  final double size;
  final bool vintage;

  const KiliCartLogo({super.key, this.size = 24, this.vintage = false});

  @override
  Widget build(BuildContext context) {
    final orange = vintage ? AppColors.vintageMutedOrange : AppColors.primaryOrange;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: orange.withOpacity(0.5), width: 1.5),
      ),
      child: Stack(
        children: [
          // Shopping cart
          Center(
            child: Icon(
              Icons.shopping_cart_outlined,
              color: orange,
              size: size * 0.62,
            ),
          ),
          // Lightning bolt overlay
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(size * 0.25),
                  bottomLeft: Radius.circular(size * 0.25),
                ),
              ),
              child: const Icon(
                Icons.flash_on,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
