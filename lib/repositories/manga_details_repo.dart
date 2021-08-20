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
        final webScraper = WebScraper(Constants.domain2);
        if (await webScraper.loadWebPage('/' + slug)) {
          final a = webScraper
              .getElement('div.story-info-left > span > img', ['src', 'title']);
          final b = webScraper
              .getElement('table.variations-tableInfo > tbody > tr > td', []);
          final c = webScraper
              .getElement('div.story-info-right-extent > p > em ', []);
          final d =
              webScraper.getElement('div.panel-story-info-description', []);
          final e = webScraper.getElement(
              'table.variations-tableInfo > tbody > tr > td > a', []);

          print('*******' * 15);
          print('url:' + Constants.domain2 + "/" + slug);
          print("a:" + a.toString());
          print("c:" + c.toString());
          final categories = <String>[];
          for (int i = 1; i < e.length; i++) {
            categories.add(e[i]['title']);
          }
          final details = MangaDetail(
              name: a.first['attributes']['title'],
              slug: slug,
              status: b[5]['title'],
              rate: c.first['title'],
              author: b[3]['title'],
              summary: d.first['title'],
              cover: a.first['attributes']['src'],
              categories: categories,
              chapters: [],
              isFav: false);
          return OrError.value(details);
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
