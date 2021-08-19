import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/screens/home/home_drawer.dart';
import 'package:manga_scraper/screens/manga_list/manga_list_screen.dart';
import 'package:manga_scraper/screens/search/seach_screen.dart';
import 'package:manga_scraper/screens/downloads/downloads_list_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/preferences.dart';

import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  final globalMangaListKey = new GlobalKey<MangaListScreenState>();
  final globalDownloadKey = new GlobalKey<DownloadsScreenState>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget page;
  String title;
  bool isSearchIcon;
  bool isListIcon;
  bool isDeleteIcon;

  @override
  void initState() {
    super.initState();
    page = HomePage();
    isSearchIcon = true;
    isListIcon = false;
    isDeleteIcon = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getPrimaryColor(),
        toolbarHeight: 40,
        title: Text(
          title ?? Language.of(context).homeScreen,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
        centerTitle: true,
        actions: [
          if (isListIcon)
            IconButton(
              onPressed: () async {
                await prefs.setGridMangaList(!prefs.isGridMangaList());
                if (widget.globalMangaListKey != null) {
                  widget.globalMangaListKey.currentState.setState(() {});
                }
                setState(() {});
              },
              icon: SvgPicture.asset(
                prefs.isGridMangaList()
                    ? 'assets/icons/list_icon.svg'
                    : 'assets/icons/grid_icon.svg',
                color: Colors.white,
                width: 25,
                height: 25,
              ),
            ),
          if (isSearchIcon)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/search_icon.svg',
                color: Colors.white,
                width: 25,
                height: 25,
              ),
            ),
          if (isDeleteIcon)
            IconButton(
              onPressed: () async {
                if (widget.globalDownloadKey != null) {
                  try {
                    widget.globalDownloadKey.currentState.deleteSelected();
                  } catch (e) {
                    print('error:${e.toString()}');
                  }
                }
              },
              icon: SvgPicture.asset(
                'assets/icons/delete_icon.svg',
                color: Colors.white,
                width: 25,
                height: 25,
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: HomeDrawer(
          onPageChanged: (
            newPage,
            newTitle,
            newSearchIcon,
            newListIcon,
            newDownloadIcon,
          ) {
            Navigator.pop(context);
            setState(() {
              page = newPage;
              title = newTitle;
              isSearchIcon = newSearchIcon;
              isListIcon = newListIcon;
              isDeleteIcon = newDownloadIcon;
            });
          },
          mangaListKey: widget.globalMangaListKey,
          downloadsKey: widget.globalDownloadKey,
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            if (!(page is HomePage)) {
              setState(() {
                page = HomePage();
                title = Language.of(context).homeScreen;
                isSearchIcon = true;
                isListIcon = false;
                isDeleteIcon = false;
              });
            } else {
              return await _showExitDialog(context) ?? false;
            }
            return false;
          },
          child: page ?? HomePage()),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Language.of(context).exit),
        content: Text(Language.of(context).youSureYouWantToExit),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(Language.of(context).no),
          ),
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(Language.of(context).yes),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}
