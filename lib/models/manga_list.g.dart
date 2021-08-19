// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaListItem _$MangaListItemFromJson(Map<String, dynamic> json) {
  return MangaListItem(
    id: json['id'] as int,
    slug: json['slug'] as String,
    name: json['name'] as String,
    cover: json['cover'] as String,
    lastChapter: json['lastChapter'] == null
        ? null
        : Chapter.fromJson(json['lastChapter'] as Map<String, dynamic>),
    views: json['views'] as int,
    rate: json['item_rating'] as String,
    categories: (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isFav: json['isFav'] as bool ?? false,
  );
}

Map<String, dynamic> _$MangaListItemToJson(MangaListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'cover': instance.cover,
      'lastChapter': instance.lastChapter,
      'views': instance.views,
      'item_rating': instance.rate,
      'categories': instance.categories,
      'isFav': instance.isFav,
    };
