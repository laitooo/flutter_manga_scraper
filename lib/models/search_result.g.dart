// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return SearchResult(
    id: json['id'] as int,
    slug: json['slug'] as String,
    name: json['name'] as String,
    cover: json['cover'] as String,
    lastChapter: json['lastChapter'] == null
        ? null
        : Chapter.fromJson(json['lastChapter'] as Map<String, dynamic>),
    authors: (json['authors'] as List)
        ?.map((e) =>
            e == null ? null : Author.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    categories: (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'cover': instance.cover,
      'lastChapter': instance.lastChapter,
      'authors': instance.authors,
      'categories': instance.categories,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return Author(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
