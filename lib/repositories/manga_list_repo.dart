import 'dart:convert' as convert;
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/models/manga_list.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class MangaListRepository {
  Future<OrError<List<MangaListItem>, ErrorType>> load(
      String category, int page);
}

class HttpMangaListRepository extends MangaListRepository {
  // TODO: api key
  // final _repo = serviceLocator.get<ApiKeyRepository>();
  @override
  Future<OrError<List<MangaListItem>, ErrorType>> load(
      String category, int page) async {
    /*final data = await _repo.get();
    var url = Uri.https(
      data.domain,
      data.path + Constants.mangaList + '/$category',
      {'API_key': data.key, 'page': page.toString()},
    );*/

    final url = Uri.https(Constants.domain, Constants.mostViewed);

    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorType.noInternet);
      }
      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          final list = (jsonResponse['data']['CategoryManga']['data'] as List)
              ?.map((manga) => MangaListItem.fromJson(manga))
              ?.toList();
          return OrError.value(list);
        } else {
          return OrError.error(ErrorType.serverError);
        }
      } on SocketException catch (_) {
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
        id: index + 1,
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
