import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/widgets/chapter_button.dart';

class ChaptersListDialog extends StatelessWidget {
  final String current;
  final List<Chapter> list;
  final Function(String chapter) reloadReader;

  const ChaptersListDialog(
      {Key key, this.list, this.reloadReader, this.current})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Container(
                  color: AppColors.getAccentColor(),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/close_icon.svg',
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Text(
                        Language.of(context).chaptersList,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        strutStyle: AppFonts.getStyle(),
                      ),
                      Container()
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.extent(
                    maxCrossAxisExtent: 60,
                    childAspectRatio: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    children: List.generate(
                      list.length,
                      (index) => ChapterButton(
                        chapter: list[index],
                        onClick: () {
                          Navigator.of(context).pop();
                          reloadReader(list[index].number);
                        },
                        isCurrent: current == list[index].number,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
