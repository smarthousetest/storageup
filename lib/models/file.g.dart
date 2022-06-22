// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileAdapter extends TypeAdapter<File> {
  @override
  final int typeId = 5;

  @override
  File read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return File(
      id: fields[0] as String?,
      createdAt: fields[1] as String?,
      updatedAt: fields[2] as String?,
      deletedAt: fields[3] as String?,
      createdBy: fields[4] as String?,
      updatedBy: fields[5] as String?,
      name: fields[6] as String?,
      sizeInBytes: fields[7] as int?,
      privateUrl: fields[8] as String?,
      publicUrl: fields[9] as String?,
      downloadUrl: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, File obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.deletedAt)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.updatedBy)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.sizeInBytes)
      ..writeByte(8)
      ..write(obj.privateUrl)
      ..writeByte(9)
      ..write(obj.publicUrl)
      ..writeByte(10)
      ..write(obj.downloadUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FileAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
