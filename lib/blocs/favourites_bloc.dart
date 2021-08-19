import 'package:manga_scraper/models/favourite.dart';
import 'package:manga_scraper/repositories/favourites_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class FavouritesBloc extends BaseBloc<FavouriteState> {
  final _repo = serviceLocator.get<FavouritesRepository>();

  FavouritesBloc() : super(LoadingFavourites([]));
}

class SaveFavourite extends BlocEvent<FavouritesBloc, FavouriteState> {
  final Favourite favourite;

  SaveFavourite(this.favourite);
  @override
  Stream<FavouriteState> toState(
      FavouritesBloc bloc, FavouriteState current) async* {
    yield SavingFavourite(current.list);

    final result = await bloc._repo.save(favourite);
    if (result.isError) {
      yield FavouritesError(current.list);
    } else {
      yield LoadedFavourites(current.list..add(favourite));
    }
  }
}

class DeleteFavourite extends BlocEvent<FavouritesBloc, FavouriteState> {
  final String slug;

  DeleteFavourite(this.slug);
  @override
  Stream<FavouriteState> toState(
      FavouritesBloc bloc, FavouriteState current) async* {
    yield DeletingFavourite(current.list);

    final result = await bloc._repo.delete(slug);
    if (result.isError) {
      yield FavouritesError(current.list);
    } else {
      for (int i = 0; i < current.list.length; i++) {
        if (current.list[i].slug == slug) {
          current.list.removeAt(i);
          break;
        }
      }
      yield LoadedFavourites(current.list);
    }
  }
}

class LoadFavourites extends BlocEvent<FavouritesBloc, FavouriteState> {
  @override
  Stream<FavouriteState> toState(
      FavouritesBloc bloc, FavouriteState current) async* {
    yield LoadingFavourites(current.list);

    final result = await bloc._repo.load();
    yield result.incase(value: (value) {
      return LoadedFavourites(value);
    }, error: (error) {
      return FavouritesError(current.list);
    });
  }
}

abstract class FavouriteState {
  final List<Favourite> list;

  FavouriteState(this.list);
}

class LoadingFavourites extends FavouriteState {
  LoadingFavourites(List<Favourite> list) : super(list);
}

class SavingFavourite extends FavouriteState {
  SavingFavourite(List<Favourite> list) : super(list);
}

class DeletingFavourite extends FavouriteState {
  DeletingFavourite(List<Favourite> list) : super(list);
}

class LoadedFavourites extends FavouriteState {
  LoadedFavourites(List<Favourite> list) : super(list);
}

class FavouritesError extends FavouriteState {
  FavouritesError(List<Favourite> list) : super(list);
}
