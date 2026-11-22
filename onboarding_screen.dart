import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/liquid_glass_button.dart';
import '../../core/services/haptic_service.dart';
import '../../providers/app_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;
  final PageController _controller = PageController();

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to KiliCart',
      'subtitle': 'Your smart wishlist & flash-sale tracker for Kilimall.',
    },
    {
      'title': 'Save Products You Love',
      'subtitle': 'Add any Kilimall product link and track its price.',
    },
    {
      'title': 'Flash Sale Alerts',
      'subtitle': 'Get notified when your saved products go on flash sale.',
    },
    {
      'title': 'Two Beautiful Themes',
      'subtitle': 'Choose between AMOLED Black and Vintage parchment.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>();
    final vintage = themeMode.mode == AppThemeMode.vintage;
    final accent = vintage ? AppColors.vintageMutedOrange : AppColors.primaryOrange;
    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: vintage ? AppColors.vintageGradient : AppColors.amoledGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const KiliCartLogo(size: 64, vintage: true),
                        const SizedBox(height: 32),
                        Text(_pages[i]['title']!, style: TextStyle(color: textColor, fontSize: 26, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Text(_pages[i]['subtitle']!, style: TextStyle(color: secondary, fontSize: 16), textAlign: TextAlign.center),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i ? accent : accent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: LiquidGlassButton(
                  primary: true,
                  onPressed: () {
                    HapticService.light();
                    if (_page == _pages.length - 1) {
                      context.read<AppProvider>().anonymousLogin();
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }
                  },
                  child: Text(_page == _pages.length - 1 ? 'Get Started' : 'Next', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

import '../../core/widgets/kilicart_logo.dart';
