import 'package:manga_scraper/models/manga_list.dart';
import 'package:manga_scraper/repositories/manga_list_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class MangaListBloc extends BaseBloc<MangaListState> {
  final _repo = serviceLocator.get<MangaListRepository>();
  MangaListBloc() : super(LoadingMangaList([], 1));
}

class LoadMangaList extends BlocEvent<MangaListBloc, MangaListState> {
  final String category;

  LoadMangaList(this.category);
  @override
  Stream<MangaListState> toState(
      MangaListBloc bloc, MangaListState current) async* {
    yield LoadingMangaList(current.list, current.page);

    // these 2 types returns network erro so they are handled here till they
    // are fixed in the server side
    // hentai category
    if (category == 'hentai') {
      yield await Future.delayed(Duration(seconds: 1), () {
        return MangaListEnded(current.list, current.page);
      });
    } else {
      final result = await bloc._repo.load(category, current.page);

      yield result.incase(value: (value) {
        if (value.isEmpty) {
          return MangaListEnded(current.list, current.page);
        } else {
          return LoadedMangaList(
              value..insertAll(0, current.list), current.page + 1);
        }
      }, error: (error) {
        return MangaListError(current.list, current.page, error);
      });
    }
  }
}

abstract class MangaListState {
  final List<MangaListItem> list;
  final int page;

  MangaListState(this.list, this.page);
}

class LoadingMangaList extends MangaListState {
  LoadingMangaList(List<MangaListItem> list, int page) : super(list, page);
}

class LoadedMangaList extends MangaListState {
  LoadedMangaList(List<MangaListItem> list, int page) : super(list, page);
}

class MangaListError extends MangaListState {
  final ErrorType errorType;
  MangaListError(List<MangaListItem> list, int page, this.errorType)
      : super(list, page);
}

class MangaListEnded extends MangaListState {
  MangaListEnded(List<MangaListItem> list, int page) : super(list, page);
}
