// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UploadMediaAdapter extends TypeAdapter<UploadMedia> {
  @override
  final int typeId = 1;

  @override
  UploadMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UploadMedia(
      nativeStorageId: fields[0] as String,
      state: fields[3] as AutouploadState,
      name: fields[1] as String?,
      serverId: fields[2] as String?,
      uploadPercent: fields[4] as int?,
      localPath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UploadMedia obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nativeStorageId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.serverId)
      ..writeByte(3)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.uploadPercent)
      ..writeByte(5)
      ..write(obj.localPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
