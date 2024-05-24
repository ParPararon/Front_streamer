import 'package:json_annotation/json_annotation.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist{
  final int id;
  final int user_id;
  final String name;
  final List<int> songs;


  Playlist({
    required this.id,
    required this.user_id,
    required this.name,
    required this.songs
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as int,
      user_id: json['user_id'] as int,
      name: json['name'] as String,
      songs: (json['songs'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

}