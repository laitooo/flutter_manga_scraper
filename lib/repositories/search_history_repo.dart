import 'package:hive/hive.dart';
import 'package:manga_scraper/models/search_history.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class SearchHistoryRepository {
  Future<OrError<List<SearchHistory>, Null>> load();
  Future<OrError<Null, Null>> save(SearchHistory searchHistory);
  Future<OrError<Null, Null>> clear();
}

class HiveSearchHistoryRepository extends SearchHistoryRepository {
  @override
  Future<OrError<List<SearchHistory>, Null>> load() async {
    var box = await Hive.openBox('search_history');
    final list = box.values.cast<SearchHistory>().toList();
    return OrError.value(list);
  }

  @override
  Future<OrError<Null, Null>> save(SearchHistory searchHistory) async {
    var box = await Hive.openBox('search_history');
    box.add(searchHistory);
    return OrError.value(null);
  }

  @override
  Future<OrError<Null, Null>> clear() async {
    var box = await Hive.openBox('search_history');
    await box.clear();
    return OrError.value(null);
  }
}

class MockSearchHistoryRepository extends SearchHistoryRepository {
  @override
  Future<OrError<Null, Null>> clear() async {
    print('mock search history: cleared search history');
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Future<OrError<Null, Null>> save(SearchHistory searchHistory) async {
    print('mock search history: saved manga with slug: ${searchHistory.slug}');
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Future<OrError<List<SearchHistory>, Null>> load() async {
    final list = List.generate(
      generator.generateNumber(5),
      (index) => SearchHistory(
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
      ),
    );

    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
