import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/screens/home/tabs/favourites_screen.dart';
import 'package:manga_scraper/screens/home/tabs/latest_chapters_screen.dart';
import 'package:manga_scraper/screens/home/tabs/most_viewed_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tabs = [];
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: AppColors.getPrimaryColor(),
            labelPadding: EdgeInsets.zero,
            labelColor: AppColors.getPrimaryColor(),
            unselectedLabelColor: AppColors.unselectedTabColor,
            onTap: (index) {
              setState(() {
                currentTab = index;
              });
            },
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/latest_chapters_icon.svg',
                      width: 20,
                      height: 20,
                      color: currentTab == 0
                          ? AppColors.getPrimaryColor()
                          : AppColors.unselectedTabColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Language.of(context).latestChapters,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: AppFonts.getStyle(),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/most_viewed_icon.svg',
                      width: 20,
                      height: 20,
                      color: currentTab == 1
                          ? AppColors.getPrimaryColor()
                          : AppColors.unselectedTabColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Language.of(context).mostViewed,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: AppFonts.getStyle(),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/fav_icon.svg',
                      width: 20,
                      height: 20,
                      color: currentTab == 2
                          ? AppColors.getPrimaryColor()
                          : AppColors.unselectedTabColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Language.of(context).favorites,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: AppFonts.getStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: TabBarView(children: [
            LatestChaptersScreen(),
            MostViewedScreen(),
            FavouritesScreen(),
          ]),
        ),
      ),
    );
  }
}
