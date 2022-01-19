import 'package:hive/hive.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/upload_state.dart';

part 'upload_media.g.dart';

@HiveType(typeId: 1)
class UploadMedia {
  @HiveField(0)
  String nativeStorageId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? serverId;
  @HiveField(3)
  AutouploadState state;
  @HiveField(4)
  int? uploadPercent;
  @HiveField(5)
  String? localPath;

  UploadMedia({
    required this.nativeStorageId,
    required this.state,
    this.name,
    this.serverId,
    this.uploadPercent,
    this.localPath,
  });

  UploadMedia copyWith({
    String? nativeStorageId,
    String? name,
    String? serverId,
    AutouploadState? state,
    int? uploadPercent,
    String? localPath,
  }) {
    return UploadMedia(
      nativeStorageId: nativeStorageId ?? this.nativeStorageId,
      state: state ?? this.state,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      uploadPercent: uploadPercent ?? this.uploadPercent,
      localPath: localPath ?? this.localPath,
    );
  }

  @override
  String toString() {
    return 'nativeStorageId: $nativeStorageId, name: $name, uploadPercent: $uploadPercent, serverId: $serverId, state: $state';
  }
}
