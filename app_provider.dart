import 'package:flutter/foundation.dart';
import '../../core/services/api_service.dart';
import '../../core/services/local_storage.dart';
import '../../core/services/notification_service.dart';
import '../../models/product.dart';
import '../../models/collection.dart';
import '../../models/user.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  User? _user;
  List<Product> _products = [];
  List<Collection> _collections = [];
  bool _isLoading = false;
  String? _error;
  bool _isOnline = true;
  bool _synced = false;

  User? get user => _user;
  List<Product> get products => _products;
  List<Collection> get collections => _collections;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _isOnline;
  bool get isAuthenticated => _user != null;
  bool get synced => _synced;

  void _setLoading(bool v) { _isLoading = v; notifyListeners(); }
  void _setError(String? e) { _error = e; notifyListeners(); }

  Future<void> init() async {
    await LocalStorage.init();
    await NotificationService.init();
    _user = LocalStorage.user;
    _products = LocalStorage.products;
    _collections = LocalStorage.collections;
    _synced = true;
    notifyListeners();
  }

  // Auth
  Future<void> register({String? email, String? password, String? name}) async {
    _setLoading(true);
    try {
      final deviceId = LocalStorage.deviceId;
      final u = await _api.register(email: email, password: password, name: name, deviceId: deviceId);
      _user = u;
      await LocalStorage.setUser(u);
      await LocalStorage.seedDefaultCollections(u.id);
      await loadCollections();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login({String? email, String? password}) async {
    _setLoading(true);
    try {
      final u = await _api.login(email: email, password: password);
      _user = u;
      await LocalStorage.setUser(u);
      await loadData();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> anonymousLogin() async {
    _setLoading(true);
    try {
      final deviceId = LocalStorage.deviceId;
      final u = await _api.anonymousLogin(deviceId);
      _user = u;
      await LocalStorage.setUser(u);
      await LocalStorage.seedDefaultCollections(u.id);
      await loadCollections();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveFcmToken(String token) async {
    if (_user == null) return;
    try {
      await _api.saveFcmToken(token);
      await LocalStorage.setFcmToken(token);
    } catch (_) {}
  }

  Future<void> loadData() async {
    if (_user == null) return;
    await loadProducts();
    await loadCollections();
  }

  Future<void> loadProducts() async {
    if (_user == null) return;
    try {
      final remote = await _api.getProducts(_user!.id);
      _products = remote;
      for (final p in remote) {
        await LocalStorage.saveProduct(p);
      }
      _synced = true;
    } catch (_) {
      _products = LocalStorage.products;
    }
    notifyListeners();
  }

  Future<void> loadCollections() async {
    if (_user == null) return;
    try {
      final remote = await _api.getCollections(_user!.id);
      _collections = remote;
      if (_collections.isEmpty) {
        await LocalStorage.seedDefaultCollections(_user!.id);
        _collections = LocalStorage.collections;
      } else {
        for (final c in remote) {
          await LocalStorage.saveCollection(c);
        }
      }
    } catch (_) {
      _collections = LocalStorage.collections;
    }
    notifyListeners();
  }

  // Products
  Future<void> addProduct({
    required String title,
    required String url,
    required String imageUrl,
    required double currentPrice,
    required double originalPrice,
    required String currency,
    String? collectionId,
    double? targetPrice,
  }) async {
    if (_user == null) throw Exception('Not authenticated');
    _setLoading(true);
    try {
      final p = await _api.addProduct({
        'userId': _user!.id,
        'collectionId': collectionId,
        'title': title,
        'url': url,
        'imageUrl': imageUrl,
        'currentPrice': currentPrice,
        'originalPrice': originalPrice,
        'currency': currency,
        'targetPrice': targetPrice,
      });
      final local = Product(
        id: p.id,
        userId: _user!.id,
        collectionId: collectionId,
        title: title,
        url: url,
        imageUrl: imageUrl,
        currentPrice: currentPrice,
        originalPrice: originalPrice,
        currency: currency,
        targetPrice: targetPrice,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        synced: true,
      );
      await LocalStorage.saveProduct(local);
      _products.insert(0, local);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> updates) async {
    if (_user == null) return;
    try {
      await _api.updateProduct(id, updates);
      final idx = _products.indexWhere((p) => p.id == id);
      if (idx != -1) {
        final p = _products[idx];
        if (updates.containsKey('currentPrice')) p.currentPrice = updates['currentPrice'];
        if (updates.containsKey('targetPrice')) p.targetPrice = updates['targetPrice'];
        if (updates.containsKey('isPurchased')) p.isPurchased = updates['isPurchased'];
        if (updates.containsKey('isArchived')) p.isArchived = updates['isArchived'];
        p.updatedAt = DateTime.now();
        await LocalStorage.saveProduct(p);
        _products[idx] = p;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> deleteProduct(String id) async {
    if (_user == null) return;
    try {
      await _api.deleteProduct(id);
      await LocalStorage.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> markPurchased(String id, bool purchased) async {
    await updateProduct(id, {'purchased': purchased});
  }

  // Collections
  Future<void> createCollection(String name, {String? color}) async {
    if (_user == null) return;
    _setLoading(true);
    try {
      final c = await _api.createCollection({
        'userId': _user!.id,
        'name': name,
        'color': color ?? '#FF6B00',
        'isDefault': false,
      });
      await LocalStorage.saveCollection(c);
      _collections.add(c);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateCollection(String id, String name) async {
    if (_user == null) return;
    try {
      await _api.updateCollection(id, {'name': name});
      final idx = _collections.indexWhere((c) => c.id == id);
      if (idx != -1) {
        final c = _collections[idx];
        c.name = name;
        await LocalStorage.saveCollection(c);
        _collections[idx] = c;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> deleteCollection(String id) async {
    if (_user == null) return;
    try {
      await _api.deleteCollection(id);
      await LocalStorage.deleteCollection(id);
      _collections.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (_) {}
  }

  // Settings
  Future<void> updateSettings({
    String? theme,
    bool? notificationsEnabled,
    bool? priceAlertsEnabled,
  }) async {
    if (_user == null) return;
    try {
      final u = await _api.updateSettings(
        theme: theme,
        notificationsEnabled: notificationsEnabled,
        priceAlertsEnabled: priceAlertsEnabled,
      );
      _user = u;
      await LocalStorage.setUser(u);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> logout() async {
    _user = null;
    _products = [];
    _collections = [];
    await LocalStorage.setUser(User(id: '', isAnonymous: true));
    notifyListeners();
  }
}
