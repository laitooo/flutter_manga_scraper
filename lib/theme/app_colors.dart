import 'package:flutter/material.dart';
import 'package:manga_scraper/theme/themes_list.dart';
import 'package:manga_scraper/utils/preferences.dart';

class AppColors {
  static final unselectedTabColor = Color(0xFF9B9B9B);
  static final backgroundColor = Color(0xFF9B9B9B);
  static final mainColor1 = Color(0xff0f313a);
  static final mainColor2 = Color(0xff0db3a9);
  static final mainColor3 = Color(0xffd7e1c9);
  static final gradientSplashStart = Color(0xffe2fefc);
  static final gradientSplashEnd = Color(0xfff1f2c6);

  static Color getPrimaryColor() {
    return ThemesList.primaryColors[prefs.getTheme()];
  }

  static Color getAccentColor() {
    return ThemesList.accentColors[prefs.getTheme()];
  }

  static Color getSelectedPrimaryColor(int selected) {
    return ThemesList.primaryColors[selected];
  }

  static Color getSelectedAccentColor(int selected) {
    return ThemesList.accentColors[selected];
  }
}
