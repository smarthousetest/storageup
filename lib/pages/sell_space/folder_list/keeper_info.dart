class KeeperInfo {
  String dirPath;
  String? name;
  int size;
  String dateTime;
  int? trustLevel;

  KeeperInfo(
      {required this.dirPath,
      required this.name,
      required this.size,
      required this.dateTime,
      required this.trustLevel});
}

List<KeeperInfo> listOfDirsKeepers = [];
