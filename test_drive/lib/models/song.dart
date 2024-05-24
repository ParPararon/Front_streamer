import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {

  final int id;
  final String name;
  final String artist;
  final  String album;
  final String path;

  Song({
    required this.id, 
    required this.name, 
    required this.artist, 
    required this.album, 
    required this.path
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);
}