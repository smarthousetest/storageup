// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LatestFileAdapter extends TypeAdapter<LatestFile> {
  @override
  final int typeId = 3;

  @override
  LatestFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatestFile(
      latestFile: fields[0] as Record,
    );
  }

  @override
  void write(BinaryWriter writer, LatestFile obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.latestFile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatestFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
