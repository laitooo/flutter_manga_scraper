import 'dart:convert' as convert;
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:manga_scraper/models/manga.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class MostViewedRepository {
  Future<OrError<List<Manga>, ErrorType>> load();
}

class HttpMostViewedRepository extends MostViewedRepository {
  // TODO: api key
  // final _repo = serviceLocator.get<ApiKeyRepository>();
  @override
  Future<OrError<List<Manga>, ErrorType>> load() async {
    /*final data = await _repo.get();
    var url = Uri.https(
      data.domain,
      data.path + Constants.popularManga,
      {'API_key': data.key},
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
              ?.map((manga) => Manga.fromJson(manga['data']))
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
