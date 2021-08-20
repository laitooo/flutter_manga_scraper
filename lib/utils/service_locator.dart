import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manga_scraper/models/favourite.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/models/search_history.dart';
import 'package:manga_scraper/models/watched_chapter.dart';
import 'package:manga_scraper/repositories/download_repo.dart';
import 'package:manga_scraper/repositories/downloads_list_repo.dart';
import 'package:manga_scraper/repositories/favourites_repo.dart';
import 'package:manga_scraper/repositories/latest_chapters_repo.dart';
import 'package:manga_scraper/repositories/manga_details_repo.dart';
import 'package:manga_scraper/repositories/manga_list_repo.dart';
import 'package:manga_scraper/repositories/manga_pages_repo.dart';
import 'package:manga_scraper/repositories/most_viewed_repo.dart';
import 'package:manga_scraper/repositories/search_repo.dart';
import 'package:manga_scraper/repositories/search_history_repo.dart';
import 'package:manga_scraper/repositories/watched_chapters_repo.dart';
import 'package:manga_scraper/service/download_service.dart';
import 'package:manga_scraper/translation/global_locale.dart';
import 'package:manga_scraper/utils/dio.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/preferences.dart';

Future<void> setupServiceLocator() async {
  print('service locator setup started');
  await prefs.init();
  await lang.init();
  if (!Features.isMockHive) {
    final document = await getApplicationDocumentsDirectory();
    Hive
      ..init(document.path)
      ..registerAdapter(FavouriteAdapter())
      ..registerAdapter(SearchHistoryAdapter())
      ..registerAdapter(WatchedChapterAdapter());
  }
  serviceLocator.registerSingleton(MoorDatabase(openConnection()));
  serviceLocator.registerSingleton<MostViewedRepository>(
    Features.isMockHttp
        ? MockMostViewedRepository()
        : ScrapeMostViewedRepository(),
  );
  serviceLocator.registerSingleton<LatestChaptersRepository>(
    Features.isMockHttp
        ? MockLatestChaptersRepository()
        : ScrapeLatestChaptersRepository(),
  );
  serviceLocator.registerSingleton<MangaDetailsRepository>(
    Features.isMockHttp
        ? MockMangaDetailsRepository()
        : ScrapeMangaDetailsRepository(),
  );
  serviceLocator.registerSingleton<MangaPagesRepository>(
    Features.isMockHttp
        ? MockMangaPagesRepository()
        : HttpMangaPagesRepository(),
  );
  serviceLocator.registerSingleton<SearchRepository>(
    Features.isMockHttp ? MockSearchRepository() : HttpSearchRepository(),
  );
  serviceLocator.registerSingleton<FavouritesRepository>(
    Features.isMockHive
        ? MockFavouritesRepository()
        : HiveFavouritesRepository(),
  );
  serviceLocator.registerSingleton<SearchHistoryRepository>(
    Features.isMockHive
        ? MockSearchHistoryRepository()
        : HiveSearchHistoryRepository(),
  );
  serviceLocator.registerSingleton<DownloadRepository>(
    Features.isMockDio
        ? MockDownloadRepository()
        : DioDownloadRepository(DioFactory.withDefaultInterceptors()),
  );
  serviceLocator.registerSingleton<DownloadsListRepository>(
    Features.isMockMoor
        ? MockDownloadsListRepository()
        : MoorDownloadsListRepository(serviceLocator.get<MoorDatabase>()),
  );
  serviceLocator.registerSingleton<MangaListRepository>(
    Features.isMockHttp
        ? MockMangaListRepository()
        : ScrapeMangaListRepository(),
  );
  serviceLocator.registerSingleton<WatchedChaptersRepository>(
    Features.isMockHive
        ? MockWatchedChaptersRepository()
        : HiveWatchedChaptersRepository(),
  );
  print('service locator setup finished');
  print('download service started');
  await FlutterBackgroundService.initialize(onStart, foreground: false);
}

final serviceLocator = GetIt.instance;
