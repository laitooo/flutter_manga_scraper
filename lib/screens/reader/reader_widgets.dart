import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/blocs/manga_details_bloc.dart';
import 'package:manga_scraper/blocs/manga_pages_bloc.dart';
import 'package:manga_scraper/screens/reader/download_dialog.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/widgets/auto_rotate.dart';

class BottomBarWidget extends StatelessWidget {
  final bool isBottomVisible;
  final bool isOffline;
  final int numPages;
  final int currentPage;
  final Function goToPreviousChapter;
  final Function goToNextChapter;
  final Function goToPreviousPage;
  final Function goToNextPage;

  const BottomBarWidget(
      {Key key,
      this.isBottomVisible,
      this.numPages,
      this.currentPage,
      this.goToPreviousChapter,
      this.goToNextChapter,
      this.goToPreviousPage,
      this.goToNextPage,
      this.isOffline})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isBottomVisible,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        color: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: isOffline
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            if (!isOffline)
              IconButton(
                onPressed: goToPreviousChapter,
                icon: AutoRotate(
                  child: SvgPicture.asset(
                    'assets/icons/previous_chapter_icon.svg',
                    color: Colors.white,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            Row(
              children: [
                AutoRotate(
                  child: IconButton(
                    onPressed: goToPreviousPage,
                    icon: SvgPicture.asset(
                      'assets/icons/previous_page_icon.svg',
                      color: Colors.white,
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    numPages == 0 ? '' : '${currentPage + 1}/$numPages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: AppFonts.english,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                ),
                SizedBox(width: 10),
                AutoRotate(
                  child: IconButton(
                    onPressed: goToNextPage,
                    icon: SvgPicture.asset(
                      'assets/icons/next_page_icon.svg',
                      color: Colors.white,
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
              ],
            ),
            if (!isOffline)
              IconButton(
                onPressed: goToNextChapter,
                icon: AutoRotate(
                  child: SvgPicture.asset(
                    'assets/icons/next_chapter_icon.svg',
                    color: Colors.white,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TobBarWidget extends StatelessWidget {
  final bool isTopVisible;
  final bool isOffline;
  final String slug;
  final String chapter;
  final String volume;
  final Function showMenuCallback;
  final Function showChaptersCallback;

  const TobBarWidget({
    Key key,
    this.isTopVisible,
    this.slug,
    this.chapter,
    this.volume,
    this.showMenuCallback,
    this.showChaptersCallback,
    this.isOffline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isTopVisible,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: showMenuCallback,
                  icon: SvgPicture.asset(
                    'assets/icons/menu_icon.svg',
                    color: Colors.white,
                    width: 25,
                    height: 25,
                  ),
                ),
                if (!isOffline)
                  IconButton(
                    onPressed: showChaptersCallback,
                    icon: SvgPicture.asset(
                      'assets/icons/list_icon.svg',
                      color: Colors.white,
                      width: 25,
                      height: 25,
                    ),
                  ),
              ],
            ),
            Text(
              chapter,
              style: TextStyle(color: Colors.white, fontSize: 20),
              strutStyle: AppFonts.getStyle(),
            ),
            isOffline
                ? SizedBox(width: 25)
                : IconButton(
                    onPressed: () {
                      final mangaDetails =
                          BlocProvider.of<MangaDetailsBloc>(context)
                              .state
                              .mangaDetail;
                      final images =
                          BlocProvider.of<MangaPagesBloc>(context).state.list;

                      showDialog(
                        context: context,
                        builder: (context) => DownloadDialog(
                          number: chapter,
                          mangaDetail: mangaDetails,
                          images: images.length,
                          firstImage: images.first,
                          volume: volume,
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/download_icon.svg',
                      color: Colors.white,
                      width: 25,
                      height: 25,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
