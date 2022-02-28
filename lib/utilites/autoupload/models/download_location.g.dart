// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadLocationAdapter extends TypeAdapter<DownloadLocation> {
  @override
  final int typeId = 2;

  @override
  DownloadLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadLocation(
      dirPath: fields[0] as String,
      countGb: fields[1] as int,
      id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dirPath)
      ..writeByte(1)
      ..write(obj.countGb)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
