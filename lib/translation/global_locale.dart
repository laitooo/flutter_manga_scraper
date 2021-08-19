import 'package:flutter/material.dart';
import 'package:manga_scraper/utils/preferences.dart';

const List<String> _supportedLanguages = ['ar', 'en'];
const String defaultLanguage = "en";

class GlobalLocale {
  Locale _locale;

  String get currentLanguage => _locale == null ? '' : _locale.languageCode;

  Locale get locale => _locale;

  init() {
    String languageCode = prefs.getPreferredLanguage();
    _locale = Locale(
      isInvalidLanguageCode(languageCode) ? defaultLanguage : languageCode,
    );
  }

  bool isInvalidLanguageCode(String languageCode) {
    return languageCode == null || !_supportedLanguages.contains(languageCode);
  }

  Future<void> changeLanguage(String languageCode) async {
    if (isInvalidLanguageCode(languageCode) ||
        _locale?.languageCode == languageCode) return;

    _locale = Locale(languageCode, "");
    await prefs.setPreferredLanguage(languageCode);
  }

  bool isGoodLanguage(String languageCode) {
    return !isInvalidLanguageCode(languageCode) &&
        _locale.languageCode != languageCode;
  }

  static final GlobalLocale _translations = GlobalLocale._internal();

  factory GlobalLocale() {
    return _translations;
  }

  GlobalLocale._internal();
}

GlobalLocale lang = GlobalLocale();
