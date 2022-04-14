import 'package:hive/hive.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/record.dart';
part 'folder.g.dart';

@HiveType(typeId: 6)
class Folder extends BaseObject {
  @HiveField(11)
  List<Record>? records;
  @HiveField(12)
  List<Folder>? folders;
  @HiveField(13)
  String? assetImage;
  @HiveField(14)
  bool? readOnly;

  Folder({
    this.records,
    this.folders,
    String? parentFolder,
    required int size,
    required String id,
    bool favorite = false,
    String? name,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.assetImage,
    required this.readOnly,
    bool isChoosed = false,
    double? loadPercent,
    bool? isDownloading,
  }) : super(
            id: id,
            size: size,
            createdAt: createdAt,
            createdBy: createdBy,
            name: name,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            favorite: favorite,
            isChoosed: isChoosed,
            loadPercent: loadPercent,
            parentFolder: parentFolder,
            isDownloading: isDownloading);
  factory Folder.empty() => Folder(
        size: -1,
        id: '',
        readOnly: false,
        parentFolder: '',
      );

  @override
  String toString() {
    return 'Folder(records: $records, folders: $folders, size: $size, id: $id, name: $name, parentFolder: $parentFolder,  createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    List<Record>? rcrds;
    if (json['records'] != null) {
      rcrds = [];
      json['records'].forEach((v) {
        rcrds?.add(Record.fromJson(v));
      });
    }
    List<Folder>? fldrs;
    if (json['folders'] != null) {
      fldrs = [];
      json['folders'].forEach((v) {
        fldrs?.add(Folder.fromJson(v));
      });
    }
    return Folder(
      size: json['size'] as int,
      id: json['_id'] as String? ?? 'root',
      name: json['name'] as String?,
      records: rcrds,
      folders: fldrs,
      parentFolder: json['parentFolder'] as String? ?? 'root',
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      favorite: json['isFavorite'] as bool? ?? false,
      readOnly: json['readonly'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'records': records,
        'folders': folders,
        'size': size,
        '_id': id,
        'name': name,
        'parentFolder': parentFolder,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Folder copyWith({
    List<Record>? records,
    List<Folder>? folders,
    int? size,
    String? id,
    String? name,
    String? parentFolder,
    String? tenant,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? favorite,
    String? assetImage,
    bool? readOnly,
    bool? isChoosed,
    double? loadPercent,
    bool? isDownloading,
  }) {
    return Folder(
      records: records ?? this.records,
      folders: folders ?? this.folders,
      size: size ?? this.size,
      id: id ?? this.id,
      name: name ?? this.name,
      parentFolder: parentFolder ?? this.parentFolder,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      favorite: favorite ?? this.favorite,
      assetImage: assetImage,
      readOnly: readOnly ?? this.readOnly,
      isChoosed: isChoosed ?? this.isChoosed,
      loadPercent: loadPercent,
      isDownloading: isDownloading,
    );
  }

  Folder toHiveModel() {
    return Folder(
        size: size,
        id: id,
        name: name,
        parentFolder: parentFolder,
        createdBy: createdBy,
        updatedBy: updatedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
        favorite: favorite,
        assetImage: assetImage,
        readOnly: readOnly,
        isChoosed: isChoosed,
        loadPercent: loadPercent,
        isDownloading: isDownloading);
  }
  // @override
  // BaseObject copyWith(
  //     {int? size,
  //     String? id,
  //     String? name,
  //     String? createdBy,
  //     String? updatedBy,
  //     DateTime? createdAt,
  //     DateTime? updatedAt,
  //     String? extension,
  //     bool? isChoosed,
  //     bool? favorite}) {
  //   return super.copyWith(
  //     size: size,
  //     id: id,
  //     name: name,
  //     createdBy: createdBy,
  //     updatedBy: updatedBy,
  //     createdAt: createdAt,
  //     updatedAt: updatedAt,
  //     extension: extension,
  //     isChoosed: isChoosed,
  //     favorite: favorite,
  //   );
  // }

  // @override
  // bool operator ==(dynamic other) {
  //   if (identical(other, this)) return true;
  //   if (other is! Folder) return false;
  //   return other.size == size &&
  //       other.id == id &&
  //       other.name == name &&
  //       other.parentFolder == parentFolder &&
  //       other.createdBy == createdBy &&
  //       other.updatedBy == updatedBy &&
  //       other.createdAt == createdAt &&
  //       other.updatedAt == updatedAt &&
  //       other.id == id &&
  //       listEquals(other.records, records) &&
  //       listEquals(other.folders, folders);
  // }

  // @override
  // int get hashCode =>
  //     records.hashCode ^
  //     folders.hashCode ^
  //     size.hashCode ^
  //     id.hashCode ^
  //     name.hashCode ^
  //     parentFolder.hashCode ^
  //     createdBy.hashCode ^
  //     updatedBy.hashCode ^
  //     createdAt.hashCode ^
  //     updatedAt.hashCode;
  @override
  List<Object?> get props => [
        ...super.props,
        records,
        folders,
        parentFolder,
        assetImage,
        readOnly,
      ];
}
