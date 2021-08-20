import 'dart:io';

import 'package:dio/dio.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/or_error.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:path_provider/path_provider.dart';

enum DioDownloadStatus {
  downloadSuccess,
  imageNotFound,
  someError,
}

abstract class DownloadRepository {
  Future<OrError<Null, Null>> download(DownloadCompanion download, int index);
  Future<OrError<Null, Null>> saveCover(DownloadCompanion download);
  Future<OrError<Null, Null>> takeScreenshot(String url);
  Future<OrError<Null, Null>> offlineScreenshot(String path);
}

class DioDownloadRepository extends DownloadRepository {
  final Dio dio;

  DioDownloadRepository(this.dio);
  @override
  Future<OrError<Null, Null>> download(
      DownloadCompanion download, int index) async {
    final extPath = (await getExternalStorageDirectory()).path;
    final path =
        "$extPath/${Constants.rootDir}/${Constants.downloadsDir}/${download.name.value}/" +
            download.number.value;
    if (!Directory(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }
    final url = _generateImageUrl(index, download.first.value);
    final res = await downloadImage(path + '/image${index + 1}.' + 'jpg', url);
    if (res == DioDownloadStatus.downloadSuccess) {
      return OrError.value(null);
    } else {
      return OrError.error(null);
    }
  }

  Future<DioDownloadStatus> downloadImage(String path, String url) async {
    try {
      final res = await dio.download(url, path);
      return res.statusCode == 200
          ? DioDownloadStatus.downloadSuccess
          : DioDownloadStatus.someError;
    } on DioError catch (error) {
      print('dio error: url: ' + url);
      print('dio error: error: ' + error.message);
      if (error.type == DioErrorType.RESPONSE) {
        if (error.response.statusCode == 404)
          return DioDownloadStatus.imageNotFound;
      }
      return DioDownloadStatus.someError;
    }
  }

  @override
  Future<OrError<Null, Null>> saveCover(DownloadCompanion download) async {
    final extPath = (await getExternalStorageDirectory()).path;
    final path =
        "$extPath/${Constants.rootDir}/${Constants.downloadsDir}/${download.name.value}";
    if (!Directory(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }

    final res = await dio.download(download.cover.value, path + '/cover.jpg');
    return res.statusCode == 200 ? OrError.value(null) : OrError.error(null);
  }

  @override
  Future<OrError<Null, Null>> takeScreenshot(String url) async {
    final extPath = (await getExternalStorageDirectory()).path;
    int num = prefs.getNumScreenshots();
    final path = "$extPath/${Constants.rootDir}/${Constants.savedDir}";
    if (!Directory(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }
    final res = await dio.download(url, path + '/screenshot${num + 1}.jpg');
    if (res.statusCode == 200) {
      prefs.setNumScreenshots(num + 1);
      return OrError.value(null);
    } else {
      return OrError.error(null);
    }
  }

  @override
  Future<OrError<Null, Null>> offlineScreenshot(String path) async {
    try {
      final extPath = (await getExternalStorageDirectory()).path;
      int num = prefs.getNumScreenshots();
      final newPath = "$extPath/${Constants.rootDir}/${Constants.savedDir}";
      if (!Directory(newPath).existsSync()) {
        Directory(newPath).createSync(recursive: true);
      }

      final file = File(path);
      file.copy(newPath + '/screenshot${num + 1}.jpg');
      prefs.setNumScreenshots(num + 1);
      print('saved to : ' + newPath + '/screenshot${num + 1}.jpg');
      return OrError.value(null);
    } on FileSystemException catch (e) {
      print(e);
      return OrError.error(null);
    }
  }

  String _generateImageUrl(int index, String first) {
    if (index == 0) return first;
    final e = first.contains('000.jpg');
    final c = '0${(e ? index : index + 1).toString()}';
    final d = c.length == 2 ? '0$c' : c;
    if (e) {
      return first.replaceFirst('000.jpg', '$d.jpg');
    } else {
      return first.replaceFirst('001.jpg', '$d.jpg');
    }
  }
}

class MockDownloadRepository extends DownloadRepository {
  @override
  Future<OrError<Null, Null>> download(
      DownloadCompanion download, int index) async {
    return Future.delayed(Duration(seconds: 1), () => OrError.value(null));
  }

  @override
  Future<OrError<Null, Null>> saveCover(DownloadCompanion download) {
    return Future.delayed(Duration(seconds: 1), () => OrError.value(null));
  }

  @override
  Future<OrError<Null, Null>> takeScreenshot(String url) {
    return Future.delayed(Duration(seconds: 1), () => OrError.value(null));
  }

  @override
  Future<OrError<Null, Null>> offlineScreenshot(String path) {
    return Future.delayed(Duration(seconds: 1), () => OrError.value(null));
  }
}
