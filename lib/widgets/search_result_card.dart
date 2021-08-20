import 'package:flutter/material.dart';
import 'package:manga_scraper/models/search_result.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/features.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult searchResult;
  final Function onClick;
  final String searchText;

  const SearchResultCard({this.searchResult, this.onClick, this.searchText});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 110,
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
                  ? AssetImage(searchResult.cover)
                  : NetworkImage(searchResult.cover),
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: searchText == null
                          ? _getNormalSearchText(searchResult.name)
                          : _getSearchText(searchResult.name, searchText),
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                  SizedBox(height: 5),
                  Text(
                    Language.of(context).author +
                        ' : ' +
                        searchResult.authors[0].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppFonts.english,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                  Text(
                    searchResult.categories.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
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
                          text: searchResult.lastChapter.number,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppFonts.english,
                          ),
                        ),
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

  List<TextSpan> _getNormalSearchText(String name) {
    return <TextSpan>[
      TextSpan(
        text: name,
        style: TextStyle(
          color: AppColors.getPrimaryColor(),
          fontSize: 16,
          fontFamily: AppFonts.english,
        ),
      )
    ];
  }

  List<TextSpan> _getSearchText(String name, String text) {
    String name2 = name.toLowerCase();
    String text2 = text.toLowerCase();
    if (text2.runes.last == 8206) {
      text2 = text2.substring(0, text2.length - 1);
    }
    if (name == null || text2.isEmpty) return [];

    if (name2.contains(text2)) {
      List<TextSpan> _children = [];
      String preUsernameMessage =
          name.substring(0, name2.indexOf(text2)).trimLeft();
      if (preUsernameMessage != null && preUsernameMessage.isNotEmpty)
        _children
            .add(TextSpan(children: _getSearchText(preUsernameMessage, text)));
      _children.add(TextSpan(
        text: text2,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 16,
          fontFamily: AppFonts.english,
        ),
      ));

      String postUsernameMessage = name
          .substring(name2.indexOf(text2) + text2.length, name2.length)
          .trimRight();
      if (postUsernameMessage != null && postUsernameMessage.isNotEmpty)
        _children
            .add(TextSpan(children: _getSearchText(postUsernameMessage, text)));

      return _children;
    } else {
      if (text2.runes.last == 32) {
        List<TextSpan> _children = [];
        _children.add(TextSpan(
            children:
                _getSearchText(name, text2.substring(0, text2.length - 1))));
        return _children;
      }
    }
    return [
      TextSpan(
        text: name,
        style: TextStyle(
          color: AppColors.getPrimaryColor(),
          fontSize: 16,
          fontFamily: AppFonts.english,
        ),
      )
    ];
  }
}
