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

enum MangaCategories {
  FourKoma,
  Action, // 1
  Adventure, // 2
  Comedy, // 3
  Cooking,
  Doujinshi,
  Drama, // 5
  Ecchi, // 6
  Fantasy, //7
  GenderBender,
  Harem, // 9
  Historical, // 10
  Horror, // 11
  MartialArts, // 13
  Mature, // 14
  Mecha, // 15
  Music,
  Mystery, // 16
  OneShot, // 17
  Psychological, // 18
  ReverseHarem,
  Romance, // 19
  SchoolLife, // 20
  Scifi, // 21
  Shotacon,
  SliceOfLife, // 27
  Smut,
  Sports, // 28
  Supernatural, // 29
  Suspense,
  Tragedy, // 30
  Vampire, // 31
  Webtoon, // 33
  Youkai,
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
    case MangaCategories.Drama:
      return Language.of(context).drama;
    case MangaCategories.Fantasy:
      return Language.of(context).fantasy;
    case MangaCategories.Harem:
      return Language.of(context).harem;
    case MangaCategories.Historical:
      return Language.of(context).historical;
    case MangaCategories.Horror:
      return Language.of(context).horror;
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
    case MangaCategories.Webtoon:
      return Language.of(context).webtoon;
    case MangaCategories.Doujinshi:
      return Language.of(context).doujinshi;
    case MangaCategories.FourKoma:
      return Language.of(context).fourKoma;
    case MangaCategories.Cooking:
      return Language.of(context).cooking;
    case MangaCategories.Ecchi:
      return Language.of(context).ecchi;
    case MangaCategories.GenderBender:
      return Language.of(context).genderBender;
    case MangaCategories.Music:
      return Language.of(context).music;
    case MangaCategories.ReverseHarem:
      return Language.of(context).reverseHarem;
    case MangaCategories.Shotacon:
      return Language.of(context).shotakon;
    case MangaCategories.Smut:
      return Language.of(context).smut;
    case MangaCategories.Suspense:
      return Language.of(context).suspense;
    case MangaCategories.Youkai:
      return Language.of(context).youkai;
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
    case MangaCategories.Drama:
      return 'drama';
    case MangaCategories.Ecchi:
      return 'ecchi';
    case MangaCategories.Fantasy:
      return 'fantasy';
    case MangaCategories.Harem:
      return 'harem';
    case MangaCategories.Historical:
      return 'historical';
    case MangaCategories.Horror:
      return 'horror';
    case MangaCategories.MartialArts:
      return 'martial_arts';
    case MangaCategories.Mature:
      return 'mature';
    case MangaCategories.Mecha:
      return 'mecha';
    case MangaCategories.Mystery:
      return 'mystery';
    case MangaCategories.OneShot:
      return 'one_shot';
    case MangaCategories.Psychological:
      return 'psychological';
    case MangaCategories.Romance:
      return 'romance';
    case MangaCategories.SchoolLife:
      return 'school_life';
    case MangaCategories.Scifi:
      return 'sci_fi';
    case MangaCategories.SliceOfLife:
      return 'slice_of_life';
    case MangaCategories.Sports:
      return 'sports';
    case MangaCategories.Supernatural:
      return 'supernatural';
    case MangaCategories.Tragedy:
      return 'tragedy';
    case MangaCategories.Vampire:
      return 'vampire';
    case MangaCategories.Webtoon:
      return 'Webtoons';
    case MangaCategories.Doujinshi:
      return 'doujinshi';
    case MangaCategories.FourKoma:
      return '4_koma';
    case MangaCategories.Cooking:
      return 'cooking';
    case MangaCategories.GenderBender:
      return 'gender_bender';
    case MangaCategories.Music:
      return 'music';
    case MangaCategories.ReverseHarem:
      return 'reverse_harem';
    case MangaCategories.Shotacon:
      return 'shotacon';
    case MangaCategories.Smut:
      return 'smut';
    case MangaCategories.Suspense:
      return 'suspense';
    case MangaCategories.Youkai:
    default:
      return 'youkai';
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
