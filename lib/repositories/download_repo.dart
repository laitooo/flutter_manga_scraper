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
  Future<OrError<Null, Null>> download(
      DownloadCompanion download, String domain, int index);
  Future<OrError<Null, Null>> saveCover(DownloadCompanion download);
  Future<OrError<Null, Null>> takeScreenshot(String url);
  Future<OrError<Null, Null>> offlineScreenshot(String path);
}

class DioDownloadRepository extends DownloadRepository {
  final Dio dio;

  DioDownloadRepository(this.dio);
  @override
  Future<OrError<Null, Null>> download(
      DownloadCompanion download, String domain, int index) async {
    final extPath = (await getExternalStorageDirectory()).path;
    final path =
        "$extPath/${Constants.rootDir}/${Constants.downloadsDir}/${download.name.value}/" +
            download.number.value;
    if (!Directory(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }
    final url = _generateImageUrl(domain, index, download.slug.value,
        download.number.value, download.extension.value);
    final res = await downloadImage(
        path + '/image${index + 1}.' + download.extension.value, url);
    if (res == DioDownloadStatus.downloadSuccess) {
      return OrError.value(null);
    } else {
      if (res == DioDownloadStatus.imageNotFound) {
        String newExtension;
        if (download.extension.value == 'jpg') {
          newExtension = 'jpeg';
        } else if (download.extension.value == 'jpeg') {
          newExtension = 'jpg';
        } else {
          newExtension = 'jpg';
        }

        final url2 = _generateImageUrl(domain, index, download.slug.value,
            download.number.value, newExtension);
        final res2 = await downloadImage(
            path + '/image${index + 1}.' + newExtension, url2);
        if (res2 == DioDownloadStatus.downloadSuccess) {
          return OrError.value(null);
        } else {
          if (res2 == DioDownloadStatus.imageNotFound) {
            String newExtension2;
            if (download.extension.value == 'png') {
              newExtension2 = 'jpeg';
            } else {
              newExtension2 = 'png';
            }

            final url3 = _generateImageUrl(domain, index, download.slug.value,
                download.number.value, newExtension2);
            final res3 = await downloadImage(
                path + '/image${index + 1}.' + newExtension2, url3);

            return res3 == DioDownloadStatus.downloadSuccess
                ? OrError.value(null)
                : OrError.error(null);
          } else {
            return OrError.error(null);
          }
        }
      } else {
        return OrError.error(null);
      }
    }
  }

  Future<DioDownloadStatus> downloadImage(String path, String url) async {
    try {
      final res = await dio.download(url, path);
      return res.statusCode == 200
          ? DioDownloadStatus.downloadSuccess
          : DioDownloadStatus.someError;
    } on DioError catch (error) {
      print('dio error: ' + error.message);
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

  String _generateImageUrl(
      String domain, int index, String slug, String chapter, String extension) {
    return 'https://$domain/uploads/manga/$slug/chapters/$chapter/' +
        (index + 1 < 10 ? '0${index + 1}' : '${index + 1}') +
        '.$extension';
  }
}

class MockDownloadRepository extends DownloadRepository {
  @override
  Future<OrError<Null, Null>> download(
      DownloadCompanion download, String domain, int index) async {
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
