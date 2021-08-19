// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manga _$MangaFromJson(Map<String, dynamic> json) {
  return Manga(
    id: json['id'] as int,
    slug: json['slug'] as String,
    name: json['name'] as String,
    cover: json['cover'] as String,
    rate: json['item_rating'] as String,
    isFav: json['isFav'] as bool ?? false,
  );
}

Map<String, dynamic> _$MangaToJson(Manga instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'cover': instance.cover,
      'item_rating': instance.rate,
      'isFav': instance.isFav,
    };
