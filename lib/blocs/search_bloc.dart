import 'package:manga_scraper/models/search_result.dart';
import 'package:manga_scraper/repositories/search_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:rxdart/rxdart.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class SearchBloc extends BaseBloc<SearchState> {
  final _repo = serviceLocator.get<SearchRepository>();
  int currentRequest = 0;

  SearchBloc() : super(NoSearch([]));

  @override
  transformEvents(events, transformFn) {
    return super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 700)), transformFn);
  }
}

class StartSearch extends BlocEvent<SearchBloc, SearchState> {
  final String name;
  final String category;
  final int type;
  final int status;

  StartSearch({this.name, this.category, this.type, this.status});
  @override
  Stream<SearchState> toState(SearchBloc bloc, SearchState current) async* {
    yield StartedSearching([]);
    bloc.currentRequest++;
    final result = await bloc._repo.search(
      name: name,
      category: category,
      type: type,
      status: status,
      id: bloc.currentRequest,
    );

    if (result.isValue) {
      if (result.asValue.id == bloc.currentRequest) {
        yield SearchSuccess(result.asValue.list, name);
      }
    } else {
      if (result.asError.id == bloc.currentRequest) {
        yield SearchError([], result.asError.errorType);
      }
    }
  }
}

class VoiceSearch extends BlocEvent<SearchBloc, SearchState> {
  final String name;

  VoiceSearch({this.name});
  @override
  Stream<SearchState> toState(SearchBloc bloc, SearchState current) async* {
    if (name.isNotEmpty) {
      yield StartedSearching([]);

      bloc.currentRequest++;
      final result = await bloc._repo.search(
        name: name,
        id: bloc.currentRequest,
      );

      if (result.isValue) {
        if (result.asValue.id == bloc.currentRequest) {
          yield SearchSuccess(result.asValue.list, name);
        }
      } else {
        if (result.asError.id == bloc.currentRequest) {
          yield SearchError([], result.asError.errorType);
        }
      }
    } else {
      yield NoSearch([]);
    }
  }
}

class CancelSearch extends BlocEvent<SearchBloc, SearchState> {
  @override
  Stream<SearchState> toState(SearchBloc bloc, SearchState current) async* {
    yield NoSearch([]);
  }
}

abstract class SearchState {
  final List<SearchResult> list;

  SearchState(this.list);
}

class NoSearch extends SearchState {
  NoSearch(List<SearchResult> list) : super(list);
}

class StartedSearching extends SearchState {
  StartedSearching(List<SearchResult> list) : super(list);
}

class SearchSuccess extends SearchState {
  final String searchText;
  SearchSuccess(List<SearchResult> list, this.searchText) : super(list);
}

class SearchError extends SearchState {
  final ErrorType errorType;
  SearchError(List<SearchResult> list, this.errorType) : super(list);
}
