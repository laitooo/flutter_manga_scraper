import 'package:flutter/material.dart';

abstract class Language {
  static Language of(BuildContext context) {
    return Localizations.of<Language>(context, Language);
  }

  String get appName;
  String get english;
  String get arabic;
  String get homeScreen;
  String get mangaList;
  String get news;
  String get downloads;
  String get chat;
  String get settings;
  String get latestChapters;
  String get mostViewed;
  String get favorites;
  String get japaneseManga;
  String get koreanManhua;
  String get chineseManhua;
  String get onGoing;
  String get stopped;
  String get completed;
  String get type;
  String get author;
  String get genres;
  String get status;
  String get releaseDate;
  String get notificationMode;
  String get favouriteMangaNotifications;
  String get readingSettings;
  String get chooseTheme;
  String get favouriteReadingMode;
  String get brightness;
  String get aboutTheApp;
  String get currentVersion;
  String get lastUpdate;
  String get privacyPolicy;
  String get contactUs;
  String get vertical;
  String get horizontal;
  String get reportABug;
  String get subject;
  String get content;
  String get send;
  String get cancel;
  String get pleaseFillAllFields;
  String get comments;
  String get chaptersList;
  String get reload;
  String get saveImage;
  String get share;
  String get readingMode;
  String get viewSettings;
  String get doubleClickToZoom;
  String get blackBackground;
  String get thisIsTheLastChapter;
  String get thisIsTheFirstChapter;
  String get latestChapter;
  String get searchForManga;
  String get noSearchResults;
  String get youHaveNoFavouriteMangaYet;
  String get addedToFavourites;
  String get removedFromFavourites;
  String get searchHistory;
  String get clearSearchHistory;
  String get downloadCompleted;
  String get downloadFailed;
  String get downloading;
  String get alreadyDownloaded;
  String get downloadedChapters;
  String get filterByGenres;
  String get filterByType;
  String get filterByStatus;
  String get search;

  String get action;
  String get adventure;
  String get comedy;
  String get demons;
  String get drama;
  String get ecchi;
  String get fantasy;
  String get hentai;
  String get harem;
  String get historical;
  String get horror;
  String get jousei;
  String get martialArt;
  String get mature;
  String get mecha;
  String get mystery;
  String get oneShot;
  String get psychological;
  String get romance;
  String get schoolLife;
  String get sciFi;
  String get seinen;
  String get shouju;
  String get shoujuAi;
  String get shounen;
  String get shounenAi;
  String get sliceOfLife;
  String get sports;
  String get superNatural;
  String get tragedy;
  String get vampire;
  String get magic;
  String get webtoon;
  String get doujinshi;

  String get savedScreenshotToStorage;
  String get someErrorOccurred;
  String get tryAgain;
  String get networkError;
  String get platformError;
  String get serverError;
  String get noInternet;
  String get exit;
  String get youSureYouWantToExit;
  String get yes;
  String get no;
  String get noMangaFoundWithThisCategory;
  String get endOfList;
  String get emptySearchHistory;
  String get tryUsingVpn;
  String get readManga;
  String get readChapter;
  String get fromManga;
  String get usingThisLink;
  String get anotherDownloadInProgress;
  String get errorDeletingChapters;
}