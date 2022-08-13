// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryItemModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryItemModel _$CategoryItemModelFromJson(Map<String, dynamic> json) =>
    CategoryItemModel()
      ..keyword = json['keyword'] as String
      ..categoryId = json['categoryId'] as int
      ..totalPages = json['totalPages'] as int
      ..currentPage = json['currentPage'] as int
      ..userIdFromDb = json['userIdFromDb'] as int
      ..categoryItems = (json['categoryItems'] as List<dynamic>)
          .map((e) => ItemWithImages.fromJson(e as Map<String, dynamic>))
          .toList()
      ..categorySearchedItems = (json['categorySearchedItems'] as List<dynamic>)
          .map((e) => ItemWithImages.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CategoryItemModelToJson(CategoryItemModel instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'categoryId': instance.categoryId,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'userIdFromDb': instance.userIdFromDb,
      'categoryItems': instance.categoryItems.map((e) => e.toJson()).toList(),
      'categorySearchedItems':
          instance.categorySearchedItems.map((e) => e.toJson()).toList(),
    };

CategoryItemPage _$CategoryItemPageFromJson(Map<String, dynamic> json) =>
    CategoryItemPage(
      (json['categoryItemList'] as List<dynamic>)
          .map((e) => ItemWithImages.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryItemPageToJson(CategoryItemPage instance) =>
    <String, dynamic>{
      'categoryItemList':
          instance.categoryItemList.map((e) => e.toJson()).toList(),
    };
