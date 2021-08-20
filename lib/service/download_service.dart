import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/repositories/download_repo.dart';
import 'package:manga_scraper/repositories/downloads_list_repo.dart';
import 'package:manga_scraper/utils/dio.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:moor/moor.dart';

Future<void> onStart() async {
  final List<DownloadCompanion> chapters = [];
  final database = MoorDatabase(openConnection());
  final _downloadListRepo = Features.isMockMoor
      ? MockDownloadsListRepository()
      : MoorDownloadsListRepository(database);

  print('download service on Start');
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) async {
    if (event['action'] == ServiceDownloadAction.foregroundMode.toText()) {
      service.setForegroundMode(true);
    }

    if (event['action'] == ServiceDownloadAction.backgroundMode.toText()) {
      service.setForegroundMode(false);
    }

    if (event['action'] == ServiceDownloadAction.stopService.toText()) {
      service.stopBackgroundService();
    }

    if (event['action'] == ServiceDownloadAction.addDownload.toText()) {
      DownloadData download = DownloadData.fromJson(event['download']);
      final res = await _downloadListRepo.get(download.slug, download.number);
      if (res.isValue) {
        download = res.asValue;
      }

      if (download.progress == download.images) {
        service.sendData({
          'status': UiDownloadAction.alreadyDownloaded.toText(),
          'slug': download.slug,
          'number': download.number,
          'dialog': true,
        });
      } else {
        chapters.add(download.toCompanion(false));
        if (chapters.length == 1) {
          _startDownloading(chapters, service, database);
        } else {
          service.sendData({
            'status': UiDownloadAction.addedToQueue.toText(),
            'slug': download.slug,
            'number': download.number,
            'dialog': true,
          });
        }
      }
    }

    if (event['action'] == ServiceDownloadAction.streamDownloads.toText()) {
      final list = await _downloadListRepo.load();
      if (list.isValue) {
        service.sendData({
          'status': UiDownloadAction.streamingDownloads.toText(),
          'list': list.asValue.map((e) => e.toJson()).toList(),
          'dialog': false,
        });
      } else {
        service.sendData({
          'status': UiDownloadAction.errorStreaming.toText(),
          'dialog': false,
        });
      }
    }

    if (event['action'] == ServiceDownloadAction.deleteDownload.toText()) {
      final download = DownloadData.fromJson(event['download']);
      final res = await _downloadListRepo.delete(download);
      if (res.isValue) {
        service.sendData({
          'status': UiDownloadAction.deletedDownload.toText(),
          'slug': download.slug,
          'number': download.number,
          'dialog': false,
        });
      } else {
        service.sendData({
          'status': UiDownloadAction.errorDeleting.toText(),
          'dialog': false,
        });
      }
    }

    if (event['action'] == ServiceDownloadAction.deleteDownloads.toText()) {
      final downloads =
          (event['list'] as List).map((e) => DownloadData.fromJson(e)).toList();
      final res = await _downloadListRepo.deleteList(downloads);
      if (res.isValue) {
        service.sendData({
          'status': UiDownloadAction.deletedDownloads.toText(),
          'list': downloads.map((e) => e.toJson()).toList(),
          'dialog': false,
        });
      } else {
        service.sendData({
          'status': UiDownloadAction.errorDeleting.toText(),
          'dialog': false,
        });
      }
    }
  });
  service.setForegroundMode(false);
}

void _startDownloading(
  List<DownloadCompanion> chapters,
  FlutterBackgroundService service,
  MoorDatabase database,
) async {
  DownloadCompanion current = chapters[0];
  final _repo = Features.isMockDio
      ? MockDownloadRepository()
      : DioDownloadRepository(DioFactory.withDefaultInterceptors());
  final _downloadListRepo = Features.isMockMoor
      ? MockDownloadsListRepository()
      : MoorDownloadsListRepository(database);

  service.setForegroundMode(true);
  service.setNotificationInfo(
    title: current.name.value + ' ch. ' + current.number.value,
    content: "Loading manga details",
  );

  print('download service : downloading manga ${current.name.value} chapter '
      '${current.number.value}');

  current = current.copyWith(
    isDownloading: Value(true),
  );
  await _downloadListRepo.save(current);

  final json = DownloadData(
    cover: current.cover.value,
    slug: current.slug.value,
    name: current.name.value,
    number: current.number.value,
    volume: current.volume.value,
    progress: current.progress.value,
    isDownloading: current.isDownloading.value,
    images: current.images.value,
    hasFailed: current.hasFailed.value,
    hasCover: current.hasCover.value,
    first: current.first.value,
  ).toJson();
  service.sendData({
    'status': UiDownloadAction.startedDownload.toText(),
    'download': json,
    'dialog': false,
  });

  final res = await _repo.saveCover(current);
  int progress = 0;
  if (res.isValue) {
    current = current.copyWith(
      hasCover: Value(true),
    );
    await _downloadListRepo.update(current);
    print('cover saved');

    for (int i = 0; i < current.images.value; i++) {
      final res = await _repo.download(current, i);
      if (res.isValue) {
        progress++;
        service.sendData({
          'status': UiDownloadAction.progressUpdate.toText(),
          'slug': current.slug.value,
          'number': current.number.value,
          'progress': progress,
          'dialog': true,
        });
        service.sendData({
          'status': UiDownloadAction.progressUpdate.toText(),
          'slug': current.slug.value,
          'number': current.number.value,
          'progress': progress,
          'dialog': false,
        });
        service.setNotificationInfo(
          title: current.name.value + ' ch. ' + current.number.value,
          content: "progress $progress / ${current.images.value}",
        );
        current = current.copyWith(
          progress: Value(progress),
        );
        await _downloadListRepo.update(current);
      } else {
        service.sendData({
          'status': UiDownloadAction.downloadFailed.toText(),
          'slug': current.slug.value,
          'number': current.number.value,
          'dialog': true,
        });
        service.sendData({
          'status': UiDownloadAction.downloadFailed.toText(),
          'slug': current.slug.value,
          'number': current.number.value,
          'dialog': false,
        });
        service.setNotificationInfo(
          title: current.name.value + ' ch. ' + current.number.value,
          content: "download failed",
        );
        current = current.copyWith(
          isDownloading: Value(false),
          hasFailed: Value(true),
        );
        await _downloadListRepo.update(current);
        break;
      }
    }
    if (progress == current.images.value) {
      service.sendData({
        'status': UiDownloadAction.downloadCompleted.toText(),
        'slug': current.slug.value,
        'number': current.number.value,
        'dialog': false,
      });
      service.sendData({
        'status': UiDownloadAction.downloadCompleted.toText(),
        'slug': current.slug.value,
        'number': current.number.value,
        'dialog': true,
      });
      service.setNotificationInfo(
        title: current.name.value + ' ch. ' + current.number.value,
        content: "download completed",
      );
      current = current.copyWith(
        isDownloading: Value(false),
      );
      await _downloadListRepo.update(current);
      print(
          'download service : downloaded completed manga ${current.name.value} '
          'chapter ${current.number.value}');
      await Future.delayed(Duration(seconds: 5));
    }
  } else {
    service.sendData({
      'status': UiDownloadAction.downloadFailed.toText(),
      'slug': current.slug.value,
      'number': current.number.value,
      'dialog': false,
    });
    service.sendData({
      'status': UiDownloadAction.downloadFailed.toText(),
      'slug': current.slug.value,
      'number': current.number.value,
      'dialog': true,
    });
    service.setNotificationInfo(
      title: current.name.value + ' ch. ' + current.number.value,
      content: "download failed",
    );
    current = current.copyWith(
      isDownloading: Value(false),
      hasFailed: Value(true),
    );
    await _downloadListRepo.update(current);
  }
  chapters.removeAt(0);
  if (chapters.isNotEmpty) {
    _startDownloading(chapters, service, database);
  } else {
    service.setForegroundMode(false);
  }
}
