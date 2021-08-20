import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final String slug;
  final String name;
  final String cover;
  final String url;
  final String author;
  final List<String> categories;

  SearchResult({
    @required this.slug,
    @required this.name,
    @required this.cover,
    @required this.url,
    @required this.author,
    @required this.categories,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  String toString() {
    return "Search results: name: ${this.name} slug: ${this.slug}";
  }
}
