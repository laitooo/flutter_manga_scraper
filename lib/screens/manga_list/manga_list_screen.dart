import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/favourites_bloc.dart';
import 'package:manga_scraper/screens/manga_list/manga_categor_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/utils/enums.dart';

class MangaListScreen extends StatefulWidget {
  const MangaListScreen({
    Key key,
  }) : super(key: key);
  @override
  MangaListScreenState createState() => MangaListScreenState();
}

class MangaListScreenState extends State<MangaListScreen> {
  @override
  Widget build(BuildContext context) {
    final numCategories = MangaCategories.values.length;
    final categories = List.generate(
        numCategories, (index) => mangaCategoryToEnglishString(index, context));
    return DefaultTabController(
      length: numCategories,
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.8),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              indicatorColor: AppColors.getPrimaryColor(),
              tabs: List.generate(
                numCategories,
                (index) => Tab(
                  child: Text(
                    mangaCategoryToString(index, context),
                    strutStyle: AppFonts.getStyle(),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocProvider(
          create: (_) => FavouritesBloc(),
          child: TabBarView(
            children: List.generate(
              numCategories,
              (index) => MangaCategoryScreen(
                category: categories[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
