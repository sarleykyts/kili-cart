import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/kilicart_logo.dart';
import '../../core/widgets/liquid_glass_button.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/share_service.dart';
import '../../providers/app_provider.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>();
    final vintage = themeMode.mode == AppThemeMode.vintage;
    final provider = context.watch<AppProvider>();
    final product = provider.products.firstWhere((p) => p.id == widget.productId, orElse: () => throw Exception('Not found'));

    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;
    final accent = vintage ? AppColors.vintageMutedOrange : AppColors.primaryOrange;
    final cardColor = vintage ? AppColors.vintageCard : AppColors.amoledCard;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: vintage ? AppColors.vintageGradient : AppColors.amoledGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    LiquidGlassButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      width: 44,
                      height: 44,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(product.title, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold))),
                    const KiliCartLogo(size: 24, vintage: vintage),
                  ],
                ),
              ),

              // Image
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          color: accent.withOpacity(0.1),
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(product.imageUrl, fit: BoxFit.contain)
                              : const Icon(Icons.image_outlined, size: 64, color: Colors.white38),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (product.isOnFlashSale)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(6)),
                                    child: const Text('FLASH SALE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                  ),
                                if (product.discountPercent > 0 && !product.isOnFlashSale) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                                    child: Text('-${product.discountPercent}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('${product.currency} ${product.currentPrice.toStringAsFixed(0)}',
                                style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.w800)),
                            if (product.originalPrice > product.currentPrice) ...[
                              const SizedBox(height: 4),
                              Text('${product.currency} ${product.originalPrice.toStringAsFixed(0)}',
                                  style: TextStyle(color: secondary, fontSize: 16, decoration: TextDecoration.lineThrough)),
                            ],
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: vintage ? const Color(0xFFE8D4B8) : Colors.white.withOpacity(0.12), width: 1),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Target Price', style: TextStyle(color: secondary, fontSize: 14)),
                                      Text('Set alert', style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter target price',
                                      prefixText: '${product.currency} ',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: vintage ? AppColors.vintageSurface : AppColors.amoledSurface,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (v) {
                                      final price = double.tryParse(v);
                                      if (price != null) {
                                        provider.updateProduct(product.id, {'targetPrice': price});
                                        HapticService.light();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: LiquidGlassButton(
                                    onPressed: () {
                                      HapticService.light();
                                      ShareService.shareProductLink(title: product.title, url: product.url);
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Icon(Icons.share, size: 20), SizedBox(width: 8), Text('Share')],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: LiquidGlassButton(
                                    primary: true,
                                    onPressed: () {
                                      HapticService.light();
                                      provider.markPurchased(product.id, !product.isPurchased);
                                    },
                                    child: Text(product.isPurchased ? 'Mark Unpurchased' : 'Mark Purchased', style: const TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LiquidGlassButton(
                              onPressed: () {
                                HapticService.heavy();
                                provider.deleteProduct(product.id);
                                Navigator.pop(context);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.delete, size: 20), SizedBox(width: 8), Text('Delete Product')],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
