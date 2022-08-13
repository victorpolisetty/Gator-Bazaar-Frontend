// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerItemModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerItemPage _$SellerItemPageFromJson(Map<String, dynamic> json) =>
    SellerItemPage(
      (json['sellerItemList'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SellerItemPageToJson(SellerItemPage instance) =>
    <String, dynamic>{
      'sellerItemList': instance.sellerItemList.map((e) => e.toJson()).toList(),
    };

SellerItemModel _$SellerItemModelFromJson(Map<String, dynamic> json) =>
    SellerItemModel()
      ..totalPages = json['totalPages'] as int
      ..currentPage = json['currentPage'] as int
      ..userIdFromDB = json['userIdFromDB'] as int;

Map<String, dynamic> _$SellerItemModelToJson(SellerItemModel instance) =>
    <String, dynamic>{
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'userIdFromDB': instance.userIdFromDB,
    };
