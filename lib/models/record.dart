import 'package:hive/hive.dart';
import 'package:storageup/models/base_object.dart';
import 'package:storageup/models/file.dart';

import 'stored.dart';

part 'record.g.dart';

@HiveType(typeId: 7)
class Record extends BaseObject {
  @HiveField(11)
  String? path;

  @HiveField(12)
  final List<File>? thumbnail;

  @HiveField(13)
  DateTime? accessDate;

  @HiveField(14)
  String? mimeType;

  Record(
      {required String id,
      String? name,
      this.path,
      this.thumbnail,
      required int size,
      bool favorite = false,
      String? folder,
      String? createdBy,
      String? updatedBy,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? extension,
      bool isChoosed = false,
      double? loadPercent,
      bool copiedToAppFolder = false,
      bool endedWithException = false,
      bool isInProgress = false,
      required this.mimeType,
      bool? isDownloading,
      this.accessDate})
      : super(
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
          loadPercent: loadPercent,
          parentFolder: folder,
          copiedToAppFolder: copiedToAppFolder,
          endedWithException: endedWithException,
          isInProgress: isInProgress,
          isDownloading: isDownloading,
        );

  @override
  String toString() {
    return 'Record(id: $id, isChoosed: $isChoosed, name: $name, path: $path, thumbnail: $thumbnail, size: $size, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  static Record fromJsonModel(Map<String, dynamic> json) =>
      Record.fromJson(json);

  factory Record.empty() => Record(id: '', size: 0, mimeType: '');

  factory Record.fromJson(Map<String, dynamic> json) {
    var name = json['name'] as String?;

    return Record(
      id: json['id'] as String,
      name: name,
      path: json['path'] as String?,
      // numOfParts: json['numOfParts'] as int?,
      thumbnail: (json['thumbnail'] as List<dynamic>?)
          ?.map((e) => File.fromJson(e as Map<String, dynamic>))
          .toList(),
      size: json['size'] as int,
      // copyStatus: json['copyStatus'] as int?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      folder: json['folder'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      favorite: json['favorite'] as bool? ?? false,
      extension: name?.split('.').last,
      mimeType: json['mime'] as String?,
      accessDate: DateTime.tryParse(json['accessDate'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'path': path,
        'thumbnail': thumbnail,
        'size': size,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'accessDate': accessDate
      };

  Record copyWith(
      {List<Part>? stored,
      String? name,
      String? path,
      int? numOfParts,
      List<File>? thumbnail,
      String? folder,
      int? size,
      int? copyStatus,
      String? createdBy,
      String? updatedBy,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isChoosed,
      double? loadPercent,
      String? mimeType,
      bool? isInProgress,
      bool? copiedToAppFolder,
      bool? endedWithException,
      bool? favorite,
      bool? isDownloading,
      DateTime? accessDate}) {
    var extention =
        name != null ? name.split('.').last : this.name?.split('.').last;
    return Record(
        id: this.id,
        name: name ?? this.name,
        path: path ?? this.path,
        size: size ?? this.size,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        extension: extention ?? this.extension,
        isChoosed: isChoosed ?? this.isChoosed,
        thumbnail: thumbnail ?? this.thumbnail,
        folder: folder ?? this.parentFolder,
        loadPercent: loadPercent,
        mimeType: mimeType ?? this.mimeType,
        copiedToAppFolder: copiedToAppFolder ?? this.copiedToAppFolder,
        endedWithException: endedWithException ?? this.endedWithException,
        isInProgress: isInProgress ?? this.isInProgress,
        favorite: favorite ?? this.favorite,
        isDownloading: isDownloading,
        accessDate: accessDate ?? this.accessDate);
  }

  @override
  List<Object?> get props => [
        ...super.props,
        path,
        thumbnail,
        loadPercent,
        isChoosed,
        mimeType,
      ];
}
