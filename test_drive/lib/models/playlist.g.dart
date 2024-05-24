// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: (json['id'] as num).toInt(),
      user_id: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ?? [],
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'name': instance.name,
      'songs': instance.songs,
    };
