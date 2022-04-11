import 'package:hive/hive.dart';
import 'package:upstorage_desktop/models/record.dart';
part 'latest_file.g.dart';

@HiveType(typeId: 3)
class LatestFile extends HiveObject {
  @HiveField(0)
  Record latestFile;
  @HiveField(1)
  int id;

  LatestFile({
    required this.latestFile,
    required this.id,
  });

  LatestFile copyWith({
    Record? latestFile,
  }) {
    return LatestFile(
      latestFile: latestFile ?? this.latestFile,
      id: id,
    );
  }

  @override
  String toString() {
    return 'dirPath: $latestFile,  id: $id';
  }
}
