import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/collection_card.dart';
import '../../core/widgets/liquid_glass_button.dart';
import '../../core/services/haptic_service.dart';
import '../../providers/app_provider.dart';
import '../../models/collection.dart';
import 'add_collection_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
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

    final filtered = provider.collections.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: vintage ? AppColors.vintageGradient : AppColors.amoledGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const KiliCartLogo(size: 32),
                    const SizedBox(width: 12),
                    Text('Collections', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search collections',
                    hintStyle: TextStyle(color: secondary.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.search, color: secondary),
                    filled: true,
                    fillColor: vintage ? AppColors.vintageSurface : AppColors.amoledSurface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_off, size: 48, color: secondary.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            Text('No collections found', style: TextStyle(color: secondary, fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final c = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: CollectionCard(
                              collection: c,
                              vintage: vintage,
                              productCount: c.productCount,
                              onTap: () => HapticService.selection(),
                              onEdit: () => _editCollection(c),
                              onDelete: () => _deleteCollection(c.id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticService.light();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCollectionScreen()));
        },
        backgroundColor: accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _editCollection(Collection c) async {
    final controller = TextEditingController(text: c.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Collection'),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'Collection name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          LiquidGlassButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await context.read<AppProvider>().updateCollection(c.id, result);
    }
  }

  Future<void> _deleteCollection(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: const Text('Delete this collection? Products inside will not be deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (confirmed == true) {
      await context.read<AppProvider>().deleteCollection(id);
    }
  }
}
