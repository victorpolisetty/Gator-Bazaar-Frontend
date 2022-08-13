// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messageModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMessage _$UserMessageFromJson(Map<String, dynamic> json) => UserMessage()
  ..message_text = json['message_text'] as String?
  ..recipient_profile_name = json['recipient_profile_name'] as String?
  ..creator_profile_name = json['creator_profile_name'] as String?
  ..creator_user_id = json['creator_user_id'] as int?
  ..recipient_user_id = json['recipient_user_id'] as int?
  ..item_id = json['item_id'] as int?
  ..createdAt = json['createdAt'] as String;

Map<String, dynamic> _$UserMessageToJson(UserMessage instance) =>
    <String, dynamic>{
      'message_text': instance.message_text,
      'recipient_profile_name': instance.recipient_profile_name,
      'creator_profile_name': instance.creator_profile_name,
      'creator_user_id': instance.creator_user_id,
      'recipient_user_id': instance.recipient_user_id,
      'item_id': instance.item_id,
      'createdAt': instance.createdAt,
    };
