import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/models/manga_list.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:web_scraper/web_scraper.dart';

abstract class MangaListRepository {
  Future<OrError<List<MangaListItem>, ErrorType>> load(
      String category, int page);
}

class ScrapeMangaListRepository extends MangaListRepository {
  @override
  Future<OrError<List<MangaListItem>, ErrorType>> load(
      String category, int page) async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorType.noInternet);
      }
      try {
        final webScraper = WebScraper(Constants.domain);
        if (await webScraper.loadWebPage(Constants.mangaLists +
            category +
            '-0-0-0-0/${page.toString()}.htm')) {
          final a = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover', ['href', 'title']);
          final b = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover > img', ['src']);
          final c =
              webScraper.getElement('ul.manga_pic_list > li > p.score > b', []);
          final d = webScraper.getElement(
              'ul.manga_pic_list > li > p.new_chapter > a', ['href']);
          final f =
              webScraper.getElement('ul.manga_pic_list > li > p.view', []);
          final g =
              webScraper.getElement('ul.manga_pic_list > li > p.keyWord', []);

          final list = <MangaListItem>[];
          for (int i = 0; i < a.length; i++) {
            final e = (d[i]['attributes']['href'] as String).split('/');
            list.add(MangaListItem(
              lastChapter: Chapter(
                url: Constants.domain + a[i]['attributes']['href'],
                name: a[i]['attributes']['title'],
                slug: (a[i]['attributes']['href'] as String).split('/')[2],
                number: e[e.length == 5 ? 3 : 4].replaceAll('c', ''),
                volume: e.length == 5 ? 'null' : e[3].replaceAll('v', ''),
              ),
              categories: (g[i]['title'] as String).split(','),
              views: int.parse((f[i * 5 + 2]['title'] as String)
                  .replaceFirst('Views: ', '')
                  .trim()),
              rate: c[i]['title'],
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

class MockMangaListRepository extends MangaListRepository {
  @override
  Future<OrError<List<MangaListItem>, ErrorType>> load(
      String category, int page) async {
    final list = List.generate(
      10,
      (index) => MangaListItem(
        url: '',
        cover: generator.mangaCoverAsset(),
        rate: (generator.generateNumber(500) / 100).toString(),
        views: generator.generateNumber(1000000),
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
        lastChapter: Chapter(
            name: "الإنسان العاقل، وحيد كليًا",
            slug: generator.generateNumber(1000).toString(),
            number: generator.generateNumber(1000).toString(),
            volume: generator.generateNumber(50).toString(),
            url: ""),
        categories: [
          "action",
          "adventure",
          "comedy",
        ],
      ),
    );
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
