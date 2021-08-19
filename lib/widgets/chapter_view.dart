import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_scraper/models/latest_chapter.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/utils/features.dart';

class ChapterView extends StatelessWidget {
  final LatestChapter latestChapter;
  final Function onClick;
  final Function onChapterClick;

  const ChapterView(
      {Key key, this.latestChapter, this.onClick, this.onChapterClick})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClick,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: Features.isMockHttp
                        ? AssetImage(latestChapter.cover)
                        : NetworkImage(latestChapter.cover),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onClick,
                  child: Text(
                    latestChapter.manga.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.getPrimaryColor(),
                      fontFamily: AppFonts.english,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: onChapterClick,
                  child: Container(
                    width: 50,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.getPrimaryColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        latestChapter.number,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: AppFonts.english,
                        ),
                        strutStyle: AppFonts.getStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Text(
            latestChapter.date,
            style: TextStyle(
              color: AppColors.getPrimaryColor(),
              fontFamily: AppFonts.arabic,
            ),
            strutStyle: AppFonts.getStyle(),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
