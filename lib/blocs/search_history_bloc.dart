import 'package:manga_scraper/models/search_history.dart';
import 'package:manga_scraper/repositories/search_history_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class SearchHistoryBloc extends BaseBloc<SearchHistoryState> {
  final _repo = serviceLocator.get<SearchHistoryRepository>();

  SearchHistoryBloc() : super(LoadingSearchHistory([]));
}

class SaveSearchHistory
    extends BlocEvent<SearchHistoryBloc, SearchHistoryState> {
  final SearchHistory searchHistory;

  SaveSearchHistory(this.searchHistory);
  @override
  Stream<SearchHistoryState> toState(
      SearchHistoryBloc bloc, SearchHistoryState current) async* {
    yield SavingSearchHistory(current.list);

    final result = await bloc._repo.save(searchHistory);
    if (result.isError) {
      yield SearchHistoryError(current.list);
    } else {
      yield LoadedSearchHistory(current.list..add(searchHistory));
    }
  }
}

class ClearSearchHistory
    extends BlocEvent<SearchHistoryBloc, SearchHistoryState> {
  @override
  Stream<SearchHistoryState> toState(
      SearchHistoryBloc bloc, SearchHistoryState current) async* {
    yield DeletingSearchHistory(current.list);

    final result = await bloc._repo.clear();
    if (result.isError) {
      yield SearchHistoryError(current.list);
    } else {
      yield LoadedSearchHistory([]);
    }
  }
}

class LoadSearchHistory
    extends BlocEvent<SearchHistoryBloc, SearchHistoryState> {
  @override
  Stream<SearchHistoryState> toState(
      SearchHistoryBloc bloc, SearchHistoryState current) async* {
    yield LoadingSearchHistory(current.list);

    final result = await bloc._repo.load();
    yield result.incase(value: (value) {
      return LoadedSearchHistory(value);
    }, error: (error) {
      return SearchHistoryError(current.list);
    });
  }
}

abstract class SearchHistoryState {
  final List<SearchHistory> list;

  SearchHistoryState(this.list);
}

class LoadingSearchHistory extends SearchHistoryState {
  LoadingSearchHistory(List<SearchHistory> list) : super(list);
}

class SavingSearchHistory extends SearchHistoryState {
  SavingSearchHistory(List<SearchHistory> list) : super(list);
}

class DeletingSearchHistory extends SearchHistoryState {
  DeletingSearchHistory(List<SearchHistory> list) : super(list);
}

class LoadedSearchHistory extends SearchHistoryState {
  LoadedSearchHistory(List<SearchHistory> list) : super(list);
}

class SearchHistoryError extends SearchHistoryState {
  SearchHistoryError(List<SearchHistory> list) : super(list);
}
