import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manga.g.dart';

@JsonSerializable()
class Manga {
  final String slug;
  final String name;
  final String cover;
  final String url;
  @JsonKey(defaultValue: false)
  bool isFav;

  Manga(
      {@required this.slug,
      @required this.name,
      @required this.cover,
      @required this.url,
      this.isFav = false});

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);
  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
