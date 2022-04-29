import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'base_object.g.dart';

@HiveType(typeId: 4)
// ignore: must_be_immutable
class BaseObject extends Equatable {
  @HiveField(0)
  int size;
  @HiveField(1)
  String id;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? createdBy;
  @HiveField(4)
  String? updatedBy;
  @HiveField(5)
  DateTime? createdAt;
  @HiveField(6)
  DateTime? updatedAt;
  @HiveField(7)
  String? extension;
  @HiveField(8)
  bool isChoosed;
  @HiveField(9)
  bool favorite;
  @HiveField(10)
  double? loadPercent;
  @HiveField(16)
  String? parentFolder;
  @HiveField(17)
  bool isInProgress;
  @HiveField(18)
  bool endedWithException;
  @HiveField(19)
  bool copiedToAppFolder;
  @HiveField(20)
  bool? isDownloading;

  BaseObject(
      {required this.size,
      this.createdAt,
      this.createdBy,
      required this.id,
      this.name,
      this.updatedAt,
      this.updatedBy,
      this.extension,
      this.isChoosed = false,
      required this.favorite,
      this.loadPercent,
      this.parentFolder,
      this.copiedToAppFolder = false,
      this.endedWithException = false,
      this.isInProgress = false,
      this.isDownloading});

  @override
  List<Object?> get props => [
        size,
        id,
        createdAt,
        createdBy,
        favorite,
        name,
        updatedAt,
        updatedBy,
        extension,
        isChoosed,
        favorite,
        loadPercent,
        parentFolder,
        copiedToAppFolder,
        endedWithException,
        copiedToAppFolder,
        isDownloading,
      ];
}

/*abstract class ExtentionFind {
  String GetElementObjectFunction();
}*/
