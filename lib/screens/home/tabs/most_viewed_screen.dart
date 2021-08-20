import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/favourites_bloc.dart';
import 'package:manga_scraper/blocs/most_viewed_bloc.dart';
import 'package:manga_scraper/screens/details/manga_details_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/utils/size_utils.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/manga_grid_card.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';

class MostViewedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MostViewedBloc()..add(LoadMostViewed())),
        BlocProvider(create: (_) => FavouritesBloc()),
      ],
      child: _MostViewedScreen(),
    );
  }
}

class _MostViewedScreen extends StatefulWidget {
  @override
  _MostViewedScreenState createState() => _MostViewedScreenState();
}

class _MostViewedScreenState extends State<_MostViewedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        child: BlocConsumer<MostViewedBloc, MostViewedState>(
          listener: (context, state) {
            if (state is MostViewedError) {
              context.showSnackBar(
                errorTypeToText(context, state.errorType),
                1,
              );
            }
          },
          builder: (context, state) {
            if (state is MostViewedError) {
              return Container(
                child: Center(
                  child: ErrorButton(
                    onClick: (_) {
                      BlocProvider.of<MostViewedBloc>(context)
                          .add(LoadMostViewed());
                    },
                  ),
                ),
              );
            } else if (state is LoadingMostViewed) {
              return Center(child: AppProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: sizeUtils.horizontalWrapPadding(130),
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      state.list.length,
                      (index) => MangaGridCard.fromManga(
                        manga: state.list[index],
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MangaDetailsScreen(
                                      slug: state.list[index].slug,
                                      name: state.list[index].name,
                                    )),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
