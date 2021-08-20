import 'package:manga_scraper/models/watched_chapter.dart';
import 'package:manga_scraper/repositories/manga_pages_repo.dart';
import 'package:manga_scraper/repositories/watched_chapters_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class MangaPagesBloc extends BaseBloc<MangaPagesState> {
  final _repo = serviceLocator.get<MangaPagesRepository>();
  final _watchedRepo = serviceLocator.get<WatchedChaptersRepository>();

  MangaPagesBloc() : super(LoadingMangaPages([]));
}

class LoadMangaPages extends BlocEvent<MangaPagesBloc, MangaPagesState> {
  final String slug;
  final String chapter;
  final String volume;

  LoadMangaPages(this.slug, this.chapter, this.volume);
  @override
  Stream<MangaPagesState> toState(
      MangaPagesBloc bloc, MangaPagesState current) async* {
    yield LoadingMangaPages(current.list);

    final res = await bloc._repo.load(slug, chapter, volume);
    if (res.isValue) {
      yield LoadedMangaPages(res.asValue);
      bloc._watchedRepo.save(WatchedChapter(slug: slug, number: chapter));
    } else {
      yield MangaPagesError(current.list, res.asError);
    }
  }
}

abstract class MangaPagesState {
  final List<String> list;

  MangaPagesState(this.list);
}

class LoadingMangaPages extends MangaPagesState {
  LoadingMangaPages(List<String> list) : super(list);
}

class MangaPagesError extends MangaPagesState {
  final ErrorType errorType;
  MangaPagesError(List<String> list, this.errorType) : super(list);
}

class LoadedMangaPages extends MangaPagesState {
  LoadedMangaPages(List<String> list) : super(list);
}
