import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/search_history_bloc.dart';
import 'package:manga_scraper/models/search_history.dart';
import 'package:manga_scraper/screens/details/manga_details_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';

class SearchHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
      builder: (context, state) {
        if (state is LoadedSearchHistory && state.list.isNotEmpty) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  Language.of(context).searchHistory + ' :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  strutStyle: AppFonts.getStyle(),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: state.list
                      .map((item) => _searchHistoryItem(item, context))
                      .toList(),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<SearchHistoryBloc>(context)
                        .add(ClearSearchHistory());
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.7),
                    ),
                  ),
                  child: Text(
                    Language.of(context).clearSearchHistory,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            child: Center(
              child: Text(
                Language.of(context).emptySearchHistory,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                strutStyle: AppFonts.getStyle(),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _searchHistoryItem(SearchHistory searchHistory, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaDetailsScreen(
              slug: searchHistory.slug,
              name: searchHistory.name,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.getPrimaryColor(),
          ),
        ),
        child: Text(
          searchHistory.name,
          style: TextStyle(
            color: AppColors.getPrimaryColor(),
            fontSize: 12,
            fontFamily: AppFonts.english,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
      ),
    );
  }
}
