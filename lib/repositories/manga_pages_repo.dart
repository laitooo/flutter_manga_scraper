import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:connectivity/connectivity.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class MangaPagesRepository {
  Future<OrError<List<String>, ErrorType>> load(String slug, String chapter);
}

class HttpMangaPagesRepository extends MangaPagesRepository {
  // TODO: api key
  // final _repo = serviceLocator.get<ApiKeyRepository>();
  @override
  Future<OrError<List<String>, ErrorType>> load(
      String slug, String chapter) async {
    /*final data = await _repo.get();
    var url = Uri.https(
      data.domain,
      data.path + Constants.readChapter + '/$slug/$chapter',
      {'API_key': data.key},
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
          final List<String> list = List.from(jsonResponse['pages_url']);
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

class MockMangaPagesRepository extends MangaPagesRepository {
  @override
  Future<OrError<List<String>, ErrorType>> load(
      String slug, String chapter) async {
    final list = List.generate(
        generator.generateNumber(50), (index) => generator.mangaAsset());
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
