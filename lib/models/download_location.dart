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
  @HiveField(3, defaultValue: '')
  String name;
  @HiveField(4, defaultValue: '')
  String keeperId;

  DownloadLocation({
    required this.dirPath,
    required this.countGb,
    required this.id,
    required this.name,
    required this.keeperId,
  });

  DownloadLocation copyWith({
    String? dirPath,
    int? countGb,
    String? name,
    String? idForCompare,
  }) {
    return DownloadLocation(
      dirPath: dirPath ?? this.dirPath,
      countGb: countGb ?? this.countGb,
      id: id,
      name: name ?? this.name,
      keeperId: idForCompare ?? this.keeperId,
    );
  }

  @override
  String toString() {
    return 'dirPath: $dirPath, countGb: $countGb, id: $id, name: $name, idForCompare: $keeperId';
  }
}
