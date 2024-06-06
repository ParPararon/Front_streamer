// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songIdList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongIdList _$SongIdListFromJson(Map<String, dynamic> json) => SongIdList(
      ranks: (json['ranks'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList() ?? [],
    );

Map<String, dynamic> _$SongIdListToJson(SongIdList instance) => <String, dynamic>{
      'ranks': instance.ranks,
    };
