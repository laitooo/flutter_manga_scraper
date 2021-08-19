import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/favourites_bloc.dart';
import 'package:manga_scraper/blocs/manga_list_bloc.dart';
import 'package:manga_scraper/models/favourite.dart';
import 'package:manga_scraper/screens/details/manga_details_screen.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/widgets/manga_grid_card.dart';
import 'package:manga_scraper/widgets/manga_list_card.dart';
import 'package:manga_scraper/widgets/paginated_list.dart';

class MangaCategoryScreen extends StatelessWidget {
  final String category;

  const MangaCategoryScreen({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MangaListBloc()..add(LoadMangaList(category)),
      child: _MangaCategoryScreen(
        category: category,
      ),
    );
  }
}

class _MangaCategoryScreen extends StatefulWidget {
  final String category;

  const _MangaCategoryScreen({Key key, this.category}) : super(key: key);

  @override
  _MangaCategoryScreenState createState() => _MangaCategoryScreenState();
}

class _MangaCategoryScreenState extends State<_MangaCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    if (prefs.isGridMangaList()) {
      return PaginatedGridView<MangaListBloc, MangaListState, LoadingMangaList,
          MangaListEnded, MangaListError>(
        childAspectRatio: 0.55,
        crossAxisCount: 3,
        emptyText: Language.of(context).noMangaFoundWithThisCategory,
        header: Container(),
        onError: (errorState) {
          context.showSnackBar(
            errorTypeToText(context, errorState.errorType),
            1,
          );
        },
        onLoadMore: (context) => BlocProvider.of<MangaListBloc>(context)
            .add(LoadMangaList(widget.category)),
        getItemsCount: (state) => state.list.length,
        buildItemWidget: (state, index) {
          return MangaGridCard.fromMangaListItem(
            mangaItem: state.list[index],
            isFav: state.list[index].isFav,
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaDetailsScreen(
                    slug: state.list[index].slug,
                    name: state.list[index].name,
                  ),
                ),
              );
            },
            onFavClicked: () {
              if (state.list[index].isFav) {
                BlocProvider.of<FavouritesBloc>(context).add(
                  DeleteFavourite(state.list[index].slug),
                );
                context.showSnackBar(
                  Language.of(context).removedFromFavourites,
                  1,
                );
                setState(() {
                  state.list[index].isFav = false;
                });
              } else {
                BlocProvider.of<FavouritesBloc>(context).add(
                  SaveFavourite(Favourite.fromMangaListItem(state.list[index])),
                );
                context.showSnackBar(
                  Language.of(context).addedToFavourites,
                  1,
                );
                setState(() {
                  state.list[index].isFav = true;
                });
              }
            },
          );
        },
      );
    } else {
      return PaginatedList<MangaListBloc, MangaListState, LoadingMangaList,
          MangaListEnded, MangaListError>(
        header: Container(),
        onError: (errorState) {
          context.showSnackBar(
            errorTypeToText(context, errorState.errorType),
            1,
          );
        },
        emptyText: Language.of(context).noMangaFoundWithThisCategory,
        onLoadMore: (context) => BlocProvider.of<MangaListBloc>(context)
            .add(LoadMangaList(widget.category)),
        getItemsCount: (state) => state.list.length,
        buildItemWidget: (state, index) => MangaListCard(
          manga: state.list[index],
          onClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MangaDetailsScreen(
                  slug: state.list[index].slug,
                  name: state.list[index].name,
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
