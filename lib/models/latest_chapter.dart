import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'latest_chapter.g.dart';

@JsonSerializable()
class LatestChapter {
  final String slug;
  final String url;
  final String name;
  final String cover;
  final String number;

  LatestChapter({@required this.slug,
    @required this.url,
    @required this.name,
      @required this.cover,
      @required this.number,
      });

  factory LatestChapter.fromJson(Map<String, dynamic> json) =>
      _$LatestChapterFromJson(json);
  Map<String, dynamic> toJson() => _$LatestChapterToJson(this);
}
