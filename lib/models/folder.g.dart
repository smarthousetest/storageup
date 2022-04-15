// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderAdapter extends TypeAdapter<Folder> {
  @override
  final int typeId = 6;

  @override
  Folder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Folder(
      records: (fields[11] as List?)?.cast<Record>(),
      folders: (fields[12] as List?)?.cast<Folder>(),
      parentFolder: fields[16] as String?,
      size: fields[0] as int,
      id: fields[1] as String,
      favorite: fields[9] as bool,
      name: fields[2] as String?,
      createdBy: fields[3] as String?,
      updatedBy: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
      assetImage: fields[13] as String?,
      readOnly: fields[14] as bool?,
      isChoosed: fields[8] as bool,
      loadPercent: fields[10] as double?,
      isDownloading: fields[20] as bool?,
    )
      ..extension = fields[7] as String?
      ..isInProgress = fields[17] as bool
      ..endedWithException = fields[18] as bool
      ..copiedToAppFolder = fields[19] as bool;
  }

  @override
  void write(BinaryWriter writer, Folder obj) {
    writer
      ..writeByte(20)
      ..writeByte(11)
      ..write(obj.records)
      ..writeByte(12)
      ..write(obj.folders)
      ..writeByte(13)
      ..write(obj.assetImage)
      ..writeByte(14)
      ..write(obj.readOnly)
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
