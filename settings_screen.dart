import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/liquid_glass_button.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/notification_service.dart';
import '../../providers/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _priceAlerts = true;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppProvider>().user;
    _notifications = user?.notificationsEnabled ?? true;
    _priceAlerts = user?.priceAlertsEnabled ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>();
    final vintage = themeMode.mode == AppThemeMode.vintage;
    final isAmoled = themeMode.isAmoled;
    final provider = context.watch<AppProvider>();

    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;
    final cardColor = vintage ? AppColors.vintageCard : AppColors.amoledCard;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: vintage ? AppColors.vintageGradient : AppColors.amoledGradient,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header
              Row(
                children: [
                  const KiliCartLogo(size: 32),
                  const SizedBox(width: 12),
                  Text('Settings', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 28),

              // Theme
              _sectionTitle('Theme', context),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: vintage ? const Color(0xFFE8D4B8) : Colors.white.withOpacity(0.12), width: 1),
                ),
                child: ListTile(
                  leading: const Icon(Icons.dark_mode, color: AppColors.primaryOrange),
                  title: Text(isAmoled ? 'AMOLED Black' : 'Vintage', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                  subtitle: Text(isAmoled ? 'Pure black, OLED optimized' : 'Warm cream parchment', style: TextStyle(color: secondary, fontSize: 12)),
                  trailing: Switch(
                    value: isAmoled,
                    onChanged: (_) {
                      HapticService.selection();
                      context.read<ThemeProvider>().toggle();
                    },
                    activeColor: AppColors.primaryOrange,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Notifications
              _sectionTitle('Notifications', context),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: vintage ? const Color(0xFFE8D4B8) : Colors.white.withOpacity(0.12), width: 1),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                      title: Text('Push notifications', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                      subtitle: Text('Receive flash sale & price drop alerts', style: TextStyle(color: secondary, fontSize: 12)),
                      secondary: const Icon(Icons.notifications, color: AppColors.primaryOrange),
                      activeColor: AppColors.primaryOrange,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: _priceAlerts,
                      onChanged: (v) => setState(() => _priceAlerts = v),
                      title: Text('Target price alerts', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                      subtitle: Text('Notify when a product hits your target price', style: TextStyle(color: secondary, fontSize: 12)),
                      secondary: const Icon(Icons.attach_money, color: AppColors.primaryOrange),
                      activeColor: AppColors.primaryOrange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data
              _sectionTitle('Data & Sync', context),
              const SizedBox(height: 12),
              _settingRow(Icons.cloud_sync, 'Sync now', () {
                HapticService.light();
                context.read<AppProvider>().loadData();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Synced')));
              }, context),
              _settingRow(Icons.file_download, 'Export wishlist', () {
                HapticService.light();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export coming soon')));
              }, context),
              _settingRow(Icons.file_upload, 'Import wishlist', () {
                HapticService.light();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Import coming soon')));
              }, context),
              const SizedBox(height: 24),

              // Account
              _sectionTitle('Account', context),
              const SizedBox(height: 12),
              _settingRow(Icons.person, 'Profile', () {}, context),
              _settingRow(Icons.logout, 'Logout', () {
                HapticService.heavy();
                context.read<AppProvider>().logout();
              }, context, isDestructive: true),
              const SizedBox(height: 40),

              // Save button
              LiquidGlassButton(
                primary: true,
                onPressed: () async {
                  HapticService.light();
                  await provider.updateSettings(
                    notificationsEnabled: _notifications,
                    priceAlertsEnabled: _priceAlerts,
                  );
                  await NotificationService.init();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
                },
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, BuildContext context) {
    final secondary = Theme.of(context).brightness == Brightness.dark
        ? AppColors.amoledTextSecondary
        : AppColors.vintageTextSecondary;
    return Text(title, style: TextStyle(color: secondary, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5));
  }

  Widget _settingRow(IconData icon, String title, VoidCallback onTap, BuildContext context, {bool isDestructive = false}) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.amoledText
        : AppColors.vintageText;
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : AppColors.primaryOrange),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : textColor, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      onTap: onTap,
    );
  }
}

import '../../core/widgets/kilicart_logo.dart';
