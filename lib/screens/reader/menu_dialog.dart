import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/blocs/manga_pages_bloc.dart';
import 'package:manga_scraper/blocs/oflline_pages_bloc.dart';
import 'package:manga_scraper/repositories/download_repo.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/service_locator.dart';
import 'package:manga_scraper/utils/extensions.dart';

class MenuDialog extends StatelessWidget {
  final bool isOnline;
  final int currentPage;
  final Function reloadReader;
  final Function showSettingsCallback;
  final Function shareCallback;

  const MenuDialog({
    Key key,
    this.isOnline,
    this.currentPage,
    this.reloadReader,
    this.showSettingsCallback,
    this.shareCallback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _spacer = SizedBox(height: 2, child: Divider(color: Colors.white));
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 45, start: 15),
        child: Material(
          child: Container(
            color: Colors.black,
            height: 165,
            width: MediaQuery.of(context).size.width * 0.45,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _menuItem(
                  Language.of(context).reload,
                  'assets/icons/reload_icon.svg',
                  reloadReader,
                ),
                _spacer,
                _menuItem(Language.of(context).saveImage,
                    'assets/icons/brightness_icon.svg', () async {
                  if (isOnline) {
                    if (Features.isMockHttp) {
                      print('mock - online manga reader : saved shot ');
                      context.showSnackBar(
                        Language.of(context).savedScreenshotToStorage,
                        2,
                      );
                    } else {
                      final image = BlocProvider.of<MangaPagesBloc>(context)
                          .state
                          .list[currentPage];
                      final res = await serviceLocator
                          .get<DownloadRepository>()
                          .takeScreenshot(image);
                      if (res.isValue) {
                        context.showSnackBar(
                          Language.of(context).savedScreenshotToStorage,
                          2,
                        );
                      } else {
                        context.showSnackBar(
                          Language.of(context).someErrorOccurred,
                          2,
                        );
                      }
                    }
                  } else {
                    if (Features.isMockMoor) {
                      print('mock - offline manga reader : saved shot');
                      context.showSnackBar(
                        Language.of(context).savedScreenshotToStorage,
                        2,
                      );
                    } else {
                      final image = BlocProvider.of<OfflinePagesBloc>(context)
                          .state
                          .list[currentPage];

                      final res = await serviceLocator
                          .get<DownloadRepository>()
                          .offlineScreenshot(image);
                      if (res.isValue) {
                        context.showSnackBar(
                          Language.of(context).savedScreenshotToStorage,
                          2,
                        );
                      } else {
                        context.showSnackBar(
                          Language.of(context).someErrorOccurred,
                          2,
                        );
                      }
                    }
                  }
                  Navigator.of(context).pop();
                }),
                _spacer,
                _menuItem(
                    Language.of(context).share, 'assets/icons/share_icon.svg',
                    () async {
                  shareCallback();
                  Navigator.of(context).pop();
                }),
                _spacer,
                _menuItem(
                  Language.of(context).readingSettings,
                  'assets/icons/reading_mode_icon.svg',
                  () {
                    Navigator.of(context).pop();
                    showSettingsCallback();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _menuItem(String title, String icon, Function onClick) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Colors.white,
              width: 25,
              height: 25,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              strutStyle: AppFonts.getStyle(),
            )
          ],
        ),
      ),
    );
  }
}
