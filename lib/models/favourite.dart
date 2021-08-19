import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:manga_scraper/models/manga.dart';
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/models/manga_list.dart';

part 'favourite.g.dart';

@HiveType(typeId: 0)
class Favourite extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String cover;
  @HiveField(4)
  final String rate;

  Favourite(
      {@required this.id,
      @required this.slug,
      @required this.name,
      @required this.cover,
      @required this.rate});

  factory Favourite.fromManga(Manga manga) => Favourite(
      id: manga.id,
      slug: manga.slug,
      name: manga.name,
      cover: manga.cover,
      rate: manga.rate);

  factory Favourite.fromMangaDetail(MangaDetail manga) => Favourite(
      id: manga.id,
      slug: manga.slug,
      name: manga.name,
      cover: manga.cover,
      rate: manga.rate);

  factory Favourite.fromMangaListItem(MangaListItem manga) => Favourite(
      id: manga.id,
      slug: manga.slug,
      name: manga.name,
      cover: manga.cover,
      rate: manga.rate);
}
