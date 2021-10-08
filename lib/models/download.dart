import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'download.g.dart';

class Download extends Table {
  TextColumn get name => text().nullable()();
  TextColumn get slug => text().nullable()();
  TextColumn get number => text().nullable()();
  TextColumn get cover => text().nullable()();
  BoolColumn get hasCover => boolean().nullable()();
  BoolColumn get isDownloading => boolean().nullable()();
  BoolColumn get hasFailed => boolean().nullable()();
  IntColumn get progress => integer().nullable()();
  IntColumn get images => integer().nullable()();
  TextColumn get volume => text().nullable()();
  TextColumn get first => text().nullable()();

  @override
  Set<Column> get primaryKey => {slug, number};
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(
  tables: [Download],
)
class MoorDatabase extends _$MoorDatabase {
  MoorDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  Stream<List<DownloadData>> watchDownloads() {
    return select(download).watch();
  }

  Future<List<DownloadData>> loadDownloads() {
    return select(download).get();
  }

  saveDownload(DownloadCompanion entry) {
    return (into(download).insert(entry));
  }

  updateDownload(DownloadCompanion entry) {
    return (update(download)
      ..where((tbl) => tbl.slug.equals(entry.slug.value))
      ..where((tbl) => tbl.number.equals(entry.number.value))
      ..write(
        DownloadCompanion(
          progress: Value(entry.progress.value),
          isDownloading: Value(entry.isDownloading.value),
          hasFailed: Value(entry.hasFailed.value),
          hasCover: Value(entry.hasCover.value),
        ),
      ));
  }

  deleteDownload(DownloadData entity) {
    return (delete(download).delete(entity));
  }

  deleteDownloadByKeys(String slug, String number) {
    return (delete(download)
      ..where((tbl) => tbl.slug.equals(slug))
      ..where((tbl) => tbl.number.equals(number))
      ..go());
  }

  clearDownloads() {
    return delete(download).go();
  }

  Future<bool> isDownloaded(String slug, String number) async {
    final ll = await (select(download)
          ..where((tbl) => tbl.slug.equals(slug))
          ..where((tbl) => tbl.number.equals(number))
          ..where((tbl) => tbl.hasFailed.equals(false)))
        .get();
    if (ll.length == 1) {
      return ll[0].progress == ll[0].images;
    }
    return false;
  }

  Future<bool> exists(String slug, String number) async {
    final ll = await (select(download)
          ..where((tbl) => tbl.slug.equals(slug))
          ..where((tbl) => tbl.number.equals(number)))
        .get();
    return ll.isNotEmpty;
  }

  Future<DownloadData> getDownload(String slug, String number) async {
    final ll = await (select(download)
          ..where((tbl) => tbl.slug.equals(slug))
          ..where((tbl) => tbl.number.equals(number)))
        .getSingle();
    return ll;
  }
}
