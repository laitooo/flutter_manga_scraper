import 'package:flutter/material.dart';
import 'package:manga_scraper/screens/downloads/downloads_list_screen.dart';
import 'package:manga_scraper/screens/home/drawer_item.dart';
import 'package:manga_scraper/screens/home/tabs/favourites_screen.dart';
import 'package:manga_scraper/screens/home/tabs/latest_chapters_screen.dart';
import 'package:manga_scraper/screens/home/tabs/most_viewed_screen.dart';
import 'package:manga_scraper/screens/manga_list/manga_list_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';

class HomeDrawer extends StatelessWidget {
  final Function(
    Widget widget,
    String title,
    bool isSearchIcon,
    bool isListIcon,
    bool isDeleteIcon,
  ) onPageChanged;
  final Key mangaListKey;
  final Key downloadsKey;

  const HomeDrawer(
      {Key key, this.onPageChanged, this.mangaListKey, this.downloadsKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.getPrimaryColor(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/manga_logo.png',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Text(
                      Language.of(context).appName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      strutStyle: AppFonts.getStyle(),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              DrawerItem(
                current: HomePageType.favourites,
                icon: 'assets/icons/fav_icon.svg',
                page: FavouritesScreen(),
                onClick: onPageChanged,
              ),
              DrawerItem(
                current: HomePageType.latest,
                icon: 'assets/icons/latest_chapters_icon.svg',
                page: LatestChaptersScreen(),
                onClick: onPageChanged,
              ),
              DrawerItem(
                current: HomePageType.popular,
                icon: 'assets/icons/most_viewed_icon.svg',
                page: MostViewedScreen(),
                onClick: onPageChanged,
              ),
              DrawerItem(
                current: HomePageType.mangaList,
                icon: 'assets/icons/grid_icon.svg',
                page: MangaListScreen(
                  key: mangaListKey,
                ),
                onClick: onPageChanged,
              ),
              DrawerItem(
                current: HomePageType.downloads,
                icon: 'assets/icons/download_icon.svg',
                page: DownloadsScreen(
                  globalKey: downloadsKey,
                ),
                onClick: onPageChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
