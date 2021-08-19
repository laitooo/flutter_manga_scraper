import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/blocs/search_bloc.dart';
import 'package:manga_scraper/blocs/search_history_bloc.dart';
import 'package:manga_scraper/models/search_history.dart';
import 'package:manga_scraper/screens/details/manga_details_screen.dart';
import 'package:manga_scraper/screens/search/advanced_filter_dialog.dart';
import 'package:manga_scraper/screens/search/search_history_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/widgets/auto_rotate.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';
import 'package:manga_scraper/widgets/search_result_card.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchBloc(),
        ),
        BlocProvider(
          create: (_) => SearchHistoryBloc()
            ..add(
              LoadSearchHistory(),
            ),
        )
      ],
      child: _SearchScreen(),
    );
  }
}

class _SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<_SearchScreen> {
  final _controller = TextEditingController();
  bool isRecording;

  @override
  void initState() {
    super.initState();
    isRecording = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: AppColors.getPrimaryColor(),
        leadingWidth: 40,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: AutoRotate(
            child: SvgPicture.asset(
              'assets/icons/back_icon.svg',
              color: Colors.white,
              width: 30,
              height: 30,
            ),
          ),
        ),
        actions: _appBarActions(),
      ),
      body: Stack(
        children: [
          BlocConsumer<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state is SearchError) {
                context.showSnackBar(
                  errorTypeToText(context, state.errorType),
                  1,
                );
              }
            },
            builder: (context, state) {
              if (state is NoSearch) {
                return SearchHistoryScreen();
              } else if (state is SearchError) {
                return Center(
                  child: ErrorButton(
                    onClick: (_) {},
                  ),
                );
              } else if (state is SearchSuccess) {
                if (state.list.isNotEmpty) {
                  print('=====' * 30);
                  print('results list length: ${state.list.length}');
                  print(state.list.toString());
                  return ListView(
                    children: state.list
                        .map(
                          (result) => SearchResultCard(
                              searchResult: result,
                              searchText: state.searchText,
                              onClick: () {
                                BlocProvider.of<SearchHistoryBloc>(context).add(
                                  SaveSearchHistory(
                                      SearchHistory.fromSearchResult(result)),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MangaDetailsScreen(
                                      slug: result.slug,
                                      name: result.name,
                                    ),
                                  ),
                                );
                              }),
                        )
                        .toList(),
                  );
                } else {
                  return Center(
                    child: Text(
                      Language.of(context).noSearchResults,
                      strutStyle: AppFonts.getStyle(),
                    ),
                  );
                }
              } else {
                return Center(child: AppProgressIndicator.page());
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        width: MediaQuery.of(context).size.width - 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.getAccentColor(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    if (text.isEmpty) {
                      BlocProvider.of<SearchBloc>(context).add(CancelSearch());
                    } else {
                      BlocProvider.of<SearchBloc>(context).add(StartSearch(
                        name: text,
                      ));
                    }
                  },
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9]+|\s'))
                  ],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  strutStyle: AppFonts.getStyle(),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                    hintText: Language.of(context).searchForManga,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      if (Features.isAdvanceSearch)
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AdvancedFilterDialog(
                bloc: BlocProvider.of<SearchBloc>(context),
              ),
            );
          },
          icon: SvgPicture.asset(
            'assets/icons/filter_icon.svg',
            color: Colors.white,
            width: 30,
            height: 30,
          ),
        ),
    ];
  }
}
