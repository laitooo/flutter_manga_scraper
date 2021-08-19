import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manga_scraper/models/manga_detail.dart';

part 'manga_list.g.dart';

@JsonSerializable()
class MangaListItem {
  final int id;
  final String slug;
  final String name;
  final String cover;
  final Chapter lastChapter;
  final int views;
  @JsonKey(name: "item_rating")
  final String rate;
  final List<Category> categories;
  @JsonKey(defaultValue: false)
  bool isFav;

  MangaListItem(
      {@required this.id,
      @required this.slug,
      @required this.name,
      @required this.cover,
      @required this.lastChapter,
      @required this.views,
      @required this.rate,
      @required this.categories,
      this.isFav = false});

  factory MangaListItem.fromJson(Map<String, dynamic> json) =>
      _$MangaListItemFromJson(json);
  Map<String, dynamic> toJson() => _$MangaListItemToJson(this);
}
