import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/liquid_glass_button.dart';
import '../../core/services/haptic_service.dart';
import '../../providers/app_provider.dart';
import '../../models/collection.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _targetPriceController = TextEditingController();
  String _currency = 'KES';
  String? _selectedCollectionId;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _targetPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>();
    final vintage = themeMode.mode == AppThemeMode.vintage;
    final provider = context.watch<AppProvider>();

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
                    Text('Add Product', style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildField('Product Title', _titleController, 'e.g. Nike Air Max', vintage, context),
                      const SizedBox(height: 16),
                      _buildField('Kilimall Product Link', _urlController, 'https://kilimall.co.ke/...', vintage, context),
                      const SizedBox(height: 16),
                      _buildField('Image URL (optional)', _imageController, 'https://...', vintage, context),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildField('Current Price', _priceController, '0', vintage, context, isNumber: true)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildField('Original Price', _originalPriceController, '0', vintage, context, isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildField('Target Price (alert)', _targetPriceController, 'optional', vintage, context, isNumber: true),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCollectionId,
                        decoration: InputDecoration(
                          labelText: 'Collection',
                          filled: true,
                          fillColor: cardColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        ),
                        items: provider.collections.map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name, style: TextStyle(color: textColor)),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedCollectionId = v),
                      ),
                      const SizedBox(height: 24),
                      LiquidGlassButton(
                        primary: true,
                        onPressed: _save,
                        child: const Text('Add to Wishlist', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildField(String label, TextEditingController controller, String hint, bool vintage, BuildContext context, {bool isNumber = false}) {
    final textColor = vintage ? AppColors.vintageText : AppColors.amoledText;
    final secondary = vintage ? AppColors.vintageTextSecondary : AppColors.amoledTextSecondary;
    final cardColor = vintage ? AppColors.vintageCard : AppColors.amoledCard;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: secondary.withOpacity(0.6)),
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title and URL are required')));
      return;
    }
    HapticService.light();
    final provider = context.read<AppProvider>();
    await provider.addProduct(
      title: _titleController.text.trim(),
      url: _urlController.text.trim(),
      imageUrl: _imageController.text.trim(),
      currentPrice: double.tryParse(_priceController.text) ?? 0,
      originalPrice: double.tryParse(_originalPriceController.text) ?? 0,
      currency: _currency,
      collectionId: _selectedCollectionId,
      targetPrice: _targetPriceController.text.isNotEmpty ? double.tryParse(_targetPriceController.text) : null,
    );
    if (mounted) Navigator.pop(context);
  }
}
