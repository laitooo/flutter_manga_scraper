import 'package:manga_scraper/models/manga.dart';
import 'package:manga_scraper/repositories/favourites_repo.dart';
import 'package:manga_scraper/repositories/most_viewed_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class MostViewedBloc extends BaseBloc<MostViewedState> {
  final _repo = serviceLocator.get<MostViewedRepository>();
  final _favRepo = serviceLocator.get<FavouritesRepository>();

  MostViewedBloc() : super(LoadingMostViewed([]));
}

class LoadMostViewed extends BlocEvent<MostViewedBloc, MostViewedState> {
  @override
  Stream<MostViewedState> toState(
      MostViewedBloc bloc, MostViewedState current) async* {
    yield LoadingMostViewed(current.list);

    final res = await bloc._repo.load();

    if (res.isValue) {
      final list = res.asValue;
      for (int i = 0; i < list.length; i++) {
        list[i].isFav = await bloc._favRepo.isFav(list[i].slug);
      }
      yield LoadedMostViewed(list);
    } else {
      yield MostViewedError(current.list, res.asError);
    }
  }
}

abstract class MostViewedState {
  final List<Manga> list;

  MostViewedState(this.list);
}

class LoadingMostViewed extends MostViewedState {
  LoadingMostViewed(List<Manga> list) : super(list);
}

class MostViewedError extends MostViewedState {
  final ErrorType errorType;
  MostViewedError(List<Manga> list, this.errorType) : super(list);
}

class LoadedMostViewed extends MostViewedState {
  LoadedMostViewed(List<Manga> list) : super(list);
}
