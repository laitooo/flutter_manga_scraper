import 'package:flutter/painting.dart';
import 'package:manga_scraper/translation/global_locale.dart';

class AppFonts {
  static final tajawal = 'Tajawal';
  static final ubuntu = 'Ubuntu';

  static String get english => ubuntu;
  static String get arabic => tajawal;

  static String getAppFont() {
    return lang.currentLanguage == 'ar' ? tajawal : ubuntu;
  }

  static StrutStyle getStyle() {
    return StrutStyle(
      forceStrutHeight: true,
    );
  }
}
