import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/kilicart_logo.dart';
import '../../../models/collection.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final bool vintage;
  final int productCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollectionCard({
    super.key,
    required this.collection,
    required this.vintage,
    required this.productCount,
    required this.onTap,
    required this.onEdit,
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
      child: Container(
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
            Positioned(top: 12, left: 12, child: KiliCartLogo(size: 22, vintage: vintage)),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          collection.name,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$productCount',
                          style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    collection.isDefault ? 'Default' : 'Custom',
                    style: TextStyle(color: secondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
