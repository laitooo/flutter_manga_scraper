import 'dart:io';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:path_provider/path_provider.dart';

abstract class DownloadsListRepository {
  Future<OrError<List<DownloadData>, Null>> load();
  Stream<Map<String, dynamic>> stream();
  Future<OrError<DownloadData, Null>> get(String slug, String number);
  Future<OrError<Null, Null>> save(DownloadCompanion download);
  Future<OrError<Null, Null>> update(DownloadCompanion download);
  Future<OrError<Null, Null>> deleteList(List<DownloadData> downloads);
  Future<OrError<Null, Null>> delete(DownloadData download);
  Future<bool> isDownloaded(String slug, String number);
}

class MoorDownloadsListRepository extends DownloadsListRepository {
  final MoorDatabase database;

  MoorDownloadsListRepository(this.database);

  @override
  Future<OrError<Null, Null>> delete(DownloadData download) async {
    await database.deleteDownload(download);
    final extPath = (await getExternalStorageDirectory()).path;
    final path =
        "$extPath/${Constants.rootDir}/${Constants.downloadsDir}/${download.name}/" +
            download.number;
    final directory = Directory(path);
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
    return OrError.value(null);
  }

  @override
  Future<OrError<Null, Null>> deleteList(List<DownloadData> downloads) async {
    for (int i = 0; i < downloads.length; i++) {
      await database.deleteDownload(downloads[i]);
    }
    return OrError.value(null);
  }

  @override
  Future<OrError<DownloadData, Null>> get(String slug, String number) async {
    final res = await database.getDownload(slug, number);
    if (res == null) return OrError.error(null);
    return OrError.value(res);
  }

  @override
  Future<bool> isDownloaded(String slug, String number) async {
    return await database.isDownloaded(slug, number);
  }

  @override
  Future<OrError<List<DownloadData>, Null>> load() async {
    final res = await database.loadDownloads();
    return OrError.value(res);
  }

  @override
  Future<OrError<Null, Null>> save(DownloadCompanion download) async {
    if (download.hasFailed.value) {
      await database.deleteDownloadByKeys(
          download.slug.value, download.number.value);
    }
    await database.saveDownload(download);
    return OrError.value(null);
  }

  @override
  Stream<Map<String, dynamic>> stream() {
    FlutterBackgroundService().sendData({
      'action': ServiceDownloadAction.streamDownloads.toText(),
    });
    return FlutterBackgroundService()
        .onDataReceived
        .where((event) => !event['dialog']);
  }

  @override
  Future<OrError<Null, Null>> update(DownloadCompanion download) async {
    await database.updateDownload(download);
    return OrError.value(null);
  }
}

class MockDownloadsListRepository extends DownloadsListRepository {
  @override
  Future<OrError<Null, Null>> deleteList(List<DownloadData> downloads) async {
    for (int i = 0; i < downloads.length; i++) {
      print('mock downloads: deleted manga with slug: ${downloads[i].slug}');
    }
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Future<OrError<Null, Null>> delete(DownloadData download) async {
    print('mock downloads: deleted manga with slug: ${download.slug}');
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Future<bool> isDownloaded(String slug, String number) async {
    return generator.generateBool();
  }

  @override
  Future<OrError<Null, Null>> save(DownloadCompanion download) async {
    print('mock downloads: saved manga with slug: ${download.slug}');
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Future<OrError<List<DownloadData>, Null>> load() async {
    final list = _listGenerator(10);
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(list),
    );
  }

  @override
  Future<OrError<DownloadData, Null>> get(String slug, String number) {
    return Future.delayed(
      Duration(seconds: 1),
      () => OrError.value(_itemGenerator()),
    );
  }

  @override
  Future<OrError<Null, Null>> update(DownloadCompanion download) {
    print('mock download update: download progress: ' +
        download.progress.toString());
    return Future.delayed(Duration.zero, () => OrError.value(null));
  }

  @override
  Stream<Map<String, dynamic>> stream() async* {
    await Future.delayed(Duration(seconds: 1));
    yield {
      'status': UiDownloadAction.streamingDownloads.toText(),
      'list': _listGenerator(10).map((e) => e.toJson()).toList(),
    };
    await Future.delayed(Duration(seconds: 3));
    DownloadData mock = _itemGenerator(true);
    yield {
      'status': UiDownloadAction.startedDownload.toText(),
      'download': mock.toJson(),
    };
    for (int i = 0; i < mock.images; i++) {
      await Future.delayed(Duration(seconds: 1));
      mock = mock.copyWith(progress: mock.progress + 1);
      if (i != mock.images - 1) {
        yield {
          'status': UiDownloadAction.progressUpdate.toText(),
          'slug': mock.slug,
          'number': mock.number,
          'progress': mock.progress,
        };
      } else {
        yield {
          'status': UiDownloadAction.downloadCompleted.toText(),
          'slug': mock.slug,
          'number': mock.number,
        };
      }
    }
  }

  List<DownloadData> _listGenerator(int length) {
    return List.generate(generator.generateNumber(length), (index) {
      final maxImages = generator.generateNumber(50);

      return DownloadData(
        slug: generator.mangaSlug(),
        name: generator.mangaName(),
        cover: generator.mangaCoverAsset(),
        hasCover: generator.generateBool(),
        isDownloading: generator.generateBool(),
        number: generator.generateNumber(100).toString(),
        hasFailed: generator.generateBool(),
        images: maxImages,
        progress: generator.generateNumber(maxImages),
        volume: generator.generateNumber(50).toString(),
        first: '',
      );
    });
  }

  DownloadData _itemGenerator([bool justStarted = false]) {
    // just started identifies if it's a download that just started with no progress
    return DownloadData(
      slug: generator.mangaSlug(),
      name: generator.mangaName(),
      cover: generator.mangaCoverAsset(),
      hasCover: generator.generateBool(),
      isDownloading: justStarted ? true : generator.generateBool(),
      number: generator.generateNumber(100).toString(),
      progress: justStarted ? 0 : generator.generateNumber(50),
      hasFailed: justStarted ? false : generator.generateBool(),
      images: generator.generateNumber(50),
      volume: generator.generateNumber(50).toString(),
      first: '',
    );
  }
}
