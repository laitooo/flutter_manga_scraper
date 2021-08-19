import 'dart:convert' as convert;
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

// TODO: api key
//import 'api_key_repo.dart';

abstract class MangaDetailsRepository {
  Future<OrError<MangaDetail, ErrorType>> load(String slug);
}

class HttpMangaDetailsRepository extends MangaDetailsRepository {
  //final _repo = serviceLocator.get<ApiKeyRepository>();

  @override
  Future<OrError<MangaDetail, ErrorType>> load(String slug) async {
    /*final data = await _repo.get();
    var url = Uri.https(
      data.domain,
      data.path + Constants.mangaInfo + '/$slug',
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
          final data = jsonResponse['data']['infoManga'][0];
          return OrError.value(MangaDetail.fromJson(data));
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

class MockMangaDetailsRepository extends MangaDetailsRepository {
  @override
  Future<OrError<MangaDetail, ErrorType>> load(String slug) async {
    final mangaDetail = MangaDetail(
      id: generator.generateNumber(1000),
      name: generator.mangaName(),
      slug: generator.mangaSlug(),
      status: generator.generateNumber(3),
      type: generator.generateNumber(3),
      rate: "4.38",
      author: "Inagaki Riichiro",
      releaseDate: (1980 + generator.generateNumber(40)).toString(),
      summary: "كل البشر على كوكب الارض ... قد تحولوا إلى صخر أصم !!!",
      cover: generator.mangaCoverAsset(),
      categories: [
        Category(id: 1, name: "أكشن", slug: "action"),
        Category(id: 2, name: "مغامرة", slug: "adventure"),
        Category(id: 3, name: "كوميدي", slug: "comedy")
      ],
      chapters: List.generate(
        generator.generateNumber(300),
        (index) => Chapter(
          id: generator.generateNumber(10000),
          name: "الإنسان العاقل، وحيد كليًا",
          slug: (index + 1).toString(),
          number: (index + 1).toString(),
          mangaId: generator.generateNumber(1000),
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
