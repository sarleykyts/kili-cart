import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kilicart_logo.dart';
import '../../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool vintage;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onCopyLink;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.vintage,
    required this.onTap,
    required this.onLongPress,
    required this.onCopyLink,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = vintage ? AppColors.vintageCard : AppColors.amoledCard;
    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;
    final accent = vintage ? AppColors.vintageMutedOrange : AppColors.primaryOrange;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 165,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: vintage
                ? const Color(0xFFE8D4B8)
                : Colors.white.withOpacity(0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(vintage ? 0.12 : 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // KiliCart logo top-left
            Positioned(top: 10, left: 10, child: KiliCartLogo(size: 20, vintage: vintage)),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          color: accent.withOpacity(0.1),
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, __, ___) =>
                                      const Center(child: Icon(Icons.image_outlined, color: Colors.white38, size: 32)),
                                )
                              : const Center(child: Icon(Icons.image_outlined, color: Colors.white38, size: 32)),
                        ),
                        if (product.isOnFlashSale)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'FLASH',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9),
                              ),
                            ),
                          ),
                        if (product.discountPercent > 0 && !product.isOnFlashSale)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${product.discountPercent}%',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        '${product.currency} ${product.currentPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (product.originalPrice > product.currentPrice) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${product.currency} ${product.originalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
