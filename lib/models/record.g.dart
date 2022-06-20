// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordAdapter extends TypeAdapter<Record> {
  @override
  final int typeId = 7;

  @override
  Record read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Record(
      id: fields[1] as String,
      name: fields[2] as String?,
      path: fields[11] as String?,
      thumbnail: (fields[12] as List?)?.cast<File>(),
      size: fields[0] as int,
      favorite: fields[9] as bool,
      createdBy: fields[3] as String?,
      updatedBy: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
      extension: fields[7] as String?,
      isChoosed: fields[8] as bool,
      loadPercent: fields[10] as double?,
      copiedToAppFolder: fields[19] as bool,
      endedWithException: fields[18] as bool,
      isInProgress: fields[17] as bool,
      mimeType: fields[14] as String?,
      isDownloading: fields[20] as bool?,
      accessDate: fields[13] as DateTime?,
    )..parentFolder = fields[16] as String?;
  }

  @override
  void write(BinaryWriter writer, Record obj) {
    writer
      ..writeByte(20)
      ..writeByte(11)
      ..write(obj.path)
      ..writeByte(12)
      ..write(obj.thumbnail)
      ..writeByte(13)
      ..write(obj.accessDate)
      ..writeByte(14)
      ..write(obj.mimeType)
      ..writeByte(0)
      ..write(obj.size)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.updatedBy)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.extension)
      ..writeByte(8)
      ..write(obj.isChoosed)
      ..writeByte(9)
      ..write(obj.favorite)
      ..writeByte(10)
      ..write(obj.loadPercent)
      ..writeByte(16)
      ..write(obj.parentFolder)
      ..writeByte(17)
      ..write(obj.isInProgress)
      ..writeByte(18)
      ..write(obj.endedWithException)
      ..writeByte(19)
      ..write(obj.copiedToAppFolder)
      ..writeByte(20)
      ..write(obj.isDownloading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecordAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
