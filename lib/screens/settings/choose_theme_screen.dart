import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/blocs/theme_bloc.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/theme/themes_list.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/widgets/auto_rotate.dart';

class ChooseThemeScreen extends StatefulWidget {
  @override
  _ChooseThemeScreenState createState() => _ChooseThemeScreenState();
}

class _ChooseThemeScreenState extends State<ChooseThemeScreen> {
  int selected;

  @override
  void initState() {
    super.initState();
    selected = prefs.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getSelectedAccentColor(selected),
        title: Text(
          Language.of(context).chooseTheme,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context).add(ChangeTheme(selected));
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset(
              'assets/icons/check_icon.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 0.7,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: List.generate(16, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selected = index;
                });
              },
              child: Container(
                color: ThemesList.primaryColors[index],
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  color: ThemesList.accentColors[index],
                  child: Visibility(
                    visible: index == selected,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/check_icon.svg',
                        color: Colors.white,
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
