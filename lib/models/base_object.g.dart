// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseObjectAdapter extends TypeAdapter<BaseObject> {
  @override
  final int typeId = 4;

  @override
  BaseObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseObject(
      size: fields[0] as int,
      createdAt: fields[5] as DateTime?,
      createdBy: fields[3] as String?,
      id: fields[1] as String,
      name: fields[2] as String?,
      updatedAt: fields[6] as DateTime?,
      updatedBy: fields[4] as String?,
      extension: fields[7] as String?,
      isChoosed: fields[8] as bool,
      favorite: fields[9] as bool,
      loadPercent: fields[10] as double?,
      parentFolder: fields[16] as String?,
      copiedToAppFolder: fields[19] as bool,
      endedWithException: fields[18] as bool,
      isInProgress: fields[17] as bool,
      isDownloading: fields[20] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, BaseObject obj) {
    writer
      ..writeByte(16)
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
      other is BaseObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
