import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manga_detail.g.dart';

@JsonSerializable()
class MangaDetail {
  final String name;
  final String slug;
  final String status;
  final String rate;
  final String author;
  final String summary;
  final String cover;
  final List<String> categories;
  final List<Chapter> chapters;
  @JsonKey(defaultValue: false)
  bool isFav;

  MangaDetail(
      {@required this.name,
      @required this.slug,
      @required this.status,
      @required this.rate,
      @required this.author,
      @required this.summary,
      @required this.cover,
      @required this.categories,
      @required this.chapters,
      this.isFav = false});

  factory MangaDetail.fromJson(Map<String, dynamic> json) =>
      _$MangaDetailFromJson(json);
  Map<String, dynamic> toJson() => _$MangaDetailToJson(this);
}

@JsonSerializable()
class Chapter {
  final String name;
  final String slug;
  final String url;
  final String number;
  final String volume;
  @JsonKey(defaultValue: false)
  bool isWatched;

  Chapter(
      {@required this.name,
      @required this.slug,
      @required this.number,
      @required this.url,
      @required this.volume,
      this.isWatched = false});

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
