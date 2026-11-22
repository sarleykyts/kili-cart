// GENERATED CODE - Hive TypeAdapters
import 'package:hive/hive.dart';
import 'product.dart';
import 'collection.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Product(
      id: fields[0] as String,
      userId: fields[1] as String,
      collectionId: fields[2] as String?,
      title: fields[3] as String,
      url: fields[4] as String,
      imageUrl: fields[5] as String,
      currentPrice: fields[6] as double,
      originalPrice: fields[7] as double,
      currency: fields[8] as String,
      targetPrice: fields[9] as double?,
      isOnFlashSale: fields[10] as bool,
      discountPercent: fields[11] as int,
      isArchived: fields[12] as bool,
      isPurchased: fields[13] as bool,
      flashSaleEndsAt: fields[14] as DateTime?,
      createdAt: fields[15] as DateTime,
      updatedAt: fields[16] as DateTime,
      synced: fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.collectionId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.currentPrice)
      ..writeByte(7)
      ..write(obj.originalPrice)
      ..writeByte(8)
      ..write(obj.currency)
      ..writeByte(9)
      ..write(obj.targetPrice)
      ..writeByte(10)
      ..write(obj.isOnFlashSale)
      ..writeByte(11)
      ..write(obj.discountPercent)
      ..writeByte(12)
      ..write(obj.isArchived)
      ..writeByte(13)
      ..write(obj.isPurchased)
      ..writeByte(14)
      ..write(obj.flashSaleEndsAt)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt)
      ..writeByte(17)
      ..write(obj.synced);
  }
}

class CollectionAdapter extends TypeAdapter<Collection> {
  @override
  final int typeId = 1;

  @override
  Collection read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Collection(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      color: fields[3] as String,
      isDefault: fields[4] as bool,
      productCount: fields[5] as int,
      createdAt: fields[6] as DateTime,
      synced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Collection obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.isDefault)
      ..writeByte(5)
      ..write(obj.productCount)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.synced);
  }
}
