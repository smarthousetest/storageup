import 'package:hive/hive.dart';

part 'upload_state.g.dart';

@HiveType(typeId: 0)
enum AutouploadState {
  @HiveField(0)
  inProgress,
  @HiveField(1)
  endedWithException,
  @HiveField(2)
  endedWithoutException,
  @HiveField(3)
  notSended,
}
