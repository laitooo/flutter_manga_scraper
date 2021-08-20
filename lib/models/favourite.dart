import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:manga_scraper/models/manga.dart';
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/models/manga_list.dart';

part 'favourite.g.dart';

@HiveType(typeId: 0)
class Favourite extends HiveObject {
  @HiveField(0)
  final String slug;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String cover;

  Favourite({
    @required this.slug,
    @required this.name,
    @required this.cover,
  });

  factory Favourite.fromManga(Manga manga) => Favourite(
        slug: manga.slug,
        name: manga.name,
        cover: manga.cover,
      );

  factory Favourite.fromMangaDetail(MangaDetail manga) => Favourite(
        slug: manga.slug,
        name: manga.name,
        cover: manga.cover,
      );

  factory Favourite.fromMangaListItem(MangaListItem manga) => Favourite(
        slug: manga.slug,
        name: manga.name,
        cover: manga.cover,
      );
}
