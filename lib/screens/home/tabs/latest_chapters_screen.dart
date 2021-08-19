import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/latest_chapters_bloc.dart';
import 'package:manga_scraper/screens/details/manga_details_screen.dart';
import 'package:manga_scraper/screens/reader/manga_reader_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/widgets/chapter_view.dart';
import 'package:manga_scraper/widgets/paginated_list.dart';

class LatestChaptersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LatestChaptersBloc()..add(LoadLatestChapters()),
        child: _LatestChaptersScreen());
  }
}

class _LatestChaptersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: PaginatedList<LatestChaptersBloc, LatestChaptersState,
            LoadingLatestChapters, LatestChaptersEnded, LatestChaptersError>(
          getItemsCount: (state) => state.list.length,
          header: Container(),
          emptyText: Language.of(context).endOfList,
          buildItemWidget: (state, index) => ChapterView(
            latestChapter: state.list[index],
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaDetailsScreen(
                    slug: state.list[index].manga.slug,
                    name: state.list[index].manga.name,
                  ),
                ),
              );
            },
            onChapterClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaReaderScreen(
                    name: state.list[index].manga.name,
                    slug: state.list[index].manga.slug,
                    chapter: state.list[index].number,
                    isHorizontal:
                        prefs.getReadingMode() == ReadingMode.Horizontal,
                  ),
                ),
              );
            },
          ),
          onLoadMore: (context) => BlocProvider.of<LatestChaptersBloc>(context)
              .add(LoadLatestChapters()),
          onError: (errorState) {
            context.showSnackBar(
              errorTypeToText(context, errorState.errorType),
              1,
            );
          },
        ),
      ),
    );
  }
}
