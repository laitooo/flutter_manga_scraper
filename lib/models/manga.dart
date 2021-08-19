import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manga.g.dart';

@JsonSerializable()
class Manga {
  final int id;
  final String slug;
  final String name;
  final String cover;
  @JsonKey(name: "item_rating")
  final String rate;
  @JsonKey(defaultValue: false)
  bool isFav;

  Manga(
      {@required this.id,
      @required this.slug,
      @required this.name,
      @required this.cover,
      @required this.rate,
      this.isFav = false});

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);
  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
