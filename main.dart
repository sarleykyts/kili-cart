import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/local_storage.dart';
import 'core/services/notification_service.dart';
import 'providers/app_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/collections_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/add_collection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.platform,
  );
  await LocalStorage.init();
  await NotificationService.init();
  runApp(const KiliCartApp());
}

class KiliCartApp extends StatelessWidget {
  const KiliCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
        ChangeNotifierProvider(create: (_) => AppProvider()..init()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeMode, child) {
          return MaterialApp(
            title: 'KiliCart',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeData(AppThemeMode.vintage),
            darkTheme: AppTheme.themeData(AppThemeMode.amoled),
            themeMode: themeMode.isAmoled ? ThemeMode.dark : ThemeMode.light,
            home: const _Router(),
            routes: {
              '/home': (_) => const HomeScreen(),
              '/collections': (_) => const CollectionsScreen(),
              '/settings': (_) => const SettingsScreen(),
              '/add-product': (_) => const AddProductScreen(),
              '/add-collection': (_) => const AddCollectionScreen(),
            },
          );
        },
      ),
    );
  }
}

class _Router extends StatefulWidget {
  const _Router();

  @override
  State<_Router> createState() => _RouterState();
}

class _RouterState extends State<_Router> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final provider = context.watch<AppProvider>();
    if (provider.user == null || provider.user!.id.isEmpty) {
      return const OnboardingScreen();
    }
    return const HomeScreen();
  }
}
