import 'package:hive/hive.dart';

part 'collection.g.dart';

@HiveType(typeId: 1)
class Collection extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String name;
  @HiveField(3)
  String color;
  @HiveField(4)
  bool isDefault;
  @HiveField(5)
  int productCount;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  bool synced;

  Collection({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
    this.isDefault = false,
    this.productCount = 0,
    required this.createdAt,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'color': color,
    'isDefault': isDefault,
    'productCount': productCount,
    'createdAt': createdAt.toIso8601String(),
    'synced': synced,
  };

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    color: json['color'] as String,
    isDefault: json['isDefault'] as bool? ?? false,
    productCount: json['productCount'] as int? ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    synced: json['synced'] as bool? ?? true,
  );
}

const List<Map<String, String>> defaultCollections = [
  {'name': 'Shoes', 'color': '#FF6B00'},
  {'name': 'Clothes', 'color': '#FF8A33'},
  {'name': 'Luxury', 'color': '#D97706'},
  {'name': 'Bedroom', 'color': '#E55A00'},
  {'name': 'Kitchen', 'color': '#FF6B00'},
  {'name': 'Bathroom', 'color': '#FF8A33'},
];
