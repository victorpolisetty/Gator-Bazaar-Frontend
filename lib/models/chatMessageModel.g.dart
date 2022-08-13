// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatMessageModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageHome _$ChatMessageHomeFromJson(Map<String, dynamic> json) =>
    ChatMessageHome()
      ..message_text = json['message_text'] as String?
      ..recipient_profile_name = json['recipient_profile_name'] as String?
      ..creator_profile_name = json['creator_profile_name'] as String?
      ..item_id = json['item_id'] as int?
      ..creator_user_id = json['creator_user_id'] as int?
      ..recipient_user_id = json['recipient_user_id'] as int?
      ..createdAt = json['createdAt'] as String;

Map<String, dynamic> _$ChatMessageHomeToJson(ChatMessageHome instance) =>
    <String, dynamic>{
      'message_text': instance.message_text,
      'recipient_profile_name': instance.recipient_profile_name,
      'creator_profile_name': instance.creator_profile_name,
      'item_id': instance.item_id,
      'creator_user_id': instance.creator_user_id,
      'recipient_user_id': instance.recipient_user_id,
      'createdAt': instance.createdAt,
    };
