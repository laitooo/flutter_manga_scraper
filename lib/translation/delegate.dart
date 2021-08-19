import 'package:flutter/cupertino.dart';
import 'package:manga_scraper/translation/arabic.dart';
import 'package:manga_scraper/translation/english.dart';
import 'package:manga_scraper/translation/language.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Language> {
  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<Language> load(Locale locale) => _load(locale);

  static Future<Language> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return EnglishLanguage();
      case 'ar':
        return ArabicLanguage();
      default:
        return ArabicLanguage();
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Language> old) => true;
}
