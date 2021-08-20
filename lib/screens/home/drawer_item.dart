import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';

class DrawerItem extends StatelessWidget {
  final HomePageType current;
  final String icon;
  final Widget page;
  final Function(
    Widget widget,
    String title,
    bool isSearchIcon,
    bool isListIcon,
    bool isDeleteIcon,
  ) onClick;

  const DrawerItem({Key key, this.current, this.icon, this.page, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Future.delayed(
          Duration.zero,
          () {
            onClick(
                page,
                getTitle(current, context),
                current != HomePageType.downloads,
                current == HomePageType.mangaList,
                current == HomePageType.downloads);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: Colors.white,
              width: 22,
              height: 22,
            ),
            SizedBox(width: 20),
            Text(
              getTitle(current, context),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              strutStyle: AppFonts.getStyle(),
            )
          ],
        ),
      ),
    );
  }

  String getTitle(HomePageType page, BuildContext context) {
    switch (page) {
      case HomePageType.favourites:
        return Language.of(context).favorites;
      case HomePageType.mangaList:
        return Language.of(context).mangaList;
      case HomePageType.latest:
        return Language.of(context).latestChapters;
      case HomePageType.downloads:
        return Language.of(context).downloads;
      case HomePageType.popular:
        return Language.of(context).mostViewed;
      default:
        return Language.of(context).homeScreen;
    }
  }
}
