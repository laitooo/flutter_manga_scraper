// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestChapter _$LatestChapterFromJson(Map<String, dynamic> json) {
  return LatestChapter(
    id: json['id'] as int,
    cover: json['cover'] as String,
    number: json['number'] as String,
    date: json['date'] as String,
    manga: json['manga'] == null
        ? null
        : MangaInfo.fromJson(json['manga'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LatestChapterToJson(LatestChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'number': instance.number,
      'date': instance.date,
      'manga': instance.manga,
    };

MangaInfo _$MangaInfoFromJson(Map<String, dynamic> json) {
  return MangaInfo(
    slug: json['slug'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$MangaInfoToJson(MangaInfo instance) => <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
    };
