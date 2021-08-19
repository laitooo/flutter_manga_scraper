// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaDetail _$MangaDetailFromJson(Map<String, dynamic> json) {
  return MangaDetail(
    id: json['id'] as int,
    name: json['name'] as String,
    slug: json['slug'] as String,
    status: json['status_id'] as int,
    type: json['type_id'] as int,
    rate: json['item_rating'] as String,
    author: json['author'] as String,
    releaseDate: json['releaseDate'] as String,
    summary: json['summary'] as String,
    cover: json['cover'] as String,
    categories: (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    chapters: (json['chapters'] as List)
        ?.map((e) =>
            e == null ? null : Chapter.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isFav: json['isFav'] as bool ?? false,
  );
}

Map<String, dynamic> _$MangaDetailToJson(MangaDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'status_id': instance.status,
      'type_id': instance.type,
      'item_rating': instance.rate,
      'author': instance.author,
      'releaseDate': instance.releaseDate,
      'summary': instance.summary,
      'cover': instance.cover,
      'categories': instance.categories,
      'chapters': instance.chapters,
      'isFav': instance.isFav,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as int,
    name: json['name'] as String,
    slug: json['slug'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return Chapter(
    id: json['id'] as int,
    name: json['name'] as String,
    slug: json['slug'] as String,
    number: json['number'] as String,
    mangaId: json['manga_id'] as int,
    isWatched: json['isWatched'] as bool ?? false,
  );
}

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'number': instance.number,
      'manga_id': instance.mangaId,
      'isWatched': instance.isWatched,
    };
