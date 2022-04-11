// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartAdapter extends TypeAdapter<Part> {
  @override
  final int typeId = 5;

  @override
  Part read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Part(
      locations: (fields[0] as List?)?.cast<String>(),
      id: fields[1] as String?,
      position: fields[2] as int?,
      hash: fields[3] as String?,
      size: fields[4] as int?,
      copyCount: fields[5] as int?,
      createdBy: fields[7] as String?,
      updatedBy: fields[8] as String?,
      createdAt: fields[9] as String?,
      tenant: fields[6] as String?,
      updatedAt: fields[10] as String?,
      v: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Part obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.locations)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.hash)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.copyCount)
      ..writeByte(6)
      ..write(obj.tenant)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.updatedBy)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
