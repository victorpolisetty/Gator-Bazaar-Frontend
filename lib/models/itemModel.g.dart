// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPage _$ItemPageFromJson(Map<String, dynamic> json) => ItemPage(
      (json['itemList'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemPageToJson(ItemPage instance) => <String, dynamic>{
      'itemList': instance.itemList,
    };

ItemWithImages _$ItemWithImagesFromJson(Map<String, dynamic> json) =>
    ItemWithImages()
      ..category_id = json['category_id'] as int?
      ..seller_id = json['seller_id'] as int?
      ..id = json['id'] as int?
      ..name = json['name'] as String
      ..description = json['description'] as String
      ..price = json['price'] as num
      ..isSold = json['isSold'] as bool
      ..itemPictureIds = (json['itemPictureIds'] as List<dynamic>)
          .map((e) => e as int)
          .toList();

Map<String, dynamic> _$ItemWithImagesToJson(ItemWithImages instance) =>
    <String, dynamic>{
      'category_id': instance.category_id,
      'seller_id': instance.seller_id,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'isSold': instance.isSold,
      'itemPictureIds': instance.itemPictureIds,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['category_id'] as int,
      json['name'] as String,
      json['price'] as num,
      json['description'] as String,
      id: json['id'] as int? ?? -1,
    );

Map<String, dynamic> _$ItemToJson(Item instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('category_id', toNull(instance.category_id));
  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['price'] = instance.price;
  return val;
}
