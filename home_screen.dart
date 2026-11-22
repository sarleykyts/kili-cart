import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/kilicart_logo.dart';
import '../../core/widgets/liquid_glass_button.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/floating_bottom_nav.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/notification_service.dart';
import '../../providers/app_provider.dart';
import '../../models/product.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _countdownController;
  int _secondsRemaining = 3600; // 1 hour default
  NavItem _selected = NavItem.home;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _countdownController.addListener(() {
      setState(() {
        if (_secondsRemaining > 0) _secondsRemaining--;
        else _secondsRemaining = 3600;
      });
    });
    _countdownController.repeat();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  String _formatCountdown(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>();
    final vintage = themeMode.mode == AppThemeMode.vintage;
    final provider = context.watch<AppProvider>();
    final products = provider.products;

    final flashProducts = products.where((p) => p.isOnFlashSale).toList();
    final curatedProducts = products.where((p) => !p.isOnFlashSale).take(4).toList();

    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;
    final accent = vintage ? AppColors.vintageMutedOrange : AppColors.primaryOrange;
    final bgGradient = vintage ? AppColors.vintageGradient : AppColors.amoledGradient;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const KiliCartLogo(size: 32),
                    LiquidGlassButton(
                      onPressed: () => NotificationService.showFlashSaleNotification(
                        title: 'Flash Sale Alert',
                        body: 'New deals are live now!',
                      ),
                      child: const Icon(Icons.notifications_none, color: Colors.white, size: 22),
                      width: 44,
                      height: 44,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Greeting
                Text(_greeting(), style: TextStyle(color: secondary, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Shop the good stuff.', style: TextStyle(color: textColor, fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Fresh finds. Flash deals. Delivered.', style: TextStyle(color: secondary, fontSize: 14)),
                const SizedBox(height: 24),

                // Stat cards
                Row(
                  children: [
                    _statCard('Wishlist', '${products.length}', Icons.favorite_border, vintage),
                    const SizedBox(width: 12),
                    _statCard('On Sale', '${flashProducts.length}', Icons.local_fire_department, vintage),
                    const SizedBox(width: 12),
                    _statCard('Purchased', '${products.where((p) => p.isPurchased).length}', Icons.check_circle, vintage),
                  ],
                ),
                const SizedBox(height: 28),

                // Live Flash Sale section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LIVE FLASH SALE', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatCountdown(_secondsRemaining),
                        style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: vintage ? const Color(0xFF3A2A1A) : const Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withOpacity(0.3), width: 1),
                  ),
                  child: SizedBox(
                    height: 210,
                    child: flashProducts.isEmpty
                        ? Center(
                            child: Text('No active flash sales', style: TextStyle(color: secondary.withOpacity(0.7), fontSize: 14)),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: flashProducts.length,
                            itemBuilder: (context, index) {
                              final p = flashProducts[index];
                              return _flashProductCard(p, vintage);
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 28),

                // Curated for You
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Curated for You', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('View all', style: TextStyle(color: accent, fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                curatedProducts.isEmpty
                    ? _emptyState('No curated products yet', 'Add your first product to get started', vintage)
                    : SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: curatedProducts.length,
                          itemBuilder: (context, index) {
                            final p = curatedProducts[index];
                            return ProductCard(
                              product: p,
                              vintage: vintage,
                              onTap: () => HapticService.selection(),
                              onLongPress: () => _showLongPressMenu(p),
                              onCopyLink: () => _copyLink(p),
                              onDelete: () => _deleteProduct(p.id),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 100), // space for floating nav
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
            HapticService.light();
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
          },
          backgroundColor: accent,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FloatingBottomNav(
        selected: _selected,
        onItemSelected: (item) => setState(() => _selected = item),
        onAddPressed: () {
          HapticService.light();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
        },
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, bool vintage) {
    final cardColor = vintage ? AppColors.vintageCard : AppColors.amoledCard;
    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: vintage ? const Color(0xFFE8D4B8) : Colors.white.withOpacity(0.12), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: secondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _flashProductCard(Product product, bool vintage) {
    final accent = vintage ? AppColors.vintageMutedOrange : AppColors.primaryOrange;
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: vintage ? AppColors.vintageCard : AppColors.amoledCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Container(
                  width: double.infinity,
                  height: 110,
                  color: accent.withOpacity(0.1),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(product.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 110)
                      : const Center(child: Icon(Icons.image_outlined, color: Colors.white38, size: 28)),
                ),
              ),
              Positioned(top: 6, left: 6, child: KiliCartLogo(size: 18, vintage: vintage)),
              Positioned(top: 6, right: 6, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(5)),
                child: const Text('FLASH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8)),
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: vintage ? AppColors.vintageText : AppColors.amoledText, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text('${product.currency} ${product.currentPrice.toStringAsFixed(0)}',
                    style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLongPressMenu(Product product) {
    HapticService.medium();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(height: 4, width: 40, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.link, color: AppColors.primaryOrange),
              title: const Text('Copy Product Link'),
              onTap: () { Navigator.pop(context); _copyLink(product); },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Delete Product', style: TextStyle(color: Colors.redAccent)),
              onTap: () { Navigator.pop(context); _deleteProduct(product.id); },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _copyLink(Product product) {
    HapticService.success();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: ${product.url}')),
    );
  }

  Future<void> _deleteProduct(String id) async {
    HapticService.heavy();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Remove this product from your wishlist?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (confirmed == true) {
      final provider = context.read<AppProvider>();
      await provider.deleteProduct(id);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
    }
  }
}
