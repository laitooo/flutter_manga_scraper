import 'package:flutter/cupertino.dart';
import 'package:manga_scraper/translation/language.dart';

enum MangaType {
  JapaneseManga, // 1
  KoreanManhua, // 2
  ChineseManhua, // 3
}

String mangaTypeToString(int typeId, BuildContext context) {
  switch (MangaType.values[typeId - 1]) {
    case MangaType.JapaneseManga:
      return Language.of(context).japaneseManga;
    case MangaType.KoreanManhua:
      return Language.of(context).koreanManhua;
    case MangaType.ChineseManhua:
      return Language.of(context).chineseManhua;
    default:
      return "Error";
  }
}

enum MangaStatus {
  OnGoing, // 1
  Completed, // 2
  Stopped, // 3
}

String mangaStatusToString(int statusId, BuildContext context) {
  switch (MangaStatus.values[statusId - 1]) {
    case MangaStatus.OnGoing:
      return Language.of(context).onGoing;
    case MangaStatus.Completed:
      return Language.of(context).completed;
    case MangaStatus.Stopped:
      return Language.of(context).stopped;
    default:
      return "Error";
  }
}

enum MangaCategories {
  Action, // 1
  Adventure, // 2
  Comedy, // 3
  Demons, // 4
  Drama, // 5
  Echi, // 6
  Fantasy, //7
  Hentai, // 8
  Harem, // 9
  Historical, // 10
  Horror, // 11
  Jousei, // 12
  MartialArts, // 13
  Mature, // 14
  Mecha, // 15
  Mystery, // 16
  OneShot, // 17
  Psychological, // 18
  Romance, // 19
  SchoolLife, // 20
  Scifi, // 21
  Seinen, // 22
  Shouju, // 23
  ShoujuAi, // 24
  Shounen, // 25
  ShounenAi, // 26
  SliceOfLife, // 27
  Sports, // 28
  Supernatural, // 29
  Tragedy, // 30
  Vampire, // 31
  Magic, // 32
  Webtoon, // 33
  Doujinshi, // 34
}

// ignore: missing_return
String mangaCategoryToString(int categoryId, BuildContext context) {
  switch (MangaCategories.values[categoryId]) {
    case MangaCategories.Action:
      return Language.of(context).action;
    case MangaCategories.Action:
      return Language.of(context).action;
    case MangaCategories.Adventure:
      return Language.of(context).adventure;
    case MangaCategories.Comedy:
      return Language.of(context).comedy;
    case MangaCategories.Demons:
      return Language.of(context).demons;
    case MangaCategories.Drama:
      return Language.of(context).drama;
    case MangaCategories.Echi:
      return Language.of(context).ecchi;
    case MangaCategories.Fantasy:
      return Language.of(context).fantasy;
    case MangaCategories.Hentai:
      return Language.of(context).hentai;
    case MangaCategories.Harem:
      return Language.of(context).harem;
    case MangaCategories.Historical:
      return Language.of(context).historical;
    case MangaCategories.Horror:
      return Language.of(context).horror;
    case MangaCategories.Jousei:
      return Language.of(context).jousei;
    case MangaCategories.MartialArts:
      return Language.of(context).martialArt;
    case MangaCategories.Mature:
      return Language.of(context).mature;
    case MangaCategories.Mecha:
      return Language.of(context).mecha;
    case MangaCategories.Mystery:
      return Language.of(context).mystery;
    case MangaCategories.OneShot:
      return Language.of(context).oneShot;
    case MangaCategories.Psychological:
      return Language.of(context).psychological;
    case MangaCategories.Romance:
      return Language.of(context).romance;
    case MangaCategories.SchoolLife:
      return Language.of(context).schoolLife;
    case MangaCategories.Scifi:
      return Language.of(context).sciFi;
    case MangaCategories.Seinen:
      return Language.of(context).seinen;
    case MangaCategories.Shouju:
      return Language.of(context).shouju;
    case MangaCategories.ShoujuAi:
      return Language.of(context).shoujuAi;
    case MangaCategories.Shounen:
      return Language.of(context).shounen;
    case MangaCategories.ShounenAi:
      return Language.of(context).shoujuAi;
    case MangaCategories.SliceOfLife:
      return Language.of(context).sliceOfLife;
    case MangaCategories.Sports:
      return Language.of(context).sports;
    case MangaCategories.Supernatural:
      return Language.of(context).superNatural;
    case MangaCategories.Tragedy:
      return Language.of(context).tragedy;
    case MangaCategories.Vampire:
      return Language.of(context).vampire;
    case MangaCategories.Magic:
      return Language.of(context).magic;
    case MangaCategories.Webtoon:
      return Language.of(context).webtoon;
    case MangaCategories.Doujinshi:
      return Language.of(context).doujinshi;
  }
}

// ignore: missing_return
String mangaCategoryToEnglishString(int categoryId, BuildContext context) {
  switch (MangaCategories.values[categoryId]) {
    case MangaCategories.Action:
      return 'action';
    case MangaCategories.Adventure:
      return 'adventure';
    case MangaCategories.Comedy:
      return 'comedy';
    case MangaCategories.Demons:
      return 'demons';
    case MangaCategories.Drama:
      return 'drama';
    case MangaCategories.Echi:
      return 'ecchi';
    case MangaCategories.Fantasy:
      return 'fantasy';
    case MangaCategories.Hentai:
      return 'hentai';
    case MangaCategories.Harem:
      return 'harem';
    case MangaCategories.Historical:
      return 'historical';
    case MangaCategories.Horror:
      return 'horror';
    case MangaCategories.Jousei:
      return 'josei';
    case MangaCategories.MartialArts:
      return 'martial-arts';
    case MangaCategories.Mature:
      return 'mature';
    case MangaCategories.Mecha:
      return 'mecha';
    case MangaCategories.Mystery:
      return 'mystery';
    case MangaCategories.OneShot:
      return 'one-shot';
    case MangaCategories.Psychological:
      return 'psychological';
    case MangaCategories.Romance:
      return 'romance';
    case MangaCategories.SchoolLife:
      return 'school-life';
    case MangaCategories.Scifi:
      return 'sci-fi';
    case MangaCategories.Seinen:
      return 'seinen';
    case MangaCategories.Shouju:
      return 'shoujo';
    case MangaCategories.ShoujuAi:
      return 'shoujo-ai';
    case MangaCategories.Shounen:
      return 'shounen';
    case MangaCategories.ShounenAi:
      return 'shounen-ai';
    case MangaCategories.SliceOfLife:
      return 'slice-of-life';
    case MangaCategories.Sports:
      return 'sports';
    case MangaCategories.Supernatural:
      return 'supernatural';
    case MangaCategories.Tragedy:
      return 'tragedy';
    case MangaCategories.Vampire:
      return 'vampire';
    case MangaCategories.Magic:
      return 'magic';
    case MangaCategories.Webtoon:
      return 'Webtoons';
    case MangaCategories.Doujinshi:
      return 'doujinshi';
  }
}

String categoriesToString(List<bool> list, BuildContext context) {
  String tmp = '';
  for (int i = 0; i < MangaCategories.values.length; i++) {
    if (list[i])
      tmp += mangaCategoryToEnglishString(i, context) +
          (i != list.length - 1 ? ',' : '');
  }
  return tmp;
}

enum ReadingMode {
  Horizontal,
  Vertical,
}

enum HomePageType {
  home,
  mangaList,
  news,
  downloads,
  chat,
  settings,
}

enum ErrorType {
  noInternet,
  networkError,
  platformError,
  serverError,
}

String errorTypeToText(BuildContext context, ErrorType type) {
  switch (type) {
    case ErrorType.noInternet:
      return Language.of(context).noInternet;
    case ErrorType.platformError:
      return Language.of(context).platformError;
    case ErrorType.serverError:
      return Language.of(context).serverError;
    case ErrorType.networkError:
    default:
      return Language.of(context).networkError;
  }
}

enum UiDownloadAction {
  progressUpdate,
  downloadFailed,
  downloadCompleted,
  alreadyDownloaded,
  startedDownload,
  addedToQueue,
  streamingDownloads,
  errorStreaming,
  deletedDownload,
  deletedDownloads,
  errorDeleting,
}

extension UiDownloadExtension on UiDownloadAction {
  String toText() {
    switch (this) {
      case UiDownloadAction.progressUpdate:
        return 'progress';
      case UiDownloadAction.downloadFailed:
        return 'failed';
      case UiDownloadAction.downloadCompleted:
        return 'completed';
      case UiDownloadAction.alreadyDownloaded:
        return 'already';
      case UiDownloadAction.streamingDownloads:
        return 'streaming';
      case UiDownloadAction.errorStreaming:
        return 'error_stream';
      case UiDownloadAction.deletedDownload:
        return 'deleted_single';
      case UiDownloadAction.deletedDownloads:
        return 'deleted_list';
      case UiDownloadAction.errorDeleting:
        return 'error_delete';
      case UiDownloadAction.addedToQueue:
      default:
        return 'in_queue';
    }
  }
}

enum ServiceDownloadAction {
  foregroundMode,
  backgroundMode,
  stopService,
  addDownload,
  streamDownloads,
  deleteDownload,
  deleteDownloads,
}

extension ServiceDownloadExtenstion on ServiceDownloadAction {
  String toText() {
    switch (this) {
      case ServiceDownloadAction.foregroundMode:
        return 'foreground';
      case ServiceDownloadAction.backgroundMode:
        return 'background';
      case ServiceDownloadAction.streamDownloads:
        return 'stream';
      case ServiceDownloadAction.stopService:
        return 'stop';
      case ServiceDownloadAction.deleteDownload:
        return 'delete_single';
      case ServiceDownloadAction.deleteDownloads:
        return 'delete_list';
      case ServiceDownloadAction.addDownload:
      default:
        return 'add';
    }
  }
}
