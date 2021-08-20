import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/blocs/favourites_bloc.dart';
import 'package:manga_scraper/blocs/manga_details_bloc.dart';
import 'package:manga_scraper/models/favourite.dart';
import 'package:manga_scraper/screens/reader/manga_reader_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/utils/share.dart';
import 'package:manga_scraper/widgets/auto_rotate.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/chapter_button.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';

class MangaDetailsScreen extends StatelessWidget {
  final String slug;
  final String name;

  const MangaDetailsScreen({Key key, this.slug, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MangaDetailsBloc()
            ..add(
              LoadMangaDetails(slug),
            ),
        ),
        BlocProvider(create: (_) => FavouritesBloc())
      ],
      child: _MangaDetailsScreen(
        slug: slug,
        name: name,
      ),
    );
  }
}

class _MangaDetailsScreen extends StatefulWidget {
  final String slug;
  final String name;

  const _MangaDetailsScreen({Key key, this.slug, this.name}) : super(key: key);

  @override
  __MangaDetailsScreenState createState() => __MangaDetailsScreenState();
}

class __MangaDetailsScreenState extends State<_MangaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final _spacer = SizedBox(height: 5);
    final _textStyle = TextStyle(
      color: AppColors.getPrimaryColor(),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getPrimaryColor(),
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: AppFonts.english,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
        titleSpacing: 0,
        toolbarHeight: 40,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: AutoRotate(
            child: SvgPicture.asset(
              'assets/icons/back_icon.svg',
              color: Colors.white,
              width: 25,
              height: 25,
            ),
          ),
        ),
        actions: _appBarActions(),
      ),
      body: BlocConsumer<MangaDetailsBloc, MangaDetailsState>(
        listener: (context, state) {
          if (state is MangaDetailsError) {
            context.showSnackBar(
              errorTypeToText(context, state.errorType),
              1,
            );
          }
        },
        builder: (context, state) {
          if (state is MangaDetailsError) {
            return Container(
              child: Center(child: ErrorButton(
                onClick: (_) {
                  BlocProvider.of<MangaDetailsBloc>(context)
                      .add(LoadMangaDetails(widget.slug));
                },
              )),
            );
          } else if (state is LoadingMangaDetails) {
            return Center(child: AppProgressIndicator());
          } else {
            final mangaDetail =
                BlocProvider.of<MangaDetailsBloc>(context).state.mangaDetail;

            return ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: AppColors.getPrimaryColor(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: 100,
                        height: 150,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: new DecorationImage(
                              image: Features.isMockHttp
                                  ? AssetImage(mangaDetail.cover)
                                  : NetworkImage(mangaDetail.cover),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (mangaDetail.author != null) ...[
                            _spacer,
                            Text(
                              Language.of(context).author +
                                  ' : ' +
                                  mangaDetail.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _textStyle,
                              strutStyle: AppFonts.getStyle(),
                            ),
                          ],
                          _spacer,
                          Text(
                            Language.of(context).genres +
                                ' : ' +
                                mangaDetail.categories.join(', '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _textStyle,
                            strutStyle: AppFonts.getStyle(),
                          ),
                          _spacer,
                          Text(
                            Language.of(context).status +
                                ' : ' +
                                mangaDetail.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _textStyle,
                          ),
                          _spacer,
                          Text(
                            Language.of(context).rate +
                                ' : ' +
                                mangaDetail.rate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _textStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    mangaDetail.summary,
                    style: TextStyle(
                      color: AppColors.getPrimaryColor(),
                      fontSize: 12,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                      mangaDetail.chapters.length,
                      (index) => Container(
                        width: 55,
                        child: ChapterButton(
                          chapter: mangaDetail.chapters[index],
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaReaderScreen(
                                  name: mangaDetail.name,
                                  slug: mangaDetail.slug,
                                  volume: mangaDetail.chapters[index].volume,
                                  chapter: mangaDetail.chapters[index].number,
                                  isHorizontal: prefs.getReadingMode() ==
                                      ReadingMode.Horizontal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  /*String categoriesToString(List<Category> list) {
    String text = '';
    for (int i = 0; i < list.length; i++) {
      text += list[i].name + (i != list.length - 1 ? ', ' : '');
    }
    return text;
  }*/

  _appBarActions() {
    return [
      BlocBuilder<MangaDetailsBloc, MangaDetailsState>(
        builder: (context, state) {
          final state = BlocProvider.of<MangaDetailsBloc>(context).state;
          if (state is LoadedMangaDetails) {
            return IconButton(
                onPressed: () {
                  if (state.mangaDetail.isFav) {
                    BlocProvider.of<FavouritesBloc>(context).add(
                      DeleteFavourite(state.mangaDetail.slug),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(Language.of(context).removedFromFavourites),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    setState(() {
                      state.mangaDetail.isFav = false;
                    });
                  } else {
                    BlocProvider.of<FavouritesBloc>(context).add(
                      SaveFavourite(
                        Favourite.fromMangaDetail(
                            BlocProvider.of<MangaDetailsBloc>(context)
                                .state
                                .mangaDetail),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(Language.of(context).addedToFavourites),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    setState(() {
                      state.mangaDetail.isFav = true;
                    });
                  }
                },
                icon: SvgPicture.asset(
                  state.mangaDetail.isFav
                      ? 'assets/icons/fav_icon.svg'
                      : 'assets/icons/unfav_icon.svg',
                  color: Colors.white,
                  width: 25,
                  height: 25,
                ));
          } else {
            return Container();
          }
        },
      ),
      IconButton(
        onPressed: () async {
          ShareLink().shareManga(widget.name, widget.slug, context);
        },
        icon: SvgPicture.asset(
          'assets/icons/share_icon.svg',
          color: Colors.white,
          width: 25,
          height: 25,
        ),
      ),
    ];
  }
}
