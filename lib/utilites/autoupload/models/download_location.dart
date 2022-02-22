import 'package:hive/hive.dart';
part 'download_location.g.dart';

@HiveType(typeId: 2)
class DownloadLocation {
  @HiveField(0)
  String dirPath;
  @HiveField(1)
  int countGb;
  @HiveField(2)
  int id;

  DownloadLocation({
    required this.dirPath,
    required this.countGb,
    required this.id,
  });

  DownloadLocation copyWith({
    String? dirPath,
    int? countGb,
  }) {
    return DownloadLocation(
      dirPath: dirPath ?? this.dirPath,
      countGb: countGb ?? this.countGb,
      id: id,
    );
  }

  @override
  String toString() {
    return 'dirPath: $dirPath, countGb: $countGb, id: $id';
  }
}
