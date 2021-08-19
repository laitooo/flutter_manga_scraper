import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'latest_chapter.g.dart';

@JsonSerializable()
class LatestChapter {
  final int id;
  final String cover;
  final String number;
  final String date;
  final MangaInfo manga;

  LatestChapter(
      {@required this.id,
      @required this.cover,
      @required this.number,
      @required this.date,
      @required this.manga});

  factory LatestChapter.fromJson(Map<String, dynamic> json) =>
      _$LatestChapterFromJson(json);
  Map<String, dynamic> toJson() => _$LatestChapterToJson(this);
}

@JsonSerializable()
class MangaInfo {
  final String slug;
  final String name;

  MangaInfo({@required this.slug, @required this.name});

  factory MangaInfo.fromJson(Map<String, dynamic> json) =>
      _$MangaInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MangaInfoToJson(this);
}
