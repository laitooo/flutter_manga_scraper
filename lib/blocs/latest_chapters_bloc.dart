import 'package:manga_scraper/models/latest_chapter.dart';
import 'package:manga_scraper/repositories/latest_chapters_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class LatestChaptersBloc extends BaseBloc<LatestChaptersState> {
  final _repo = serviceLocator.get<LatestChaptersRepository>();

  LatestChaptersBloc() : super(LoadingLatestChapters([], 1));
}

class LoadLatestChapters
    extends BlocEvent<LatestChaptersBloc, LatestChaptersState> {
  @override
  Stream<LatestChaptersState> toState(
      LatestChaptersBloc bloc, LatestChaptersState current) async* {
    yield LoadingLatestChapters(current.list, current.page);

    final res = await bloc._repo.load(current.page);

    yield res.incase(value: (value) {
      if (value.isEmpty) {
        return LatestChaptersEnded(current.list, current.page);
      } else {
        return LoadedLatestChapters(
            value..insertAll(0, current.list), current.page + 1);
      }
    }, error: (error) {
      return LatestChaptersError(current.list, current.page, error);
    });
  }
}

abstract class LatestChaptersState {
  final List<LatestChapter> list;
  final int page;

  LatestChaptersState(this.list, this.page);
}

class LoadingLatestChapters extends LatestChaptersState {
  LoadingLatestChapters(List<LatestChapter> list, int page) : super(list, page);
}

class LatestChaptersEnded extends LatestChaptersState {
  LatestChaptersEnded(List<LatestChapter> list, int page) : super(list, page);
}

class LatestChaptersError extends LatestChaptersState {
  final ErrorType errorType;
  LatestChaptersError(List<LatestChapter> list, int page, this.errorType)
      : super(list, page);
}

class LoadedLatestChapters extends LatestChaptersState {
  LoadedLatestChapters(List<LatestChapter> list, int page) : super(list, page);
}
