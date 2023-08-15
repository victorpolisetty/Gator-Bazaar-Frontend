import 'package:json_annotation/json_annotation.dart';
import 'package:student_shopping_v1/models/itemModel.dart'; // Import the original model
import 'package:student_shopping_v1/models/recentItemModel.dart';

class FeaturedItemsSerializer implements JsonConverter<ItemWithImages, Map<String, dynamic>> {
  const FeaturedItemsSerializer();

  //used for featured items
  @override
  ItemWithImages fromJson(Map<String, dynamic> json) =>
        ItemWithImages()
          ..category_id = json['item']['category_id'] as int?
          ..seller_id = json['item']['seller_id'] as int?
          ..id = json['item']['id'] as int?
          ..name = json['item']['name'] as String?
          ..seller_email = json['item']['seller_email'] as String?
          ..seller_name = json['item']['seller_name'] as String?
          ..description = json['item']['description'] as String?
          ..price = json['item']['price'] as num?
          ..isSold = json['item']['isSold'] as bool?
          ..itemPictureIds = (json['item']['itemPictureIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList();

  @override
  Map<String, dynamic> toJson(ItemWithImages item) {
    return item.toJson();
  }
}

class RecentItemPageSerializer implements JsonConverter<RecentItemPage, Map<String, dynamic>> {
  const RecentItemPageSerializer();

  @override
  RecentItemPage fromJson(Map<String, dynamic> json) {
    return RecentItemPage.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(RecentItemPage page) {
    return page.toJson();
  }
}
