// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_chapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchedChapterAdapter extends TypeAdapter<WatchedChapter> {
  @override
  final int typeId = 3;

  @override
  WatchedChapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchedChapter(
      slug: fields[0] as String,
      number: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WatchedChapter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
