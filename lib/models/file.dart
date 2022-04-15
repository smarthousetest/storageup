import 'package:hive/hive.dart';

part 'file.g.dart';

@HiveType(typeId: 5)
class File {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? createdAt;
  @HiveField(2)
  String? updatedAt;
  @HiveField(3)
  String? deletedAt;
  @HiveField(4)
  String? createdBy;
  @HiveField(5)
  String? updatedBy;
  @HiveField(6)
  String? name;
  @HiveField(7)
  int? sizeInBytes;
  @HiveField(8)
  String? privateUrl;
  @HiveField(9)
  String? publicUrl;
  @HiveField(10)
  String? downloadUrl;

  File({
    this.id,
    this.createdAt,
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

  File.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    name = json['name'];
    sizeInBytes = json['sizeInBytes'];
    privateUrl = json['privateUrl'];
    publicUrl = json['publicUrl'];
    downloadUrl = json['downloadUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['name'] = this.name;
    data['sizeInBytes'] = this.sizeInBytes;
    data['privateUrl'] = this.privateUrl;
    data['publicUrl'] = this.publicUrl;
    data['downloadUrl'] = this.downloadUrl;
    return data;
  }
}
