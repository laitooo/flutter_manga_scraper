import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/repositories/favourites_repo.dart';
import 'package:manga_scraper/repositories/manga_details_repo.dart';
import 'package:manga_scraper/repositories/watched_chapters_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class MangaDetailsBloc extends BaseBloc<MangaDetailsState> {
  final _repo = serviceLocator.get<MangaDetailsRepository>();
  final _favRepo = serviceLocator.get<FavouritesRepository>();
  final _watchedRepo = serviceLocator.get<WatchedChaptersRepository>();

  MangaDetailsBloc() : super(LoadingMangaDetails(null));
}

class LoadMangaDetails extends BlocEvent<MangaDetailsBloc, MangaDetailsState> {
  final String slug;

  LoadMangaDetails(this.slug);
  @override
  Stream<MangaDetailsState> toState(
      MangaDetailsBloc bloc, MangaDetailsState current) async* {
    yield LoadingMangaDetails(current.mangaDetail);

    final res = await bloc._repo.load(slug);

    if (res.isValue) {
      final details = res.asValue;
      details.isFav = await bloc._favRepo.isFav(details.slug);
      for (int i = 0; i < details.chapters.length; i++) {
        bool isWatched = await bloc._watchedRepo
            .hasWatched(details.slug, details.chapters[i].number);
        details.chapters[i].isWatched = isWatched;
      }
      yield LoadedMangaDetails(res.asValue);
    } else {
      yield MangaDetailsError(current.mangaDetail, res.asError);
    }
  }
}

abstract class MangaDetailsState {
  final MangaDetail mangaDetail;

  MangaDetailsState(this.mangaDetail);
}

class LoadingMangaDetails extends MangaDetailsState {
  LoadingMangaDetails(MangaDetail mangaDetail) : super(mangaDetail);
}

class LoadedMangaDetails extends MangaDetailsState {
  LoadedMangaDetails(MangaDetail mangaDetail) : super(mangaDetail);
}

class MangaDetailsError extends MangaDetailsState {
  final ErrorType errorType;
  MangaDetailsError(MangaDetail mangaDetail, this.errorType)
      : super(mangaDetail);
}
