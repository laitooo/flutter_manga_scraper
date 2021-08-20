import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:web_scraper/web_scraper.dart';

abstract class MangaDetailsRepository {
  Future<OrError<MangaDetail, ErrorType>> load(String slug);
}

class ScrapeMangaDetailsRepository extends MangaDetailsRepository {
  @override
  Future<OrError<MangaDetail, ErrorType>> load(String slug) async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorType.noInternet);
      }
      try {
        final webScraper = WebScraper(Constants.domain);
        if (await webScraper.loadWebPage('/manga/$slug/')) {
          final a = webScraper.getElement('ul.chapter_list > li > a', ['href']);
          final b = webScraper
              .getElement('div.detail_content > div > ul > li > span', []);
          final c =
              webScraper.getElement('div.detail_content > div > ul > li', []);
          final d =
              webScraper.getElement('div.detail_content > div > img', ['src']);

          final name = webScraper.getElement('h1.title-top', []).first['title'];
          final chapters = <Chapter>[];
          for (int i = 1; i < a.length; i++) {
            final d = (a[i]['attributes']['href'] as String).split('/');
            chapters.add(Chapter(
              name: name,
              slug: slug,
              number: d[d.length == 5 ? 3 : 4].replaceAll('c', ''),
              volume: d.length == 5 ? 'null' : d[3].replaceAll('v', ''),
              url: Constants.domain + a[i]['attributes']['href'],
            ));
          }
          final details = MangaDetail(
              name: name,
              slug: slug,
              status: (c[7]['title'] as String).replaceFirst('Status(s):', ''),
              rate: '    ' + b.first['title'],
              author: (c[5]['title'] as String).replaceAll('Author(s):', ''),
              summary:
                  (webScraper.getElement('#show', []).first['title'] as String)
                      .replaceFirst('HIDE', ''),
              cover: d.first['attributes']['src'],
              categories: (c[4]['title'] as String)
                  .replaceFirst('Genre(s):', '')
                  .split(','),
              chapters: chapters,
              isFav: false);
          return OrError.value(details);
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

class MockMangaDetailsRepository extends MangaDetailsRepository {
  @override
  Future<OrError<MangaDetail, ErrorType>> load(String slug) async {
    final mangaDetail = MangaDetail(
      name: generator.mangaName(),
      slug: generator.mangaSlug(),
      status: '',
      rate: "4.38",
      author: "Inagaki Riichiro",
      summary: "كل البشر على كوكب الارض ... قد تحولوا إلى صخر أصم !!!",
      cover: generator.mangaCoverAsset(),
      categories: [
        "action",
        "adventure",
        "comedy",
      ],
      chapters: List.generate(
        generator.generateNumber(300),
        (index) => Chapter(
          name: "الإنسان العاقل، وحيد كليًا",
          slug: (index + 1).toString(),
          number: (index + 1).toString(),
          volume: (index + 1).toString(),
          url: "",
          isWatched: generator.generateBool(),
        ),
      ),
      isFav: generator.generateBool(),
    );
    return Future.delayed(
      Duration.zero,
      () => OrError.value(mangaDetail),
    );
  }
}
