import 'package:hive/hive.dart';
import 'package:storageup/models/record.dart';

part 'latest_file.g.dart';

@HiveType(typeId: 3)
class LatestFile extends HiveObject {
  @HiveField(0)
  Record latestFile;

  LatestFile({
    required this.latestFile,
  });

  LatestFile copyWith({
    Record? latestFile,
  }) {
    return LatestFile(
      latestFile: latestFile ?? this.latestFile,
    );
  }

  @override
  String toString() {
    return 'latestFile: $latestFile';
  }
}
