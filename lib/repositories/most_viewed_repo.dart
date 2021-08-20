import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:manga_scraper/models/manga.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:web_scraper/web_scraper.dart';

abstract class MostViewedRepository {
  Future<OrError<List<Manga>, ErrorType>> load();
}

class ScrapeMostViewedRepository extends MostViewedRepository {
  @override
  Future<OrError<List<Manga>, ErrorType>> load() async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorType.noInternet);
      }
      try {
        final webScraper = WebScraper(Constants.domain);
        if (await webScraper.loadWebPage(Constants.mostViewed)) {
          final a = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover', ['href', 'title']);
          final b = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover > img', ['src']);

          final list = <Manga>[];
          for (int i = 0; i < a.length; i++) {
            list.add(Manga(
              url: Constants.domain + a[i]['attributes']['href'],
              name: a[i]['attributes']['title'],
              slug: (a[i]['attributes']['href'] as String).split('/')[2],
              cover: b[i]['attributes']['src'],
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

class MockMostViewedRepository extends MostViewedRepository {
  @override
  Future<OrError<List<Manga>, ErrorType>> load() async {
    final list = List.generate(
      10,
      (index) => Manga(
        url: '',
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
        cover: generator.mangaCoverAsset(),
      ),
    );

    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
