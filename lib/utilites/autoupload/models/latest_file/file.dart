import 'package:hive/hive.dart';
part 'file.g.dart';

@HiveType(typeId: 6)
class File extends HiveObject {
  @HiveField(0)
  String? id;
  String? createdAt;
  @HiveField(1)
  String? updatedAt;
  @HiveField(2)
  String? deletedAt;
  @HiveField(3)
  String? createdBy;
  @HiveField(4)
  String? updatedBy;
  @HiveField(5)
  String? name;
  @HiveField(6)
  int? sizeInBytes;
  @HiveField(7)
  String? privateUrl;
  @HiveField(8)
  String? publicUrl;
  @HiveField(9)
  String? downloadUrl;

  File({
    this.createdAt,
    String? id,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.name,
    this.sizeInBytes,
    this.privateUrl,
    this.publicUrl,
    this.downloadUrl,
  });

  File copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? createdBy,
    String? updatedBy,
    String? name,
    int? sizeInBytes,
    String? privateUrl,
    String? publicUrl,
    String? downloadUrl,
  }) {
    return File(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      name: name ?? this.name,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      privateUrl: privateUrl ?? this.privateUrl,
      publicUrl: publicUrl ?? this.publicUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }

  @override
  String toString() {
    return 'createdAt: $createdAt,  id: $id, updatedAt: $updatedAt, deletedAt: $deletedAt, createdBy: $createdBy, updatedBy: $updatedBy, name: $name,  sizeInBytes: $sizeInBytes,  privateUrl: $privateUrl, publicUrl: $publicUrl ,  downloadUrl: $downloadUrl';
  }
}
