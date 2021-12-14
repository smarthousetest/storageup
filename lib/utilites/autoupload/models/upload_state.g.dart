// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AutouploadStateAdapter extends TypeAdapter<AutouploadState> {
  @override
  final int typeId = 0;

  @override
  AutouploadState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AutouploadState.inProgress;
      case 1:
        return AutouploadState.endedWithException;
      case 2:
        return AutouploadState.endedWithoutException;
      case 3:
        return AutouploadState.notSended;
      default:
        return AutouploadState.inProgress;
    }
  }

  @override
  void write(BinaryWriter writer, AutouploadState obj) {
    switch (obj) {
      case AutouploadState.inProgress:
        writer.writeByte(0);
        break;
      case AutouploadState.endedWithException:
        writer.writeByte(1);
        break;
      case AutouploadState.endedWithoutException:
        writer.writeByte(2);
        break;
      case AutouploadState.notSended:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutouploadStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
