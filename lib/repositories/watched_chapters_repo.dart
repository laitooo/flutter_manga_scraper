import 'package:hive/hive.dart';
import 'package:manga_scraper/models/watched_chapter.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class WatchedChaptersRepository {
  Future<OrError<Null, Null>> save(WatchedChapter chapter);
  Future<bool> hasWatched(String slug, String number);
}

class HiveWatchedChaptersRepository extends WatchedChaptersRepository {
  @override
  Future<OrError<Null, Null>> save(WatchedChapter chapter) async {
    if (!await hasWatched(chapter.slug, chapter.number)) {
      var box = await Hive.openBox('watched_chapters');
      box.add(chapter);
    }
    return OrError.value(null);
  }

  @override
  Future<bool> hasWatched(String slug, String number) async {
    var box = await Hive.openBox('watched_chapters');
    final list = box.values.cast<WatchedChapter>().toList();
    for (int i = 0; i < list.length; i++) {
      if (list[i].slug == slug && list[i].number == number) {
        return true;
      }
    }
    return false;
  }
}

class MockWatchedChaptersRepository extends WatchedChaptersRepository {
  @override
  Future<bool> hasWatched(String slug, String number) async {
    return generator.generateBool();
  }

  @override
  Future<OrError<Null, Null>> save(WatchedChapter chapter) async {
    print('mock watched chapter: saved manga with slug: ${chapter.slug} '
        'and chapter: ${chapter.number}');
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }
}
