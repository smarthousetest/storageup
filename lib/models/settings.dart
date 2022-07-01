import 'package:storageup/models/file.dart';

class Settings {
  String? sId;
  String? theme;
  String? tenant;
  String? createdBy;
  List<File>? backgroundImages;
  List<File>? logos;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  Settings({
    this.sId,
    this.theme,
    this.tenant,
    this.createdBy,
    this.backgroundImages,
    this.logos,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.id,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    theme = json['theme'];
    tenant = json['tenant'];
    createdBy = json['createdBy'];
    if (json['backgroundImages'] != null) {
      backgroundImages = [];
      json['backgroundImages'].forEach((v) {
        backgroundImages?.add(File.fromJson(v));
      });
    }
    if (json['logos'] != null) {
      logos = [];
      json['logos'].forEach((v) {
        logos?.add(File.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['theme'] = this.theme;
    data['tenant'] = this.tenant;
    data['createdBy'] = this.createdBy;
    if (this.backgroundImages != null) {
      data['backgroundImages'] = this.backgroundImages?.map((v) => v.toJson()).toList();
    }
    if (this.logos != null) {
      data['logos'] = this.logos?.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
