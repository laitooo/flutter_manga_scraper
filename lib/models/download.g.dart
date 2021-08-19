// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DownloadData extends DataClass implements Insertable<DownloadData> {
  final String name;
  final String slug;
  final String number;
  final String cover;
  final bool hasCover;
  final bool isDownloading;
  final bool hasFailed;
  final int progress;
  final int images;
  final String extension;
  DownloadData(
      {this.name,
      this.slug,
      this.number,
      this.cover,
      this.hasCover,
      this.isDownloading,
      this.hasFailed,
      this.progress,
      this.images,
      this.extension});
  factory DownloadData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final intType = db.typeSystem.forDartType<int>();
    return DownloadData(
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      slug: stringType.mapFromDatabaseResponse(data['${effectivePrefix}slug']),
      number:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}number']),
      cover:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}cover']),
      hasCover:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}has_cover']),
      isDownloading: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_downloading']),
      hasFailed: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}has_failed']),
      progress:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}progress']),
      images: intType.mapFromDatabaseResponse(data['${effectivePrefix}images']),
      extension: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extension']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || slug != null) {
      map['slug'] = Variable<String>(slug);
    }
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    if (!nullToAbsent || hasCover != null) {
      map['has_cover'] = Variable<bool>(hasCover);
    }
    if (!nullToAbsent || isDownloading != null) {
      map['is_downloading'] = Variable<bool>(isDownloading);
    }
    if (!nullToAbsent || hasFailed != null) {
      map['has_failed'] = Variable<bool>(hasFailed);
    }
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<int>(progress);
    }
    if (!nullToAbsent || images != null) {
      map['images'] = Variable<int>(images);
    }
    if (!nullToAbsent || extension != null) {
      map['extension'] = Variable<String>(extension);
    }
    return map;
  }

  DownloadCompanion toCompanion(bool nullToAbsent) {
    return DownloadCompanion(
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      slug: slug == null && nullToAbsent ? const Value.absent() : Value(slug),
      number:
          number == null && nullToAbsent ? const Value.absent() : Value(number),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      hasCover: hasCover == null && nullToAbsent
          ? const Value.absent()
          : Value(hasCover),
      isDownloading: isDownloading == null && nullToAbsent
          ? const Value.absent()
          : Value(isDownloading),
      hasFailed: hasFailed == null && nullToAbsent
          ? const Value.absent()
          : Value(hasFailed),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      images:
          images == null && nullToAbsent ? const Value.absent() : Value(images),
      extension: extension == null && nullToAbsent
          ? const Value.absent()
          : Value(extension),
    );
  }

  factory DownloadData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DownloadData(
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      number: serializer.fromJson<String>(json['number']),
      cover: serializer.fromJson<String>(json['cover']),
      hasCover: serializer.fromJson<bool>(json['hasCover']),
      isDownloading: serializer.fromJson<bool>(json['isDownloading']),
      hasFailed: serializer.fromJson<bool>(json['hasFailed']),
      progress: serializer.fromJson<int>(json['progress']),
      images: serializer.fromJson<int>(json['images']),
      extension: serializer.fromJson<String>(json['extension']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'number': serializer.toJson<String>(number),
      'cover': serializer.toJson<String>(cover),
      'hasCover': serializer.toJson<bool>(hasCover),
      'isDownloading': serializer.toJson<bool>(isDownloading),
      'hasFailed': serializer.toJson<bool>(hasFailed),
      'progress': serializer.toJson<int>(progress),
      'images': serializer.toJson<int>(images),
      'extension': serializer.toJson<String>(extension),
    };
  }

  DownloadData copyWith(
          {String name,
          String slug,
          String number,
          String cover,
          bool hasCover,
          bool isDownloading,
          bool hasFailed,
          int progress,
          int images,
          String extension}) =>
      DownloadData(
        name: name ?? this.name,
        slug: slug ?? this.slug,
        number: number ?? this.number,
        cover: cover ?? this.cover,
        hasCover: hasCover ?? this.hasCover,
        isDownloading: isDownloading ?? this.isDownloading,
        hasFailed: hasFailed ?? this.hasFailed,
        progress: progress ?? this.progress,
        images: images ?? this.images,
        extension: extension ?? this.extension,
      );
  @override
  String toString() {
    return (StringBuffer('DownloadData(')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('number: $number, ')
          ..write('cover: $cover, ')
          ..write('hasCover: $hasCover, ')
          ..write('isDownloading: $isDownloading, ')
          ..write('hasFailed: $hasFailed, ')
          ..write('progress: $progress, ')
          ..write('images: $images, ')
          ..write('extension: $extension')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      name.hashCode,
      $mrjc(
          slug.hashCode,
          $mrjc(
              number.hashCode,
              $mrjc(
                  cover.hashCode,
                  $mrjc(
                      hasCover.hashCode,
                      $mrjc(
                          isDownloading.hashCode,
                          $mrjc(
                              hasFailed.hashCode,
                              $mrjc(
                                  progress.hashCode,
                                  $mrjc(images.hashCode,
                                      extension.hashCode))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DownloadData &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.number == this.number &&
          other.cover == this.cover &&
          other.hasCover == this.hasCover &&
          other.isDownloading == this.isDownloading &&
          other.hasFailed == this.hasFailed &&
          other.progress == this.progress &&
          other.images == this.images &&
          other.extension == this.extension);
}

class DownloadCompanion extends UpdateCompanion<DownloadData> {
  final Value<String> name;
  final Value<String> slug;
  final Value<String> number;
  final Value<String> cover;
  final Value<bool> hasCover;
  final Value<bool> isDownloading;
  final Value<bool> hasFailed;
  final Value<int> progress;
  final Value<int> images;
  final Value<String> extension;
  const DownloadCompanion({
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.number = const Value.absent(),
    this.cover = const Value.absent(),
    this.hasCover = const Value.absent(),
    this.isDownloading = const Value.absent(),
    this.hasFailed = const Value.absent(),
    this.progress = const Value.absent(),
    this.images = const Value.absent(),
    this.extension = const Value.absent(),
  });
  DownloadCompanion.insert({
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.number = const Value.absent(),
    this.cover = const Value.absent(),
    this.hasCover = const Value.absent(),
    this.isDownloading = const Value.absent(),
    this.hasFailed = const Value.absent(),
    this.progress = const Value.absent(),
    this.images = const Value.absent(),
    this.extension = const Value.absent(),
  });
  static Insertable<DownloadData> custom({
    Expression<String> name,
    Expression<String> slug,
    Expression<String> number,
    Expression<String> cover,
    Expression<bool> hasCover,
    Expression<bool> isDownloading,
    Expression<bool> hasFailed,
    Expression<int> progress,
    Expression<int> images,
    Expression<String> extension,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (number != null) 'number': number,
      if (cover != null) 'cover': cover,
      if (hasCover != null) 'has_cover': hasCover,
      if (isDownloading != null) 'is_downloading': isDownloading,
      if (hasFailed != null) 'has_failed': hasFailed,
      if (progress != null) 'progress': progress,
      if (images != null) 'images': images,
      if (extension != null) 'extension': extension,
    });
  }

  DownloadCompanion copyWith(
      {Value<String> name,
      Value<String> slug,
      Value<String> number,
      Value<String> cover,
      Value<bool> hasCover,
      Value<bool> isDownloading,
      Value<bool> hasFailed,
      Value<int> progress,
      Value<int> images,
      Value<String> extension}) {
    return DownloadCompanion(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      number: number ?? this.number,
      cover: cover ?? this.cover,
      hasCover: hasCover ?? this.hasCover,
      isDownloading: isDownloading ?? this.isDownloading,
      hasFailed: hasFailed ?? this.hasFailed,
      progress: progress ?? this.progress,
      images: images ?? this.images,
      extension: extension ?? this.extension,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (hasCover.present) {
      map['has_cover'] = Variable<bool>(hasCover.value);
    }
    if (isDownloading.present) {
      map['is_downloading'] = Variable<bool>(isDownloading.value);
    }
    if (hasFailed.present) {
      map['has_failed'] = Variable<bool>(hasFailed.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (images.present) {
      map['images'] = Variable<int>(images.value);
    }
    if (extension.present) {
      map['extension'] = Variable<String>(extension.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadCompanion(')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('number: $number, ')
          ..write('cover: $cover, ')
          ..write('hasCover: $hasCover, ')
          ..write('isDownloading: $isDownloading, ')
          ..write('hasFailed: $hasFailed, ')
          ..write('progress: $progress, ')
          ..write('images: $images, ')
          ..write('extension: $extension')
          ..write(')'))
        .toString();
  }
}

class $DownloadTable extends Download
    with TableInfo<$DownloadTable, DownloadData> {
  final GeneratedDatabase _db;
  final String _alias;
  $DownloadTable(this._db, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _slugMeta = const VerificationMeta('slug');
  GeneratedTextColumn _slug;
  @override
  GeneratedTextColumn get slug => _slug ??= _constructSlug();
  GeneratedTextColumn _constructSlug() {
    return GeneratedTextColumn(
      'slug',
      $tableName,
      true,
    );
  }

  final VerificationMeta _numberMeta = const VerificationMeta('number');
  GeneratedTextColumn _number;
  @override
  GeneratedTextColumn get number => _number ??= _constructNumber();
  GeneratedTextColumn _constructNumber() {
    return GeneratedTextColumn(
      'number',
      $tableName,
      true,
    );
  }

  final VerificationMeta _coverMeta = const VerificationMeta('cover');
  GeneratedTextColumn _cover;
  @override
  GeneratedTextColumn get cover => _cover ??= _constructCover();
  GeneratedTextColumn _constructCover() {
    return GeneratedTextColumn(
      'cover',
      $tableName,
      true,
    );
  }

  final VerificationMeta _hasCoverMeta = const VerificationMeta('hasCover');
  GeneratedBoolColumn _hasCover;
  @override
  GeneratedBoolColumn get hasCover => _hasCover ??= _constructHasCover();
  GeneratedBoolColumn _constructHasCover() {
    return GeneratedBoolColumn(
      'has_cover',
      $tableName,
      true,
    );
  }

  final VerificationMeta _isDownloadingMeta =
      const VerificationMeta('isDownloading');
  GeneratedBoolColumn _isDownloading;
  @override
  GeneratedBoolColumn get isDownloading =>
      _isDownloading ??= _constructIsDownloading();
  GeneratedBoolColumn _constructIsDownloading() {
    return GeneratedBoolColumn(
      'is_downloading',
      $tableName,
      true,
    );
  }

  final VerificationMeta _hasFailedMeta = const VerificationMeta('hasFailed');
  GeneratedBoolColumn _hasFailed;
  @override
  GeneratedBoolColumn get hasFailed => _hasFailed ??= _constructHasFailed();
  GeneratedBoolColumn _constructHasFailed() {
    return GeneratedBoolColumn(
      'has_failed',
      $tableName,
      true,
    );
  }

  final VerificationMeta _progressMeta = const VerificationMeta('progress');
  GeneratedIntColumn _progress;
  @override
  GeneratedIntColumn get progress => _progress ??= _constructProgress();
  GeneratedIntColumn _constructProgress() {
    return GeneratedIntColumn(
      'progress',
      $tableName,
      true,
    );
  }

  final VerificationMeta _imagesMeta = const VerificationMeta('images');
  GeneratedIntColumn _images;
  @override
  GeneratedIntColumn get images => _images ??= _constructImages();
  GeneratedIntColumn _constructImages() {
    return GeneratedIntColumn(
      'images',
      $tableName,
      true,
    );
  }

  final VerificationMeta _extensionMeta = const VerificationMeta('extension');
  GeneratedTextColumn _extension;
  @override
  GeneratedTextColumn get extension => _extension ??= _constructExtension();
  GeneratedTextColumn _constructExtension() {
    return GeneratedTextColumn(
      'extension',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        name,
        slug,
        number,
        cover,
        hasCover,
        isDownloading,
        hasFailed,
        progress,
        images,
        extension
      ];
  @override
  $DownloadTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'download';
  @override
  final String actualTableName = 'download';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug'], _slugMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number'], _numberMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover'], _coverMeta));
    }
    if (data.containsKey('has_cover')) {
      context.handle(_hasCoverMeta,
          hasCover.isAcceptableOrUnknown(data['has_cover'], _hasCoverMeta));
    }
    if (data.containsKey('is_downloading')) {
      context.handle(
          _isDownloadingMeta,
          isDownloading.isAcceptableOrUnknown(
              data['is_downloading'], _isDownloadingMeta));
    }
    if (data.containsKey('has_failed')) {
      context.handle(_hasFailedMeta,
          hasFailed.isAcceptableOrUnknown(data['has_failed'], _hasFailedMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress'], _progressMeta));
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images'], _imagesMeta));
    }
    if (data.containsKey('extension')) {
      context.handle(_extensionMeta,
          extension.isAcceptableOrUnknown(data['extension'], _extensionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slug, number};
  @override
  DownloadData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DownloadData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DownloadTable createAlias(String alias) {
    return $DownloadTable(_db, alias);
  }
}

abstract class _$MoorDatabase extends GeneratedDatabase {
  _$MoorDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $DownloadTable _download;
  $DownloadTable get download => _download ??= $DownloadTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [download];
}
