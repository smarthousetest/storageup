import 'package:hive/hive.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file/file.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file/part.dart';
part 'record_file.g.dart';

@HiveType(typeId: 4)
class Record extends HiveObject {
  @HiveField(0)
  List<Part>? stored;
  @HiveField(1)
  String? path;
  @HiveField(2)
  int? numOfParts;
  @HiveField(3)
  List<File>? thumbnail;
  @HiveField(4)
  int? copyStatus;
  @HiveField(5)
  bool? isChoosed;
  @HiveField(6)
  double? loadPercent;

  Record({
    this.stored,
    this.path,
    this.numOfParts,
    this.thumbnail,
    this.copyStatus,
    this.isChoosed = false,
    this.loadPercent,
  });

  Record copyWith({
    List<Part>? stored,
    String? path,
    int? numOfParts,
    List<File>? thumbnail,
    int? copyStatus,
    bool? isChoosed,
    double? loadPercent,
  }) {
    return Record(
      stored: stored ?? this.stored,
      path: path ?? this.path,
      numOfParts: numOfParts ?? this.numOfParts,
      thumbnail: thumbnail ?? this.thumbnail,
      copyStatus: copyStatus ?? this.copyStatus,
      isChoosed: isChoosed ?? this.isChoosed,
      loadPercent: loadPercent,
    );
  }

  @override
  String toString() {
    return 'stored: $stored,  path: $path, numOfParts: $numOfParts, thumbnail: $thumbnail, copyStatus: $copyStatus, isChoosed: $isChoosed, loadPercent: $loadPercent';
  }
}
