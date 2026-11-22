import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String? collectionId;
  @HiveField(3)
  String title;
  @HiveField(4)
  String url;
  @HiveField(5)
  String imageUrl;
  @HiveField(6)
  double currentPrice;
  @HiveField(7)
  double originalPrice;
  @HiveField(8)
  String currency;
  @HiveField(9)
  double? targetPrice;
  @HiveField(10)
  bool isOnFlashSale;
  @HiveField(11)
  int discountPercent;
  @HiveField(12)
  bool isArchived;
  @HiveField(13)
  bool isPurchased;
  @HiveField(14)
  DateTime? flashSaleEndsAt;
  @HiveField(15)
  DateTime createdAt;
  @HiveField(16)
  DateTime updatedAt;
  @HiveField(17)
  bool synced;

  Product({
    required this.id,
    required this.userId,
    this.collectionId,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.currency,
    this.targetPrice,
    this.isOnFlashSale = false,
    this.discountPercent = 0,
    this.isArchived = false,
    this.isPurchased = false,
    this.flashSaleEndsAt,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'collectionId': collectionId,
    'title': title,
    'url': url,
    'imageUrl': imageUrl,
    'currentPrice': currentPrice,
    'originalPrice': originalPrice,
    'currency': currency,
    'targetPrice': targetPrice,
    'isOnFlashSale': isOnFlashSale,
    'discountPercent': discountPercent,
    'isArchived': isArchived,
    'isPurchased': isPurchased,
    'flashSaleEndsAt': flashSaleEndsAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'synced': synced,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as String,
    userId: json['userId'] as String,
    collectionId: json['collectionId'] as String?,
    title: json['title'] as String,
    url: json['url'] as String,
    imageUrl: json['imageUrl'] as String? ?? '',
    currentPrice: (json['currentPrice'] as num).toDouble(),
    originalPrice: (json['originalPrice'] as num).toDouble(),
    currency: json['currency'] as String? ?? 'KES',
    targetPrice: json['targetPrice'] != null ? (json['targetPrice'] as num).toDouble() : null,
    isOnFlashSale: json['isOnFlashSale'] as bool? ?? false,
    discountPercent: json['discountPercent'] as int? ?? 0,
    isArchived: json['isArchived'] as bool? ?? false,
    isPurchased: json['isPurchased'] as bool? ?? false,
    flashSaleEndsAt: json['flashSaleEndsAt'] != null ? DateTime.parse(json['flashSaleEndsAt']) : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    synced: json['synced'] as bool? ?? true,
  );
}
