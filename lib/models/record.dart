import 'package:flutter/foundation.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/file.dart';

import 'stored.dart';

class Record extends BaseObject {
  final List<Part>? stored;
  // @override
  // String? get id => super.id;
  // @override
  // String? get name => super.name;
  String? path;
  final int? numOfParts;
  final List<File>? thumbnail;
  final int? copyStatus;
  // @override
  // int? get size => super.size;
  // @override
  // String? get createdAt => super.createdAt;
  // @override
  // String? get createdBy => super.createdBy;

  // @override
  // String? get updatedAt => super.updatedAt;
  // @override
  // String? get updatedBy => super.updatedBy;
  // final String? extension;
  bool isChoosed;
  double? loadPercent;

  Record({
    this.stored,
    required String id,
    String? name,
    this.path,
    this.numOfParts,
    this.thumbnail,
    required int size,
    this.copyStatus,
    bool favorite = false,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? extension,
    this.isChoosed = false,
    this.loadPercent,
  }) : super(
          id: id,
          size: size,
          name: name,
          createdAt: createdAt,
          createdBy: createdBy,
          updatedAt: updatedAt,
          updatedBy: updatedBy,
          extension: extension,
          favorite: favorite,
          isChoosed: isChoosed,
        );

  @override
  String toString() {
    return 'Record(stored: $stored, id: $id, name: $name, path: $path, numOfParts: $numOfParts, thumbnail: $thumbnail, size: $size, copyStatus: $copyStatus, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  static Record fromJsonModel(Map<String, dynamic> json) =>
      Record.fromJson(json);

  factory Record.empty() => Record(id: '', size: 0);

  factory Record.fromJson(Map<String, dynamic> json) {
    var name = json['name'] as String?;
    // List<File> thumbnail = [];
    // if (json['thumbnail'] != null) {
    //   json['thumbnail'].forEach((e) {
    //     thumbnail.add(File.fromJson(e));
    //   });
    // }
    // var
    return Record(
        stored: (json['stored'] as List<dynamic>?)
            ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
            .toList(),
        id: json['_id'] as String,
        name: name,
        path: json['path'] as String?,
        numOfParts: json['numOfParts'] as int?,
        thumbnail: (json['thumbnail'] as List<dynamic>?)
            ?.map((e) => File.fromJson(e as Map<String, dynamic>))
            .toList(),
        size: json['size'] as int,
        copyStatus: json['copyStatus'] as int?,
        createdBy: json['createdBy'] as String?,
        updatedBy: json['updatedBy'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
        favorite: json['isFavorite'] as bool,
        extension: name?.split('.').last);
  }

  Map<String, dynamic> toJson() => {
        'stored': stored?.map((e) => e.toJson()).toList(),
        '_id': id,
        'name': name,
        'path': path,
        'numOfParts': numOfParts,
        'thumbnail': thumbnail,
        'size': size,
        'copyStatus': copyStatus,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Record copyWith({
    List<Part>? stored,
    String? name,
    String? path,
    int? numOfParts,
    List<File>? thumbnail,
    int? size,
    int? copyStatus,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isChoosed,
    double? loadPercent,
  }) {
    var extention =
        name != null ? name.split('.').last : this.name?.split('.').last;
    return Record(
      stored: stored ?? this.stored,
      id: this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      numOfParts: numOfParts ?? this.numOfParts,
      thumbnail: thumbnail ?? this.thumbnail,
      size: size ?? this.size,
      copyStatus: copyStatus ?? this.copyStatus,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      extension: extention ?? this.extension,
      isChoosed: isChoosed ?? this.isChoosed,
      loadPercent: loadPercent,
    );
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(other, this)) return true;
  //   return other is Record &&
  //       other.thumbnail == thumbnail &&
  //       other.id == id &&
  //       other.name == name &&
  //       other.path == path &&
  //       other.numOfParts == numOfParts &&
  //       other.size == size &&
  //       other.copyStatus == copyStatus &&
  //       other.createdBy == createdBy &&
  //       other.updatedBy == updatedBy &&
  //       other.createdAt == createdAt &&
  //       other.updatedAt == updatedAt &&
  //       other.id == id &&
  //       other.loadPercent == loadPercent &&
  //       listEquals(other.stored, stored);
  // }

  // @override
  // int get hashCode =>
  //     stored.hashCode ^
  //     id.hashCode ^
  //     name.hashCode ^
  //     path.hashCode ^
  //     numOfParts.hashCode ^
  //     thumbnail.hashCode ^
  //     size.hashCode ^
  //     copyStatus.hashCode ^
  //     createdBy.hashCode ^
  //     updatedBy.hashCode ^
  //     createdAt.hashCode ^
  //     updatedAt.hashCode ^
  //     id.hashCode;

  @override
  List<Object?> get props => [
        ...super.props,
        stored,
        path,
        numOfParts,
        thumbnail,
        copyStatus,
        loadPercent,
        isChoosed,
      ];
}
