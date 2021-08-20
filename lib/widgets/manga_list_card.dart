import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:manga_scraper/models/manga_list.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/features.dart';

class MangaListCard extends StatelessWidget {
  final MangaListItem manga;
  final Function onClick;

  const MangaListCard({
    Key key,
    this.manga,
    this.onClick,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Image(
              image: Features.isMockHttp
                  ? AssetImage(manga.cover)
                  : NetworkImage(manga.cover),
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2),
                  Text(
                    manga.name,
                    style: TextStyle(
                      color: AppColors.getPrimaryColor(),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.english,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                  SizedBox(height: 5),
                  Text(
                    manga.categories.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        manga.rate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: AppFonts.english,
                        ),
                        strutStyle: AppFonts.getStyle(),
                      ),
                      SizedBox(width: 10),
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 12,
                        initialRating: double.parse(manga.rate) - 0.49,
                        minRating: 1,
                        direction: Axis.horizontal,
                        textDirection: Directionality.of(context),
                        allowHalfRating: true,
                        itemCount: 5,
                        onRatingUpdate: null,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: AppColors.getPrimaryColor(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        manga.views.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: AppFonts.english,
                        ),
                        strutStyle: AppFonts.getStyle(),
                      ),
                      SizedBox(width: 5),
                      SvgPicture.asset(
                        'assets/icons/views_icon.svg',
                        width: 12,
                        height: 12,
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: Language.of(context).latestChapters + ' : ',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: manga.lastChapter.number,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppFonts.english,
                          ),
                        )
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: AppFonts.getStyle(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /*String categoriesToString(List<Category> list) {
    String text = '';
    for (int i = 0; i < list.length; i++) {
      text += list[i].name + (i != list.length - 1 ? ' , ' : '');
    }
    return text;
  }*/
}
