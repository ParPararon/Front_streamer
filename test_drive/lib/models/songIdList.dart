import 'package:json_annotation/json_annotation.dart';

part 'songIdList.g.dart';

@JsonSerializable()
class SongIdList {

  final List<int> ranks;

  SongIdList({
    required this.ranks
  });

  factory SongIdList.fromJson(Map<String, dynamic> json) {
    return SongIdList(
      ranks: (json['ranks'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => _$SongIdListToJson(this);
}