import 'package:hive/hive.dart';
import 'package:manga_scraper/models/favourite.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';

abstract class FavouritesRepository {
  Future<OrError<List<Favourite>, Null>> load();
  Future<OrError<Null, Null>> save(Favourite favourite);
  Future<OrError<Null, Null>> delete(String slug);
  Future<bool> isFav(String slug);
}

class HiveFavouritesRepository extends FavouritesRepository {
  @override
  Future<OrError<List<Favourite>, Null>> load() async {
    var box = await Hive.openBox('favourites');
    final list = box.values.cast<Favourite>().toList();
    return OrError.value(list);
  }

  @override
  Future<OrError<Null, Null>> save(Favourite favourite) async {
    var box = await Hive.openBox('favourites');
    box.add(favourite);
    return OrError.value(null);
  }

  @override
  Future<OrError<Null, Null>> delete(String slug) async {
    var box = await Hive.openBox('favourites');
    final list = box.values.cast<Favourite>().toList();
    for (int i = 0; i < list.length; i++) {
      if (list[i].slug == slug) {
        box.deleteAt(i);
        break;
      }
    }
    return OrError.value(null);
  }

  @override
  Future<bool> isFav(String slug) async {
    var box = await Hive.openBox('favourites');
    final list = box.values.cast<Favourite>().toList();
    for (int i = 0; i < list.length; i++) {
      if (list[i].slug == slug) {
        return true;
      }
    }
    return false;
  }
}

class MockFavouritesRepository extends FavouritesRepository {
  @override
  Future<OrError<Null, Null>> delete(String slug) async {
    print('mock favourites: deleted manga with slug: $slug');
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Future<bool> isFav(String slug) async {
    return generator.generateBool();
  }

  @override
  Future<OrError<Null, Null>> save(Favourite favourite) async {
    print('mock favourites: saved manga with slug: ${favourite.slug}');
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Future<OrError<List<Favourite>, Null>> load() async {
    final list = List.generate(
      generator.generateNumber(10),
      (index) => Favourite(
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
        cover: generator.mangaCoverAsset(),
      ),
    );

    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }
}
