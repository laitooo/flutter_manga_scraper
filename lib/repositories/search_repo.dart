import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:manga_scraper/models/search_result.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:web_scraper/web_scraper.dart';

abstract class SearchRepository {
  Future<OrError<SearchResultWithId, ErrorTypeWithId>> search({
    String name,
    String category,
    int type,
    int status,
    int id,
  });
}

class ScrapeSearchRepository extends SearchRepository {
  @override
  Future<OrError<SearchResultWithId, ErrorTypeWithId>> search({
    String name,
    String category,
    int type,
    int status,
    int id,
  }) async {
    String query;
    if (!Features.isAdvanceSearch) {
      query = (name == null ? '' : name);
    } else {
      query = (name == null ? '' : name) + category;
      switch (type) {
        case 1:
          query += '&type=manga';
          break;
        case 2:
          query += '&type=manhwa';
          break;
        case 3:
          query += '&type=manhua';
          break;
        case 0:
        default:
          query += '&type=';
          break;
      }

      switch (status) {
        case 1:
          query += '&is_completed=1';
          break;
        case 2:
          query += '&is_completed=0';
          break;
        default:
          query += '&is_completed=';
      }
    }
    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorTypeWithId(ErrorType.noInternet, id));
      }
      try {
        final webScraper = WebScraper(Constants.domain);
        if (await webScraper.loadWebPage(Constants.search + query)) {
          final a = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover', ['href', 'title']);
          final b = webScraper.getElement(
              'ul.manga_pic_list > li > a.manga_cover > img', ['src']);
          final f =
              webScraper.getElement('ul.manga_pic_list > li > p.view', []);
          final g =
              webScraper.getElement('ul.manga_pic_list > li > p.keyWord', []);

          final list = <SearchResult>[];
          for (int i = 0; i < a.length; i++) {
            list.add(SearchResult(
              author:
                  (f[i * 5]['title'] as String).replaceFirst('Author: ', ''),
              categories: (g[i]['title'] as String).split(','),
              url: Constants.domain + a[i]['attributes']['href'],
              name: a[i]['attributes']['title'],
              slug: (a[i]['attributes']['href'] as String).split('/')[2],
              cover: b[i]['attributes']['src'],
            ));
          }
          return OrError.value(SearchResultWithId(list, id));
        } else {
          return OrError.error(ErrorTypeWithId(ErrorType.serverError, id));
        }
      } on WebScraperException catch (e) {
        print(e.toString());
        return OrError.error(ErrorTypeWithId(ErrorType.networkError, id));
      }
    } on PlatformException catch (_) {
      return OrError.error(ErrorTypeWithId(ErrorType.platformError, id));
    }
  }
}

class MockSearchRepository extends SearchRepository {
  @override
  Future<OrError<SearchResultWithId, ErrorTypeWithId>> search(
      {String name, String category, int type, int status, int id}) async {
    final list = List.generate(
      10,
      (index) => SearchResult(
          slug: generator.mangaSlug(),
          name: generator.mangaName(),
          cover: generator.mangaCoverAsset(),
          categories: [
            "action",
            "adventure",
            "comedy",
          ],
          url: '',
          author: 'Some author'),
    );
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(SearchResultWithId(list, id)),
    );
  }
}

class SearchResultWithId {
  final List<SearchResult> list;
  final int id;

  SearchResultWithId(this.list, this.id);
}

class ErrorTypeWithId {
  final ErrorType errorType;
  final int id;

  ErrorTypeWithId(this.errorType, this.id);
}
