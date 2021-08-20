import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manga_scraper/models/favourite.dart';
import 'package:manga_scraper/models/manga.dart';
import 'package:manga_scraper/models/manga_list.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/utils/features.dart';

class MangaGridCard extends StatelessWidget {
  final String name;
  final String slug;
  final String cover;
  final Function onClick;

  const MangaGridCard({
    Key key,
    this.name,
    this.slug,
    this.cover,
    this.onClick,
  }) : super(key: key);

  factory MangaGridCard.fromManga({
    Manga manga,
    Function onClick,
  }) =>
      MangaGridCard(
        name: manga.name,
        slug: manga.slug,
        cover: manga.cover,
        onClick: onClick,
      );

  factory MangaGridCard.fromMangaListItem({
    MangaListItem mangaItem,
    Function onClick,
  }) =>
      MangaGridCard(
        name: mangaItem.name,
        slug: mangaItem.slug,
        cover: mangaItem.cover,
        onClick: onClick,
      );

  factory MangaGridCard.fromFavourite({
    Favourite favourite,
    Function onClick,
  }) =>
      MangaGridCard(
        name: favourite.name,
        slug: favourite.slug,
        cover: favourite.cover,
        onClick: onClick,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 225,
      padding: EdgeInsets.fromLTRB(1, 1, 1, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => onClick(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image(
                image: Features.isMockHttp
                    ? AssetImage(cover)
                    : NetworkImage(cover),
                width: 118,
                height: 195,
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, widget, progress) {
                  if (progress == null) {
                    return widget;
                  }
                  return SizedBox(
                    width: 118,
                    height: 195,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () => onClick(),
            child: Text(
              name,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.getPrimaryColor(),
                  fontFamily: AppFonts.english),
              strutStyle: AppFonts.getStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
