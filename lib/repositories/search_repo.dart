import 'dart:convert' as convert;
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/models/search_result.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class SearchRepository {
  Future<OrError<SearchResultWithId, ErrorTypeWithId>> search({
    String name,
    String category,
    int type,
    int status,
    int id,
  });
}

class HttpSearchRepository extends SearchRepository {
  // TODO: api key
  // final _repo = serviceLocator.get<ApiKeyRepository>();
  @override
  Future<OrError<SearchResultWithId, ErrorTypeWithId>> search({
    String name,
    String category,
    int type,
    int status,
    int id,
  }) async {
    // https://onma.me/api/v3/advanced-search?API_key=1rdrYtOP0Ghgetyt65TY6
    // &name=one%20piece
    // &category=drama,action
    // &type=1
    // &status=1

    /*final data = await _repo.get();
    final parameters = Map<String, dynamic>();
    parameters.putIfAbsent('API_key', () => data.key);
    if (name != null && name.isNotEmpty) {
      parameters.putIfAbsent('name', () => name);
    }
    if (Features.isAdvanceSearch) {
      if (category != null && category.isNotEmpty)
        parameters.putIfAbsent('category', () => category);
      if (type != null && type != 0)
        parameters.putIfAbsent('type', () => type.toString());
      if (status != null && status != 0)
        parameters.putIfAbsent('status', () => status.toString());
    }
    var url = Uri.https(
      data.domain,
      data.path + Constants.advancedSearch,
      parameters,
    );*/

    final url = Uri.https(Constants.domain, Constants.mostViewed);

    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return OrError.error(ErrorTypeWithId(ErrorType.noInternet, id));
      }
      try {
        print('==============');
        var newUrl = url.toString().replaceAll('%2C', ',');
        newUrl = newUrl.toString().replaceAll('+%E2%80%8E', '%20');
        print('url:$newUrl');
        var response = await http.get(newUrl);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          final list = (jsonResponse['data'] as List)
              ?.map((manga) => SearchResult.fromJson(manga))
              ?.toList();
          return OrError.value(SearchResultWithId(list, id));
        } else {
          return OrError.error(ErrorTypeWithId(ErrorType.serverError, id));
        }
      } on SocketException catch (_) {
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
        id: index + 1,
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
        cover: generator.mangaCoverAsset(),
        lastChapter: Chapter(
            name: "الإنسان العاقل، وحيد كليًا",
            slug: (index + 1).toString(),
            number: (index + 1).toString(),
            url: ""),
        authors: [
          Author(
            id: generator.generateNumber(100),
            name: generator.mangaAuthor(),
          )
        ],
        categories: [
          "action",
          "adventure",
          "comedy",
        ],
      ),
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
