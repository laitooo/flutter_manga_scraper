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
        if (await webScraper
            .loadWebPage(Constants.latestChapters + page.toString())) {
          final ass = webScraper
              .getElement('div.list-truyen-item-wrap > a', ['href', 'title']);
          final covers = webScraper
              .getElement('div.list-truyen-item-wrap > a > img', ['src']);

          print('ass: ' + ass.toString());
          print('covers: ' + covers.toString());
          final list = <LatestChapter>[];
          for (int i = 0; i < covers.length; i++) {
            list.add(LatestChapter(
              url: ass[i * 2]['attributes']['href'],
              name: ass[i * 2]['attributes']['title'],
              slug: ass[i * 2]['attributes']['href'],
              cover: covers[i]['attributes']['src'],
              number: (ass[i * 2 + 1]['attributes']['href'] as String).split('/')
                  .last.substring(8),
            ));
          }
          return OrError.value(list);
        } else {
          return OrError.error(ErrorType.serverError);
        }
      } on WebScraperException catch (e) {
        print("Errrrrrrrror");
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
