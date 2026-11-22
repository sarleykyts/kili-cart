import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

enum NavItem { home, collections, settings }

class FloatingBottomNav extends StatelessWidget {
  final NavItem selected;
  final ValueChanged<NavItem> onItemSelected;
  final VoidCallback onAddPressed;

  const FloatingBottomNav({
    super.key,
    required this.selected,
    required this.onItemSelected,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orange = AppColors.primaryOrange;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      height: 64,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5E8D0),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.15) : const Color(0xFFE8D4B8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.18),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center floating + button
          Positioned(
            top: -14,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryOrangeLight, AppColors.primaryOrange],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: orange.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
          // Nav items
          Row(
            children: [
              _navItem(NavItem.home, Icons.home_outlined, Icons.home, 'Home'),
              _navItem(NavItem.collections, Icons.folder_outlined, Icons.folder, 'Collections'),
              const Spacer(),
              _navItem(NavItem.settings, Icons.settings_outlined, Icons.settings, 'Settings'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(NavItem item, IconData iconOut, IconData iconIn, String label) {
    final isSelected = selected == item;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemSelected(item),
        child: Container(
          height: 64,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? iconIn : iconOut,
                color: isSelected ? AppColors.primaryOrange : (isDark ? Colors.white60 : Colors.black54),
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryOrange : (isDark ? Colors.white60 : Colors.black54),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
