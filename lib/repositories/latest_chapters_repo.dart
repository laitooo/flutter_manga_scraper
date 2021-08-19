import 'dart:convert' as convert;
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:manga_scraper/models/latest_chapter.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class LatestChaptersRepository {
  Future<OrError<List<LatestChapter>, ErrorType>> load(int page);
}

class HttpLatestChaptersRepository extends LatestChaptersRepository {
  // TODO: api key
  //final _repo = serviceLocator.get<ApiKeyRepository>();
  @override
  Future<OrError<List<LatestChapter>, ErrorType>> load(int page) async {
    /*final data = await _repo.get();
    var url = Uri.https(
      data.domain,
      data.path + Constants.latestChapter,
      {
        'API_key': data.key,
        'page': page.toString(),
      },
    );*/

    final url = Uri.https(Constants.domain, Constants.manga);

    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorType.noInternet);
      }
      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          final list = (jsonResponse['results'] as List)
              ?.map((manga) => LatestChapter.fromJson(manga['data']))
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

class MockLatestChaptersRepository extends LatestChaptersRepository {
  @override
  Future<OrError<List<LatestChapter>, ErrorType>> load(int page) async {
    final list = List.generate(
      10,
      (index) => LatestChapter(
        id: index + 1,
        cover: generator.mangaCoverAsset(),
        number: generator.generateNumber(300).toString(),
        date: "قبل " + generator.generateNumber(7).toString() + " أيام",
        manga: MangaInfo(
          slug: generator.mangaSlug(),
          name: generator.mangaName(),
        ),
      ),
    );
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
