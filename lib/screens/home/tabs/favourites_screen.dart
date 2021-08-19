import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/favourites_bloc.dart';
import 'package:manga_scraper/screens/details/manga_details_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/manga_grid_card.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavouritesBloc()..add(LoadFavourites()),
      child: _FavouritesScreen(),
    );
  }
}

class _FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: BlocBuilder<FavouritesBloc, FavouriteState>(
          builder: (context, state) {
            if (state is FavouritesError) {
              return Container(
                child: Center(
                  child: ErrorButton(
                    onClick: (_) {
                      BlocProvider.of<FavouritesBloc>(context)
                          .add(LoadFavourites());
                    },
                  ),
                ),
              );
            } else if (state is LoadingFavourites ||
                state is SavingFavourite ||
                state is DeletingFavourite) {
              return Center(child: AppProgressIndicator());
            } else {
              if (state.list.isNotEmpty) {
                return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 0.55,
                  children: List.generate(
                    state.list.length,
                    (index) => MangaGridCard.fromFavourite(
                      favourite: state.list[index],
                      isFav: true,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MangaDetailsScreen(
                              slug: state.list[index].slug,
                              name: state.list[index].name,
                            ),
                          ),
                        ).then((_) => {
                              BlocProvider.of<FavouritesBloc>(context)
                                  .add(LoadFavourites())
                            });
                      },
                      onFavClicked: () {
                        BlocProvider.of<FavouritesBloc>(context)
                            .add(DeleteFavourite(state.list[index].slug));
                        context.showSnackBar(
                          Language.of(context).removedFromFavourites,
                          1,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    Language.of(context).youHaveNoFavouriteMangaYet,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
