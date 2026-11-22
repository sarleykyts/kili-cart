import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/collection.dart';

class ApiService {
  final http.Client client;
  String? _authToken;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  void setToken(String? token) => _authToken = token;

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  Future<dynamic> _request(String method, String path, {Object? body}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/api$path');
    final response = await client.send(
      http.Request(method, uri)
        ..headers.addAll(_headers())
        ..body = body != null ? jsonEncode(body) : '',
    );
    final responseBody = await response.stream.bytesToString();
    final decoded = responseBody.isNotEmpty ? jsonDecode(responseBody) : null;
    if (response.statusCode >= 400) {
      throw ApiException(decoded?['error'] ?? 'Request failed', response.statusCode);
    }
    return decoded;
  }

  // Auth
  Future<User> register({String? email, String? password, String? name, String? deviceId}) async {
    final data = await _request('POST', '/auth/register', body: {
      'email': email,
      'password': password,
      'name': name,
      'deviceId': deviceId,
    });
    return User.fromJson(data['user']);
  }

  Future<User> login({String? email, String? password}) async {
    final data = await _request('POST', '/auth/login', body: {
      'email': email,
      'password': password,
    });
    _authToken = data['token'];
    return User.fromJson(data['user']);
  }

  Future<User> anonymousLogin(String deviceId) async {
    final data = await _request('POST', '/auth/anonymous', body: {
      'deviceId': deviceId,
    });
    _authToken = data['token'];
    return User.fromJson(data['user']);
  }

  Future<void> saveFcmToken(String token) async {
    await _request('POST', '/auth/fcm-token', body: {'fcmToken': token});
  }

  Future<User> getMe() async {
    final data = await _request('GET', '/auth/me');
    return User.fromJson(data['user']);
  }

  Future<User> updateSettings({
    String? theme,
    bool? notificationsEnabled,
    bool? priceAlertsEnabled,
  }) async {
    final data = await _request('PATCH', '/auth/settings', body: {
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'priceAlertsEnabled': priceAlertsEnabled,
    });
    return User.fromJson(data['user']);
  }

  // Products
  Future<List<Product>> getProducts(String userId) async {
    final data = await _request('GET', '/products?userId=$userId');
    return (data['products'] as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> addProduct(Map<String, dynamic> productData) async {
    final data = await _request('POST', '/products', body: productData);
    return Product.fromJson(data['product']);
  }

  Future<Product> updateProduct(String id, Map<String, dynamic> updates) async {
    final data = await _request('PATCH', '/products/$id', body: updates);
    return Product.fromJson(data['product']);
  }

  Future<void> deleteProduct(String id) async {
    await _request('DELETE', '/products/$id');
  }

  Future<void> markPurchased(String id, bool purchased) async {
    await _request('PATCH', '/products/$id/purchase', body: {'purchased': purchased});
  }

  Future<String> exportWishlist(String userId) async {
    final data = await _request('GET', '/products/export/$userId');
    return data['data'] as String;
  }

  Future<void> importWishlist(String userId, List<Map<String, dynamic>> products) async {
    await _request('POST', '/products/import', body: {'userId': userId, 'products': products});
  }

  // Collections
  Future<List<Collection>> getCollections(String userId) async {
    final data = await _request('GET', '/collections?userId=$userId');
    return (data['collections'] as List).map((e) => Collection.fromJson(e)).toList();
  }

  Future<Collection> createCollection(Map<String, dynamic> data) async {
    final res = await _request('POST', '/collections', body: data);
    return Collection.fromJson(res['collection']);
  }

  Future<Collection> updateCollection(String id, Map<String, dynamic> data) async {
    final res = await _request('PATCH', '/collections/$id', body: data);
    return Collection.fromJson(res['collection']);
  }

  Future<void> deleteCollection(String id) async {
    await _request('DELETE', '/collections/$id');
  }

  Future<void> seedDefaults(String userId) async {
    await _request('POST', '/collections/seed-defaults', body: {'userId': userId});
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => 'ApiException: $message (status $statusCode)';
}
