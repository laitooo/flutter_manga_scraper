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
          final ass = webScraper
              .getElement('div.list-truyen-item-wrap > a', ['href', 'title']);
          print('ass: ' + ass.toString());
          /*var jsonResponse = convert.jsonDecode(response.body);
          final list = (jsonResponse['results'] as List)
              ?.map((manga) => Manga.fromJson(manga['data']))
              ?.toList();*/
          return OrError.value([]);
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

class MockMostViewedRepository extends MostViewedRepository {
  @override
  Future<OrError<List<Manga>, ErrorType>> load() async {
    final list = List.generate(
      10,
      (index) => Manga(
        id: index + 1,
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
        cover: generator.mangaCoverAsset(),
        rate: generator.mangaRate(),
      ),
    );

    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
