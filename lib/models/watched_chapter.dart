import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'watched_chapter.g.dart';

@HiveType(typeId: 3)
class WatchedChapter {
  @HiveField(0)
  final String slug;
  @HiveField(1)
  final String number;

  WatchedChapter({
    @required this.slug,
    @required this.number,
  });
}
