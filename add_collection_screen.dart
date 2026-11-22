import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/liquid_glass_button.dart';
import '../../core/services/haptic_service.dart';
import '../../providers/app_provider.dart';

class AddCollectionScreen extends StatefulWidget {
  const AddCollectionScreen({super.key});

  @override
  State<AddCollectionScreen> createState() => _AddCollectionScreenState();
}

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController(text: '#FF6B00');

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>();
    final vintage = themeMode.mode == AppThemeMode.vintage;
    final provider = context.watch<AppProvider>();

    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;
    final cardColor = vintage ? AppColors.vintageCard : AppColors.amoledCard;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: vintage ? AppColors.vintageGradient : AppColors.amoledGradient),
        child: SafeArea(
          child: Column(
            children: [
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
                    Text('New Collection', style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Collection Name', style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _nameController,
                            autofocus: true,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'e.g. Electronics',
                              hintStyle: TextStyle(color: secondary.withOpacity(0.6)),
                              filled: true,
                              fillColor: cardColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Accent Color', style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _colorController,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: '#FF6B00',
                              hintStyle: TextStyle(color: secondary.withOpacity(0.6)),
                              filled: true,
                              fillColor: cardColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      LiquidGlassButton(
                        primary: true,
                        onPressed: _save,
                        child: const Text('Create Collection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
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

  Future<void> _save() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection name is required')));
      return;
    }
    HapticService.light();
    await context.read<AppProvider>().createCollection(_nameController.text.trim(), color: _colorController.text.trim());
    if (mounted) Navigator.pop(context);
  }
}
