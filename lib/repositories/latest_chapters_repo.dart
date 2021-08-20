import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:manga_scraper/models/latest_chapter.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:web_scraper/web_scraper.dart';

abstract class LatestChaptersRepository {
  Future<OrError<List<LatestChapter>, ErrorType>> load(int page);
}

class ScrapeLatestChaptersRepository extends LatestChaptersRepository {
  @override
  Future<OrError<List<LatestChapter>, ErrorType>> load(int page) async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorType.noInternet);
      }
      try {
        final webScraper = WebScraper(Constants.domain);
        if (await webScraper.loadWebPage(
            Constants.latestChapters + '/${page.toString()}.htm')) {
          final a = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover', ['href', 'title']);
          final b = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover > img', ['src']);
          final c = webScraper.getElement(
              'ul.manga_pic_list > li > p.new_chapter > a', ['href']);

          final list = <LatestChapter>[];
          for (int i = 0; i < a.length; i++) {
            final d = (c[i]['attributes']['href'] as String).split('/');
            list.add(LatestChapter(
              url: Constants.domain + a[i]['attributes']['href'],
              name: a[i]['attributes']['title'],
              slug: (a[i]['attributes']['href'] as String).split('/')[2],
              cover: b[i]['attributes']['src'],
              number: d[d.length == 5 ? 3 : 4].replaceAll('c', ''),
              volume: d.length == 5 ? 'null' : d[3].replaceAll('v', ''),
            ));
          }
          return OrError.value(list);
        } else {
          return OrError.error(ErrorType.serverError);
        }
      } on WebScraperException catch (e) {
        print(e.toString());
        return OrError.error(ErrorType.networkError);
      }
    } on PlatformException catch (_) {
      return OrError.error(ErrorType.platformError);
    }
  }
}

class MockLatestChaptersRepository extends LatestChaptersRepository {
  @override
  Future<OrError<List<LatestChapter>, ErrorType>> load(int page) async {
    final list = List.generate(
      10,
      (index) => LatestChapter(
        cover: generator.mangaCoverAsset(),
        number: generator.generateNumber(300).toString(),
        volume: generator.generateNumber(50).toString(),
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
        url: '',
      ),
    );
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
