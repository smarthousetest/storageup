import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

class DownloadLocationsRepository {
  List<DownloadLocation> _locationsInfo = [];
  // List<int>? _countGb;

  List<DownloadLocation> get getlocationsInfo => _locationsInfo;

  set setlocationsInfo(List<DownloadLocation> locationsInfo) =>
      _locationsInfo = locationsInfo;

  // List<int>? get getCountGb => _countGb;

  // set saveCountGb(List<int>? countGb) => _countGb = countGb;
}
