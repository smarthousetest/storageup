import 'package:hive/hive.dart';
part 'download_location.g.dart';

@HiveType(typeId: 2)
class DownloadLocation {
  @HiveField(0)
  List<String>? dirPath;
  @HiveField(1)
  List<int>? countGb;

  DownloadLocation({
    this.dirPath,
    this.countGb,
  });

  DownloadLocation copyWith({
    List<String>? dirPath,
    List<int>? countGb,
  }) {
    return DownloadLocation(
      dirPath: dirPath ?? this.dirPath,
      countGb: countGb ?? this.countGb,
    );
  }

  @override
  String toString() {
    return 'dirPath: $dirPath, countGb: $countGb';
  }
}
