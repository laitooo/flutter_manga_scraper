import 'package:shared_preferences/shared_preferences.dart';

import 'enums.dart';

Preferences prefs = Preferences();

class Preferences {
  SharedPreferences _prefs;
  final _locale = 'Locale';
  final _favouriteNotification = 'Favourite Notification';
  final _readingMode = 'Reading mode';
  final _theme = 'Theme';
  final _doubleClickToZoom = 'Double click to zoom';
  final _blackBackground = 'Black background';
  final _mangaListGrid = 'Grid manga list';
  final _apiKey = 'Api key';
  final _apiDomain = 'Api domain';
  final _apiPath = 'Api path';
  final _numScreenshots = 'Number of screenshots';

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  clearAll() async {
    await _prefs.clear();
  }

  setPreferredLanguage(String locale) async {
    await _prefs.setString(_locale, locale);
  }

  String getPreferredLanguage() {
    return _prefs.getString(_locale);
  }

  setFavouriteNotification(bool enabled) async {
    await _prefs.setBool(_favouriteNotification, enabled);
  }

  bool isFavouriteNotification() {
    return _prefs.getBool(_favouriteNotification) ?? true;
  }

  setReadingMode(ReadingMode mode) async {
    await _prefs.setInt(_readingMode, mode.index);
  }

  ReadingMode getReadingMode() {
    return ReadingMode.values[_prefs.getInt(_readingMode) ?? 0];
  }

  setTheme(int theme) async {
    await _prefs.setInt(_theme, theme);
  }

  int getTheme() {
    return _prefs.getInt(_theme) ?? 0;
  }

  setDoubleClickToZoom(bool enabled) async {
    await _prefs.setBool(_doubleClickToZoom, enabled);
  }

  bool isDoubleClickToZoom() {
    return _prefs.getBool(_doubleClickToZoom) ?? true;
  }

  setBlackBackground(bool enabled) async {
    await _prefs.setBool(_blackBackground, enabled);
  }

  bool isBlackBackground() {
    return _prefs.getBool(_blackBackground) ?? true;
  }

  setGridMangaList(bool isGrid) async {
    await _prefs.setBool(_mangaListGrid, isGrid);
  }

  bool isGridMangaList() {
    return _prefs.getBool(_mangaListGrid) ?? true;
  }

  setApiKey(String key) async {
    await _prefs.setString(_apiKey, key);
  }

  String getApiKey() {
    return _prefs.getString(_apiKey);
  }

  setApiDomain(String domain) async {
    await _prefs.setString(_apiDomain, domain);
  }

  String getApiDomain() {
    return _prefs.getString(_apiDomain);
  }

  setApiPath(String path) async {
    await _prefs.setString(_apiPath, path);
  }

  String getApiPath() {
    return _prefs.getString(_apiPath);
  }

  setNumScreenshots(int num) async {
    await _prefs.setInt(_numScreenshots, num);
  }

  int getNumScreenshots() {
    return _prefs.getInt(_numScreenshots) ?? 0;
  }

  static final Preferences _translations = Preferences._internal();

  factory Preferences() {
    return _translations;
  }

  Preferences._internal();
}
