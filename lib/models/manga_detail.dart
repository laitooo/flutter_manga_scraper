import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manga_detail.g.dart';

@JsonSerializable()
class MangaDetail {
  final int id;
  final String name;
  final String slug;
  @JsonKey(name: "status_id")
  final int status;
  @JsonKey(name: "type_id")
  final int type;
  @JsonKey(name: "item_rating")
  final String rate;
  final String author;
  final String releaseDate;
  final String summary;
  final String cover;
  final List<Category> categories;
  final List<Chapter> chapters;
  @JsonKey(defaultValue: false)
  bool isFav;

  MangaDetail(
      {@required this.id,
      @required this.name,
      @required this.slug,
      @required this.status,
      @required this.type,
      @required this.rate,
      @required this.author,
      @required this.releaseDate,
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
class Category {
  final int id;
  final String name;
  final String slug;

  Category({@required this.id, @required this.name, @required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Chapter {
  final int id;
  final String name;
  final String slug;
  final String number;
  @JsonKey(name: "manga_id")
  final int mangaId;
  @JsonKey(defaultValue: false)
  bool isWatched;

  Chapter(
      {@required this.id,
      @required this.name,
      @required this.slug,
      @required this.number,
      @required this.mangaId,
      this.isWatched = false});

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
