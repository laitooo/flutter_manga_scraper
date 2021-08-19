import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/models/favourite.dart';
import 'package:manga_scraper/models/manga.dart';
import 'package:manga_scraper/models/manga_list.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/share.dart';

class MangaGridCard extends StatelessWidget {
  final String name;
  final String slug;
  final String cover;
  final String rate;
  final bool isFav;
  final Function onClick;
  final Function onFavClicked;

  const MangaGridCard(
      {Key key,
      this.name,
      this.slug,
      this.cover,
      this.rate,
      this.isFav,
      this.onClick,
      this.onFavClicked})
      : super(key: key);

  factory MangaGridCard.fromManga({
    Manga manga,
    bool isFav,
    Function onClick,
    Function onFavClicked,
  }) =>
      MangaGridCard(
        name: manga.name,
        slug: manga.slug,
        cover: manga.cover,
        rate: manga.rate,
        isFav: isFav,
        onClick: onClick,
        onFavClicked: onFavClicked,
      );

  factory MangaGridCard.fromMangaListItem({
    MangaListItem mangaItem,
    bool isFav,
    Function onClick,
    Function onFavClicked,
  }) =>
      MangaGridCard(
        name: mangaItem.name,
        slug: mangaItem.slug,
        cover: mangaItem.cover,
        rate: mangaItem.rate,
        isFav: isFav,
        onClick: onClick,
        onFavClicked: onFavClicked,
      );

  factory MangaGridCard.fromFavourite({
    Favourite favourite,
    bool isFav,
    Function onClick,
    Function onFavClicked,
  }) =>
      MangaGridCard(
        name: favourite.name,
        slug: favourite.slug,
        cover: favourite.cover,
        rate: favourite.rate,
        isFav: isFav,
        onClick: onClick,
        onFavClicked: onFavClicked,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
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
          SizedBox(height: 5),
          Divider(
            thickness: 0.5,
            color: Colors.black,
            height: 0.5,
          ),
          SizedBox(height: 5),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    ShareLink().shareManga(name, slug, context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/share_icon.svg',
                    width: 12,
                    height: 12,
                  ),
                ),
                VerticalDivider(
                  thickness: 0.5,
                  color: Colors.black,
                  width: 0.5,
                ),
                SvgPicture.asset(
                  'assets/icons/star_icon.svg',
                  width: 12,
                  height: 12,
                ),
                Text(
                  rate,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.unselectedTabColor,
                    fontFamily: AppFonts.english,
                  ),
                  strutStyle: AppFonts.getStyle(),
                ),
                VerticalDivider(
                  thickness: 0.5,
                  color: Colors.black,
                  width: 0.5,
                ),
                InkWell(
                  onTap: onFavClicked,
                  child: SvgPicture.asset(
                    isFav
                        ? 'assets/icons/fav_icon.svg'
                        : 'assets/icons/unfav_icon.svg',
                    width: 12,
                    height: 12,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
