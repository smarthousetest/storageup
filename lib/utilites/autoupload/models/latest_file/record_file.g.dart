// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordAdapter extends TypeAdapter<Record> {
  @override
  final int typeId = 4;

  @override
  Record read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Record(
      stored: (fields[0] as List?)?.cast<Part>(),
      path: fields[1] as String?,
      numOfParts: fields[2] as int?,
      thumbnail: (fields[3] as List?)?.cast<File>(),
      copyStatus: fields[4] as int?,
      isChoosed: fields[5] as bool?,
      loadPercent: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Record obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.stored)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.numOfParts)
      ..writeByte(3)
      ..write(obj.thumbnail)
      ..writeByte(4)
      ..write(obj.copyStatus)
      ..writeByte(5)
      ..write(obj.isChoosed)
      ..writeByte(6)
      ..write(obj.loadPercent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
