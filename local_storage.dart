import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/collection.dart';
import '../models/user.dart';

part 'local_storage.g.dart';

class LocalStorage {
  static Box<Product>? _productBox;
  static Box<Collection>? _collectionBox;
  static SharedPreferences? _prefs;

  static const String _userKey = 'kilicart_user';
  static const String _deviceIdKey = 'kilicart_device_id';
  static const String _themeKey = 'kilicart_theme';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(CollectionAdapter());
    _productBox = await Hive.openBox<Product>('products');
    _collectionBox = await Hive.openBox<Collection>('collections');
    _prefs = await SharedPreferences.getInstance();
  }

  // User
  static User? get user {
    if (_prefs == null) return null;
    final json = _prefs!.getString(_userKey);
    if (json == null) return null;
    return User.fromJson(jsonDecode(json));
  }

  static Future<void> setUser(User user) async {
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
  }

  static String get deviceId {
    final id = _prefs?.getString(_deviceIdKey);
    if (id != null) return id;
    final newId = const Uuid().v4();
    _prefs?.setString(_deviceIdKey, newId);
    return newId;
  }

  // Products
  static List<Product> get products {
    return _productBox?.values.where((p) => !p.isArchived).toList() ?? [];
  }

  static List<Product> get archivedProducts {
    return _productBox?.values.where((p) => p.isArchived).toList() ?? [];
  }

  static Product? getProduct(String id) => _productBox?.get(id);

  static Future<void> saveProduct(Product product) async {
    await _productBox?.put(product.id, product);
  }

  static Future<void> deleteProduct(String id) async {
    await _productBox?.delete(id);
  }

  static Future<void> clearProducts() async {
    await _productBox?.clear();
  }

  // Collections
  static List<Collection> get collections {
    return _collectionBox?.values.toList() ?? [];
  }

  static Collection? getCollection(String id) => _collectionBox?.get(id);

  static Future<void> saveCollection(Collection collection) async {
    await _collectionBox?.put(collection.id, collection);
  }

  static Future<void> deleteCollection(String id) async {
    await _collectionBox?.delete(id);
  }

  static Future<void> seedDefaultCollections(String userId) async {
    final existing = _collectionBox?.values.where((c) => c.isDefault).toList() ?? [];
    if (existing.isNotEmpty) return;
    final now = DateTime.now();
    for (final def in defaultCollections) {
      final c = Collection(
        id: const Uuid().v4(),
        userId: userId,
        name: def['name']!,
        color: def['color']!,
        isDefault: true,
        productCount: 0,
        createdAt: now,
        synced: true,
      );
      await _collectionBox?.put(c.id, c);
    }
  }

  static Future<void> clearCollections() async {
    await _collectionBox?.clear();
  }

  // Theme
  static bool get isAmoledTheme {
    return _prefs?.getBool(_themeKey) ?? false;
  }

  static Future<void> setTheme(bool isAmoled) async {
    await _prefs?.setBool(_themeKey, isAmoled);
  }

  // FCM token
  static String get fcmToken => _prefs?.getString('kilicart_fcm_token') ?? '';
  static Future<void> setFcmToken(String token) async {
    await _prefs?.setString('kilicart_fcm_token', token);
  }
}
