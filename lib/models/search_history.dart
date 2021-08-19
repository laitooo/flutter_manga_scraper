import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:manga_scraper/models/search_result.dart';

part 'search_history.g.dart';

@HiveType(typeId: 1)
class SearchHistory extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String name;

  SearchHistory({@required this.id, @required this.slug, @required this.name});

  factory SearchHistory.fromSearchResult(SearchResult searchResult) =>
      SearchHistory(
        id: searchResult.id,
        slug: searchResult.slug,
        name: searchResult.name,
      );
}
