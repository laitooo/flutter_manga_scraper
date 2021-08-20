import 'package:flutter/cupertino.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:share/share.dart';

class ShareLink {
  void shareManga(String name, String slug, BuildContext context) async {
    await Share.share(Language.of(context).readManga +
        ' ' +
        name +
        ' ' +
        Language.of(context).usingThisLink +
        ':\n' +
        '${Constants.domain}/manga/$slug/');
  }

  void shareChapter(String name, String slug, String chapter, String volume,
      BuildContext context) async {
    await Share.share(Language.of(context).readChapter +
        ' ' +
        chapter +
        ' ' +
        Language.of(context).fromManga +
        ' ' +
        name +
        ' ' +
        Language.of(context).usingThisLink +
        ':\n' +
        '${Constants.domain}/manga/$slug/' +
        (volume == 'null' ? '' : '$volume/') +
        '$chapter/');
  }
}
