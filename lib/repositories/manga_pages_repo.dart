import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:web_scraper/web_scraper.dart';

abstract class MangaPagesRepository {
  Future<OrError<List<String>, ErrorType>> load(
      String slug, String chapter, String volume);
}

class ScrapeMangaPagesRepository extends MangaPagesRepository {
  @override
  Future<OrError<List<String>, ErrorType>> load(
      String slug, String chapter, String volume) async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorType.noInternet);
      }
      try {
        final webScraper = WebScraper(Constants.domain);
        if (await webScraper.loadWebPage(Constants.reader +
            slug +
            '/' +
            (volume == 'null' ? '' : 'v$volume/') +
            'c$chapter/')) {
          final a = webScraper.getElement('#viewer > a > img', ['src']);
          final b =
              webScraper.getElement('div.page_select > select > option', []);

          final first = 'https:' + a.first['attributes']['src'];
          final list = [first];
          for (int i = 1; i < (b.length / 2) - 2; i++) {
            final e = first.contains('000.jpg');
            final c = '0${(e ? i : i + 1).toString()}';
            final d = c.length == 2 ? '0$c' : c;
            if (e)
              list.add(first.replaceFirst('000.jpg', '$d.jpg'));
            else
              list.add(first.replaceFirst('001.jpg', '$d.jpg'));
          }
          print(list);

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

class MockMangaPagesRepository extends MangaPagesRepository {
  @override
  Future<OrError<List<String>, ErrorType>> load(
      String slug, String chapter, String volume) async {
    final list = List.generate(
        generator.generateNumber(50), (index) => generator.mangaAsset());
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
