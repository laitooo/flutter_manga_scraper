import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manga_scraper/models/manga_detail.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final int id;
  final String slug;
  final String name;
  final String cover;
  final Chapter lastChapter;
  final List<Author> authors;
  final List<Category> categories;

  SearchResult({
    @required this.id,
    @required this.slug,
    @required this.name,
    @required this.cover,
    @required this.lastChapter,
    @required this.authors,
    @required this.categories,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  String toString() {
    return "Search results: id: ${this.id} name: ${this.name} slug: ${this.slug}";
  }
}

@JsonSerializable()
class Author {
  final int id;
  final String name;

  Author({@required this.id, @required this.name});

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
